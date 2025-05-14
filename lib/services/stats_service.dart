import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:openlib/services/api_service.dart';
import 'package:openlib/services/local_storage_service.dart';

class StatsService {
  final ApiService _apiService;
  final LocalStorageService _storage;
  static const int _syncBatchSize = 10;

  DateTime? _startTime;
  String? _currentBookId;
  final Map<String, int> _pageReadDuration = {};
  final Map<String, int> _dailyReadingTime = {};

  StatsService(this._apiService, this._storage);

  static Future<StatsService> getInstance() async {
    return StatsService(
      ApiService(),
      await LocalStorageService.getInstance(),
    );
  }

  void startReading(String bookId) {
    _startTime = DateTime.now();
    _currentBookId = bookId;
    _pageReadDuration.clear();
  }

  void logPageRead(int pageNumber, int duration) {
    if (_startTime == null || _currentBookId == null) return;
    _pageReadDuration[pageNumber.toString()] = duration;
  }

  void _updateDailyReadingTime(int duration) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    _dailyReadingTime[today] = (_dailyReadingTime[today] ?? 0) + duration;
  }

  Future<void> endReading() async {
    if (_startTime == null || _currentBookId == null) return;

    final totalDuration = _pageReadDuration.values.fold(0, (sum, duration) => sum + duration);
    _updateDailyReadingTime(totalDuration);

    final stats = {
      'session': {
        'bookId': _currentBookId,
        'startTime': _startTime!.toIso8601String(),
        'endTime': DateTime.now().toIso8601String(),
        'pagesRead': _pageReadDuration.length,
        'totalDuration': totalDuration,
        'pageDetails': _pageReadDuration,
      },
      'userStats': {
        'totalSessions': 1,
        'totalBooks': 1,
        'averageSessionDuration': totalDuration.toDouble(),
        'completedBooks': _pageReadDuration.length == 100 ? 1 : 0,
        'currentBooks': [
          {
            'title': _currentBookId,
            'progress': (_pageReadDuration.length / 100 * 100).round(),
            'lastRead': DateTime.now().toIso8601String(),
            'totalTime': totalDuration
          }
        ]
      },
      'deviceInfo': {
        'platform': Platform.operatingSystem,
        'version': Platform.operatingSystemVersion,
        'locale': Platform.localeName,
        'appVersion': '1.0.0',
      },
      'activity': {
        'dates': _dailyReadingTime.keys.toList(),
        'readingTime': _dailyReadingTime.values.toList(),
      }
    };

    try {
      // Sauvegarder localement d'abord
      await _storage.saveReadingStats(stats);
      
      // Tenter de synchroniser les statistiques en attente
      await _syncPendingStats();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'envoi des statistiques: $e');
      }
    }

    _startTime = null;
    _currentBookId = null;
    _pageReadDuration.clear();
  }

  Future<void> _syncPendingStats() async {
    try {
      final stats = await _storage.getReadingStats();
      if (stats.isEmpty) return;

      // Synchroniser par lots
      const batchSize = _syncBatchSize;
      for (var i = 0; i < stats.length; i += batchSize) {
        final batch = stats.skip(i).take(batchSize).toList();
        await _apiService.sendReadingStats({'stats': batch});
        await _storage.clearSyncedStats(batch.length);
      }

      await _storage.updateLastSyncTime();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la synchronisation des statistiques: $e');
      }
    }
  }

  // Synchronisation périodique
  Future<void> periodicSync() async {
    final lastSync = await _storage.getLastSyncTime();
    final now = DateTime.now();
    
    // Synchroniser si pas de sync depuis 24h
    if (lastSync == null || now.difference(lastSync).inHours >= 24) {
      await _syncPendingStats();
    }
  }

  void pauseReading() {
    // Sauvegarder l'état actuel pour une reprise ultérieure
    if (_startTime != null && _currentBookId != null) {
      logPageRead(_pageReadDuration.length, 0); // Enregistrer la dernière page
    }
  }

  void resumeReading() {
    if (_currentBookId != null) {
      _startTime = DateTime.now();
    }
  }
}
