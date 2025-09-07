import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _userIdKey = 'userId';
  static const String _deviceInfoSentKey = 'deviceInfoSent';
  static const String _readingStatsKey = 'readingStats';
  static const String _pendingSessionsKey = 'pendingSessions';
  static const String _lastSyncTimeKey = 'lastSyncTime';
  static const String _errorKey = 'error_';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  Future<void> setUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  Future<bool> getDeviceInfoSent() async {
    return _prefs.getBool(_deviceInfoSentKey) ?? false;
  }

  Future<void> setDeviceInfoSent(bool sent) async {
    await _prefs.setBool(_deviceInfoSentKey, sent);
  }

  Future<List<Map<String, dynamic>>> getReadingStats() async {
    final String? statsJson = _prefs.getString(_readingStatsKey);
    if (statsJson == null) return [];

    List<dynamic> statsList = jsonDecode(statsJson);
    return statsList.cast<Map<String, dynamic>>();
  }

  Future<void> saveReadingStats(Map<String, dynamic> stats) async {
    final List<Map<String, dynamic>> existingStats = await getReadingStats();
    existingStats.add(stats);
    await _prefs.setString(_readingStatsKey, jsonEncode(existingStats));
  }

  Future<void> clearSyncedStats(int count) async {
    final List<Map<String, dynamic>> stats = await getReadingStats();
    if (count >= stats.length) {
      await _prefs.remove(_readingStatsKey);
    } else {
      final remainingStats = stats.sublist(count);
      await _prefs.setString(_readingStatsKey, jsonEncode(remainingStats));
    }
  }

  Future<void> updateLastSyncTime() async {
    await _prefs.setString(_lastSyncTimeKey, DateTime.now().toIso8601String());
  }

  Future<DateTime?> getLastSyncTime() async {
    final String? timeStr = _prefs.getString(_lastSyncTimeKey);
    return timeStr != null ? DateTime.parse(timeStr) : null;
  }

  Future<void> queueError(Map<String, dynamic> error) async {
    final errorJson = jsonEncode(error);
    await _prefs.setString('$_errorKey${DateTime.now().toIso8601String()}', errorJson);
  }

  Future<List<Map<String, dynamic>>> getErrorQueue() async {
    final errors = <Map<String, dynamic>>[];
    final keys = _prefs.getKeys().where((key) => key.startsWith(_errorKey));
    
    for (final key in keys) {
      final errorJson = _prefs.getString(key);
      if (errorJson != null) {
        errors.add(jsonDecode(errorJson));
      }
    }
    
    return errors;
  }

  Future<void> clearSyncedErrors(int count) async {
    final keys = _prefs.getKeys()
        .where((key) => key.startsWith(_errorKey))
        .take(count);
    
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  // Gestion des sessions de lecture en attente
  Future<List<Map<String, dynamic>>> getPendingSessions() async {
    final String? sessionsJson = _prefs.getString(_pendingSessionsKey);
    if (sessionsJson == null) return [];

    List<dynamic> sessionsList = jsonDecode(sessionsJson);
    return sessionsList.cast<Map<String, dynamic>>();
  }

  Future<void> savePendingSession(Map<String, dynamic> sessionData) async {
    final List<Map<String, dynamic>> existingSessions = await getPendingSessions();
    
    // Ajouter un timestamp pour traçabilité
    sessionData['timestamp'] = DateTime.now().toIso8601String();
    
    existingSessions.add(sessionData);
    await _prefs.setString(_pendingSessionsKey, jsonEncode(existingSessions));
  }

  Future<void> clearSyncedSessions(int count) async {
    final List<Map<String, dynamic>> sessions = await getPendingSessions();
    if (count >= sessions.length) {
      await _prefs.remove(_pendingSessionsKey);
    } else {
      final remainingSessions = sessions.sublist(count);
      await _prefs.setString(_pendingSessionsKey, jsonEncode(remainingSessions));
    }
  }

  // Remplacer la file des sessions en attente par une nouvelle liste (sécurisé)
  Future<void> replacePendingSessions(List<Map<String, dynamic>> sessions) async {
    if (sessions.isEmpty) {
      await _prefs.remove(_pendingSessionsKey);
    } else {
      await _prefs.setString(_pendingSessionsKey, jsonEncode(sessions));
    }
  }

  Future<int> getPendingSessionsCount() async {
    final sessions = await getPendingSessions();
    return sessions.length;
  }

  Future<void> clearAllPendingSessions() async {
    await _prefs.remove(_pendingSessionsKey);
  }
}
