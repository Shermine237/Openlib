import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:openlib/services/api_service.dart';
import 'package:openlib/services/local_storage_service.dart';

class StatsService {
  final ApiService _apiService;
  final LocalStorageService _storage;

  String? _currentBookId;
  bool _isReading = false;
  int _startPage = 0;
  int _currentPage = 0;
  int _totalPages = 0;

  StatsService(this._apiService, this._storage);

  static Future<StatsService> getInstance() async {
    return StatsService(
      ApiService(),
      await LocalStorageService.getInstance(),
    );
  }

  Future<void> startReading(String bookId, {int initialPage = 0, int totalPages = 0}) async {
    _currentBookId = bookId;
    _isReading = true;
    _startPage = initialPage;
    _currentPage = initialPage;
    _totalPages = totalPages;
  }

  Future<void> endReading() async {
    if (_isReading && _currentBookId != null) {
      await _sendSessionData();
      _isReading = false;
      _currentBookId = null;
    }
  }

  Future<void> logPageRead(int page) async {
    _currentPage = page;
  }

  Future<void> _sendSessionData() async {
    if (_currentBookId == null) return;

    final sessionData = {
      'bookId': _currentBookId,
      'pagesRead': _currentPage - _startPage,
      'currentPage': _currentPage,
      'totalPages': _totalPages,
      'deviceInfo': await _getDeviceInfo(),
    };

    try {
      await _apiService.sendReadingSession(sessionData);
      if (kDebugMode) {
        print('Session envoyée avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'envoi des données: $e');
        print('Sauvegarde en local pour synchronisation ultérieure');
      }
      await _storage.savePendingSession(sessionData);
    }
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return {
          'deviceModel': '${androidInfo.brand} ${androidInfo.model}',
          'platform': 'Android',
          'osVersion': androidInfo.version.release,
          'appVersion': '1.0.0',
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return {
          'deviceModel': '${iosInfo.name} ${iosInfo.model}',
          'platform': 'iOS',
          'osVersion': iosInfo.systemVersion,
          'appVersion': '1.0.0',
        };
      } else {
        return {
          'deviceModel': 'Desktop',
          'platform': Platform.operatingSystem,
          'osVersion': Platform.operatingSystemVersion,
          'appVersion': '1.0.0',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des informations de l\'appareil: $e');
      }
      return {
        'deviceModel': 'Unknown',
        'platform': Platform.operatingSystem,
        'osVersion': 'Unknown',
        'appVersion': '1.0.0',
      };
    }
  }

  Future<void> syncPendingData() async {
    try {
      // 1. Synchroniser les sessions en attente
      final pendingSessions = await _storage.getPendingSessions();
      for (var session in pendingSessions) {
        try {
          await _apiService.sendReadingSession(session);
        } catch (e) {
          continue;
        }
      }
      await _storage.clearSyncedSessions(pendingSessions.length);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la synchronisation: $e');
      }
    }
  }
}
