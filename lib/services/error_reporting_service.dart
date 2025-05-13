import 'package:flutter/foundation.dart';
import 'package:openlib/services/api_service.dart';
import 'package:openlib/services/local_storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class ErrorReportingService {
  final ApiService _apiService;
  final LocalStorageService _storage;
  static const int _syncBatchSize = 5;
  String? _currentAction;
  List<String> _recentLogs = [];
  static const int _maxLogs = 50;

  ErrorReportingService(this._apiService, this._storage);

  static Future<ErrorReportingService> getInstance() async {
    return ErrorReportingService(
      ApiService(),
      await LocalStorageService.getInstance(),
    );
  }

  void setCurrentAction(String action) {
    _currentAction = action;
  }

  void addLog(String log) {
    _recentLogs.add('${DateTime.now().toIso8601String()}: $log');
    if (_recentLogs.length > _maxLogs) {
      _recentLogs.removeAt(0);
    }
  }

  Future<Map<String, dynamic>> _buildErrorReport(dynamic error, StackTrace stackTrace) async {
    final packageInfo = await PackageInfo.fromPlatform();
    
    return {
      'error': {
        'timestamp': DateTime.now().toIso8601String(),
        'type': error.runtimeType.toString(),
        'message': error.toString(),
        'stackTrace': stackTrace.toString(),
        'currentAction': _currentAction,
        'recentLogs': _recentLogs,
      },
      'deviceInfo': {
        'platform': Platform.operatingSystem,
        'version': Platform.operatingSystemVersion,
        'locale': Platform.localeName,
        'appVersion': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      }
    };
  }

  Future<void> reportError(dynamic error, StackTrace stackTrace) async {
    try {
      final errorReport = await _buildErrorReport(error, stackTrace);
      
      // Sauvegarder l'erreur localement d'abord
      await _storage.queueError(errorReport);
      
      // Tenter de synchroniser les erreurs en attente
      await _syncPendingErrors();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'envoi du rapport: $e');
      }
    }
  }

  Future<void> _syncPendingErrors() async {
    try {
      final errors = await _storage.getErrorQueue();
      if (errors.isEmpty) return;

      // Synchroniser par lots
      final batchSize = _syncBatchSize;
      for (var i = 0; i < errors.length; i += batchSize) {
        final batch = errors.skip(i).take(batchSize).toList();
        await _apiService.sendErrorReport({'errors': batch});
        await _storage.clearSyncedErrors(batch.length);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la synchronisation des erreurs: $e');
      }
    }
  }

  // Synchronisation périodique
  Future<void> periodicSync() async {
    final lastSync = await _storage.getLastSyncTime();
    final now = DateTime.now();
    
    // Synchroniser si pas de sync depuis 1h
    if (lastSync == null || now.difference(lastSync).inHours >= 1) {
      await _syncPendingErrors();
    }
  }
}
