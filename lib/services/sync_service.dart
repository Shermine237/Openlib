import 'dart:async';
import 'package:openlib/services/stats_service.dart';
import 'package:openlib/services/error_reporting_service.dart';

class SyncService {
  final StatsService _statsService;
  final ErrorReportingService _errorService;
  Timer? _syncTimer;

  SyncService(this._statsService, this._errorService);

  static Future<SyncService> getInstance() async {
    return SyncService(
      await StatsService.getInstance(),
      await ErrorReportingService.getInstance(),
    );
  }

  void startPeriodicSync() {
    // Synchroniser toutes les heures
    _syncTimer = Timer.periodic(const Duration(hours: 1), (_) => _sync());
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> _sync() async {
    try {
      await _statsService.periodicSync();
      await _errorService.periodicSync();
    } catch (e) {
      print('Erreur lors de la synchronisation périodique: $e');
    }
  }

  // Forcer une synchronisation immédiate
  Future<void> forceSyncNow() async {
    await _sync();
  }
}
