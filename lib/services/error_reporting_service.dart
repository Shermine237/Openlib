import 'package:flutter/foundation.dart';
import 'package:openlib/services/api_service.dart';
import 'package:openlib/services/local_storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class ErrorReportingService {
  final ApiService _apiService;
  final LocalStorageService _storage;
  static const int _syncBatchSize = 5;
  static const int _maxLogs = 50;
  String? _currentAction;
  final List<String> _recentLogs = [];

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
    
    // Format attendu par le backend ErrorReportController
    return {
      'type': error.runtimeType.toString(),
      'message': error.toString(),
      'stackTrace': stackTrace.toString(),
      'device': '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      'os': Platform.operatingSystem,
      'appVersion': packageInfo.version,
      // Ajouter des informations supplémentaires dans le message si nécessaire
      'additionalInfo': {
        'currentAction': _currentAction,
        'recentLogs': _recentLogs,
        'buildNumber': packageInfo.buildNumber,
        'locale': Platform.localeName,
      }.toString(),
    };
  }

  Future<void> reportError(dynamic error, StackTrace stackTrace) async {
    try {
      final errorReport = await _buildErrorReport(error, stackTrace);
      
      // Sauvegarder l'erreur localement d'abord
      await _storage.queueError(errorReport);
      
      // Tenter de synchroniser les erreurs en attente
      await _syncPendingErrors();
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Erreur lors de l\'envoi du rapport: $e\n$stack');
      }
      // Ne pas relancer l'erreur pour éviter une boucle infinie
    }
  }

  Future<void> _syncPendingErrors() async {
    try {
      final errors = await _storage.getErrorQueue();
      if (errors.isEmpty) return;

      // Synchroniser par lots
      for (var i = 0; i < errors.length; i += _syncBatchSize) {
        final batch = errors.skip(i).take(_syncBatchSize).toList();
        
        // Tentatives avec délai exponentiel
        int retryCount = 0;
        const maxRetries = 3;
        const initialDelayMs = 1000;

        while (retryCount < maxRetries) {
          try {
            // Envoyer chaque erreur individuellement au backend
            for (final errorReport in batch) {
              await _apiService.sendErrorReport(errorReport);
            }
            
            // Supprimer les erreurs synchronisées avec succès
            await _storage.clearSyncedErrors(batch.length);
            
            // Sortir de la boucle si succès
            break;
          } catch (e) {
            retryCount++;
            
            if (e.toString().contains('temporaire') && retryCount < maxRetries) {
              // Attendre avant de réessayer avec un délai exponentiel
              final delay = initialDelayMs * (1 << (retryCount - 1));
              if (kDebugMode) {
                debugPrint('Tentative $retryCount échouée, nouvelle tentative dans ${delay}ms');
              }
              await Future.delayed(Duration(milliseconds: delay));
              continue;
            }
            
            if (kDebugMode) {
              debugPrint('Échec de la synchronisation du lot ${i ~/ _syncBatchSize + 1}: $e');
            }
            // Arrêter la synchronisation en cas d'erreur non temporaire
            rethrow;
          }
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Erreur lors de la synchronisation des erreurs: $e\n$stack');
      }
      // Ne pas relancer l'erreur pour éviter une boucle infinie
    }
  }

  // Synchronisation périodique
  Future<void> periodicSync() async {
    try {
      await _syncPendingErrors();
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Erreur lors de la synchronisation périodique: $e\n$stack');
      }
      // Ne pas relancer l'erreur pour éviter une boucle infinie
    }
  }
}
