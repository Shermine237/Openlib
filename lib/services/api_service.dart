import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' show BuildContext;
import '../state/auth_state.dart';

class ApiService {
  static const String baseUrl = 'https://192.168.43.43:8000/api';
  static const String _tokenKey = 'auth_token';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    HttpOverrides.global = _DevHttpOverrides();
  }

  final _ref = ProviderContainer();

  Future<void> _handleTokenExpired(BuildContext? context) async {
    await removeToken();
    if (context != null && context.mounted) {  
      _ref.read(authStateProvider.notifier).logout(context);
    }
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
    if (kDebugMode) {
      print('Token utilisé pour les headers: $token');
    }
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Authentication
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'phoneNumber': phone,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? error['error'] ?? 'Échec de l\'inscription');
      }
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      if (kDebugMode) {
        print('Tentative de connexion avec: $email');
      }
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (kDebugMode) {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) {
          print('Token reçu: ${data['accessToken']}');
          print('Email reçu: ${data['email']}');
        }
        await saveToken(data['accessToken']);
        // Sauvegarder l'email
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', data['email']);
        _ref.read(authStateProvider.notifier).setAuthenticated(true);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? error['error'] ?? 'Échec de la connexion');
      }
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
    } catch (e) {
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      if (kDebugMode) {
        print('Tentative de réinitialisation du mot de passe pour: $email');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/password/reset-request'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (kDebugMode) {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? error['error'] ?? 'Une erreur est survenue lors de la réinitialisation du mot de passe');
      }
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Envoi des statistiques de lecture
  Future<void> sendReadingStats(Map<String, dynamic> stats, [BuildContext? context]) async {
    try {
      final headers = await _getHeaders();
      // Laisser le backend résoudre l'utilisateur via le JWT (pas d'override userId ici)

      if (kDebugMode) {
        print('Headers pour sendReadingStats: $headers');
        print('Stats envoyées: $stats');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/reading/stats'),
        headers: headers,
        body: jsonEncode(stats),
      );

      if (kDebugMode) {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 401) {
        // Token expiré, déconnexion de l'utilisateur
        if (context == null || !context.mounted) {
          await removeToken();  
        } else {
          await _handleTokenExpired(context);
        }
        throw TokenExpiredException('Session expirée. Veuillez vous reconnecter.');
      } else if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'envoi des statistiques');
      }
    } on http.ClientException catch (e) {
      throw Exception('Erreur de connexion: ${e.message}');
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Synchronisation des préférences
  Future<void> syncUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final userPrefs = {
        // Format attendu par le backend UserController
        'themeMode': preferences['theme'] ?? preferences['themeMode'] ?? 'system',
        'locale': preferences['language'] ?? preferences['locale'] ?? 'fr',
        'openPdfWithExternalApp': preferences['openPdfWithExternalApp'] ?? false,
        'openEpubWithExternalApp': preferences['openEpubWithExternalApp'] ?? false,
        // Champs optionnels supportés par le backend
        'fontSize': preferences['fontSize'],
        'lineSpacing': preferences['lineSpacing'],
        'nightMode': preferences['nightMode'],
        'notificationsEnabled': preferences['notificationsEnabled'],
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

  // Envoi des informations de l'appareil
  Future<void> sendDeviceInfo(String userId, Map<String, String> deviceInfo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/device'),
      headers: await _getHeaders(),
      body: jsonEncode(deviceInfo),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Échec de l\'envoi des informations de l\'appareil');
    }
  }

  // Envoi des rapports d'erreur
  Future<void> sendErrorReport(Map<String, dynamic> errorReport) async {
    final token = await getToken();
    if (token == null) {
      throw 'Non authentifié';
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/errors'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(errorReport),
      );

      if (response.statusCode >= 500) {
        throw 'Erreur serveur temporaire, réessayez plus tard';
      } else if (response.statusCode != 200) {
        String message;
        try {
          final error = json.decode(response.body);
          message = error['message'] ?? 'Erreur inconnue';
        } catch (_) {
          message = 'Erreur HTTP ${response.statusCode}';
        }
        throw message;
      }
    } on http.ClientException catch (e) {
      throw 'Erreur de connexion: ${e.message}';
    } catch (e) {
      if (e is String) rethrow;
      throw 'Erreur inattendue: $e';
    }
  }

  // Envoi d'une session de lecture
  Future<void> sendReadingSession(Map<String, dynamic> sessionData) async {
    try {
      final headers = await _getHeaders();
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('user_email');
      
      if (userEmail == null) {
        throw Exception('Utilisateur non authentifié');
      }

      if (kDebugMode) {
        print('Headers pour sendReadingSession: $headers');
        print('Session data envoyée: $sessionData');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/reading/sessions'),
        headers: headers,
        body: jsonEncode(sessionData),
      );

      if (kDebugMode) {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      if (response.statusCode == 401) {
        await removeToken();
        throw TokenExpiredException('Session expirée. Veuillez vous reconnecter.');
      } else if (response.statusCode != 200 && response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'envoi de la session de lecture');
      }
    } on http.ClientException catch (e) {
      throw Exception('Erreur de connexion: ${e.message}');
    } catch (e) {
      if (e is TokenExpiredException) rethrow;
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Mise à jour de la progression de lecture
  Future<void> updateReadingProgress(Map<String, dynamic> progressData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reading/progress'),
      headers: await _getHeaders(),
      body: jsonEncode(progressData),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour de la progression');
    }
  }

  // Mise à jour de l'activité quotidienne
  Future<void> updateDailyActivity(Map<String, dynamic> activityData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reading/activity'),
      headers: await _getHeaders(),
      body: jsonEncode(activityData),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Échec de la mise à jour de l\'activité quotidienne');
    }
  }
}

// Exception personnalisée pour le token expiré
class TokenExpiredException implements Exception {
  final String message;
  TokenExpiredException(this.message);
  @override
  String toString() => message;
}

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
