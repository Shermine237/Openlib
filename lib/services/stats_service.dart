import 'package:flutter/foundation.dart';
import 'package:openlib/services/api_service.dart';

class StatsService {
  static final StatsService _instance = StatsService._internal();
  factory StatsService() => _instance;
  StatsService._internal();

  final ApiService _apiService = ApiService();
  DateTime? _startTime;
  String? _currentBookId;
  final Map<String, int> _pageReadDuration = {};

  void startReading(String bookId) {
    _startTime = DateTime.now();
    _currentBookId = bookId;
    _pageReadDuration.clear();
  }

  void logPageRead(int pageNumber) {
    if (_startTime == null || _currentBookId == null) return;
    
    final now = DateTime.now();
    final duration = now.difference(_startTime!).inSeconds;
    _pageReadDuration[pageNumber.toString()] = duration;
  }

  Future<void> endReading() async {
    if (_startTime == null || _currentBookId == null) return;

    final stats = {
      'bookId': _currentBookId,
      'startTime': _startTime!.toIso8601String(),
      'endTime': DateTime.now().toIso8601String(),
      'pagesRead': _pageReadDuration.length,
      'totalDuration': _pageReadDuration.values.fold(0, (sum, duration) => sum + duration),
      'pageDetails': _pageReadDuration,
    };

    try {
      await _apiService.sendReadingStats(stats);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'envoi des statistiques: $e');
      }
    }

    // Réinitialiser les données
    _startTime = null;
    _currentBookId = null;
    _pageReadDuration.clear();
  }

  void pauseReading() {
    // Sauvegarder l'état actuel pour une reprise ultérieure
    if (_startTime != null && _currentBookId != null) {
      logPageRead(_pageReadDuration.length); // Enregistrer la dernière page
    }
  }

  void resumeReading() {
    if (_currentBookId != null) {
      _startTime = DateTime.now();
    }
  }
}
