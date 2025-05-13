import 'dart:convert';
import 'package:shared_preferences.dart';

class LocalStorageService {
  static const String _statsKey = 'reading_stats';
  static const String _preferencesKey = 'user_preferences';
  static const String _errorQueueKey = 'error_queue';
  static const String _lastSyncKey = 'last_sync';
  
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Statistiques de lecture
  Future<void> saveReadingStats(Map<String, dynamic> stats) async {
    final storedStats = await getReadingStats();
    storedStats.add(stats);
    await _prefs.setString(_statsKey, jsonEncode(storedStats));
  }

  Future<List<Map<String, dynamic>>> getReadingStats() async {
    final String? stats = _prefs.getString(_statsKey);
    if (stats == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(stats));
  }

  Future<void> clearSyncedStats(int count) async {
    final stats = await getReadingStats();
    await _prefs.setString(_statsKey, jsonEncode(stats.skip(count).toList()));
  }

  // Préférences utilisateur
  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    await _prefs.setString(_preferencesKey, jsonEncode(preferences));
  }

  Future<Map<String, dynamic>?> getPreferences() async {
    final String? prefs = _prefs.getString(_preferencesKey);
    if (prefs == null) return null;
    return Map<String, dynamic>.from(jsonDecode(prefs));
  }

  // File d'attente des erreurs
  Future<void> queueError(Map<String, dynamic> error) async {
    final errors = await getErrorQueue();
    errors.add(error);
    await _prefs.setString(_errorQueueKey, jsonEncode(errors));
  }

  Future<List<Map<String, dynamic>>> getErrorQueue() async {
    final String? errors = _prefs.getString(_errorQueueKey);
    if (errors == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(errors));
  }

  Future<void> clearSyncedErrors(int count) async {
    final errors = await getErrorQueue();
    await _prefs.setString(_errorQueueKey, jsonEncode(errors.skip(count).toList()));
  }

  // Gestion de la synchronisation
  Future<DateTime?> getLastSyncTime() async {
    final String? timestamp = _prefs.getString(_lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  Future<void> updateLastSyncTime() async {
    await _prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }
}
