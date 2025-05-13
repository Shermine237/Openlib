import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'https://192.168.43.43:8000/api';
  static const String _tokenKey = 'auth_token';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    HttpOverrides.global = _DevHttpOverrides();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['accessToken'] != null) {
          await saveToken(data['accessToken']);
        }
        return data;
      } else {
        throw Exception(data['message'] ?? data['error'] ?? 'Échec de la connexion');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Envoi des statistiques de lecture
  Future<void> sendReadingStats(Map<String, dynamic> stats) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reading-stats'),
        headers: await _getHeaders(),
        body: jsonEncode(stats),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'envoi des statistiques');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Synchronisation des préférences
  Future<void> syncUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final userPrefs = {
        'preferences': {
          'theme': preferences['theme'] ?? 'light',
          'language': preferences['language'] ?? 'fr',
          'pdfReader': preferences['pdfReader'] ?? 'default',
          'epubReader': preferences['epubReader'] ?? 'default'
        },
        'deviceInfo': {
          'platform': Platform.operatingSystem,
          'version': Platform.operatingSystemVersion,
          'locale': Platform.localeName,
          'appVersion': '1.0.0',
        }
      };

      final response = await http.post(
        Uri.parse('$baseUrl/users/preferences/sync'),
        headers: await _getHeaders(),
        body: jsonEncode(userPrefs),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la synchronisation des préférences');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Envoi des rapports d'erreur
  Future<void> sendErrorReport(Map<String, dynamic> report) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/error-reports'),
        headers: await _getHeaders(),
        body: jsonEncode(report),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'envoi du rapport d\'erreur');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }
}

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
