import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:openlib/services/stats_service.dart';
import 'package:openlib/services/error_reporting_service.dart';

class SyncService {
  final StatsService _statsService;
  final ErrorReportingService _errorService;
  static const Duration _syncInterval = Duration(hours: 1);

  SyncService(this._statsService, this._errorService) {
    _startPeriodicSync();
  }

  void _startPeriodicSync() {
    Timer.periodic(_syncInterval, (_) => _sync());
  }

  Future<void> _sync() async {
    try {
      await _statsService.periodicSync();
      await _errorService.periodicSync();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Erreur lors de la synchronisation: $e');
      }
    }
  }

  static Future<SyncService> getInstance() async {
    return SyncService(
      await StatsService.getInstance(),
      await ErrorReportingService.getInstance(),
    );
  }

  void startPeriodicSync() {
    // Synchroniser toutes les heures
    _startPeriodicSync();
  }

  void stopPeriodicSync() {
    // _syncTimer?.cancel();
    // _syncTimer = null;
  }

  // Forcer une synchronisation immédiate
  Future<void> forceSyncNow() async {
    await _sync();
  }
}
