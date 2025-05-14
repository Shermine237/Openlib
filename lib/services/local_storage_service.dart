import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  late SharedPreferences _prefs;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  Future<void> saveReadingStats(Map<String, dynamic> stats) async {
    final statsJson = json.encode(stats);
    await _prefs.setString('reading_stats_${DateTime.now().toIso8601String()}', statsJson);
  }

  Future<List<Map<String, dynamic>>> getReadingStats() async {
    final stats = <Map<String, dynamic>>[];
    final keys = _prefs.getKeys().where((key) => key.startsWith('reading_stats_'));
    
    for (final key in keys) {
      final statsJson = _prefs.getString(key);
      if (statsJson != null) {
        stats.add(json.decode(statsJson));
      }
    }
    
    return stats;
  }

  Future<void> clearSyncedStats(int count) async {
    final keys = _prefs.getKeys()
        .where((key) => key.startsWith('reading_stats_'))
        .take(count);
    
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  Future<DateTime?> getLastSyncTime() async {
    final timeStr = _prefs.getString('last_sync_time');
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }

  Future<void> updateLastSyncTime() async {
    await _prefs.setString('last_sync_time', DateTime.now().toIso8601String());
  }

  Future<void> queueError(Map<String, dynamic> error) async {
    final errorJson = json.encode(error);
    await _prefs.setString('error_${DateTime.now().toIso8601String()}', errorJson);
  }

  Future<List<Map<String, dynamic>>> getErrorQueue() async {
    final errors = <Map<String, dynamic>>[];
    final keys = _prefs.getKeys().where((key) => key.startsWith('error_'));
    
    for (final key in keys) {
      final errorJson = _prefs.getString(key);
      if (errorJson != null) {
        errors.add(json.decode(errorJson));
      }
    }
    
    return errors;
  }

  Future<void> clearSyncedErrors(int count) async {
    final keys = _prefs.getKeys()
        .where((key) => key.startsWith('error_'))
        .take(count);
    
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
