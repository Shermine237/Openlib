import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'https://192.168.43.43:8000/api';  // Local backend
  static const String _tokenKey = 'auth_token';

  // Singleton pattern
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

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['accessToken'] != null) {
          await saveToken(data['accessToken']);
        }
        return data;
      } else {
        throw Exception(data['message'] ?? data['error'] ?? 'Échec de la connexion');
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

  // User Profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/profile'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la récupération du profil');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/profile'),
        headers: await _getHeaders(),
        body: jsonEncode(profileData),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la mise à jour du profil');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Reading Progress
  Future<void> updateReadingProgress(String bookId, double progress) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reading-progress'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'bookId': bookId,
          'progress': progress,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la mise à jour de la progression de lecture');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getReadingStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/reading-stats'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la récupération des statistiques de lecture');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Book Management
  Future<void> addBookToLibrary(String bookId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/library/books'),
        headers: await _getHeaders(),
        body: jsonEncode({'bookId': bookId}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'ajout du livre à la bibliothèque');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getLibraryBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/library/books'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la récupération des livres de la bibliothèque');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<void> removeBookFromLibrary(String bookId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/library/books/$bookId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la suppression du livre de la bibliothèque');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Nouvelles méthodes pour les rapports
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

  Future<void> sendErrorReport(Map<String, dynamic> errorData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/error-reports'),
        headers: await _getHeaders(),
        body: jsonEncode(errorData),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'envoi du rapport d\'erreur');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<void> syncUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/preferences/sync'),
        headers: await _getHeaders(),
        body: jsonEncode(preferences),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la synchronisation des préférences');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  // Méthodes pour l'administration et les rapports
  Future<Map<String, dynamic>> getAdminDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/dashboard/stats'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la récupération des statistiques du tableau de bord');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getReadingReports({
    String? startDate,
    String? endDate,
    String? userId,
  }) async {
    try {
      final queryParams = {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (userId != null) 'userId': userId,
      };

      final uri = Uri.parse('$baseUrl/admin/reports/reading').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la récupération des rapports de lecture');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getErrorReports({
    String? startDate,
    String? endDate,
    String? errorType,
  }) async {
    try {
      final queryParams = {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (errorType != null) 'type': errorType,
      };

      final uri = Uri.parse('$baseUrl/admin/reports/errors').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la récupération des rapports d\'erreurs');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserPreferencesReport() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/reports/preferences'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la récupération des préférences utilisateurs');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getBookAnalytics(String bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/analytics/books/$bookId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la récupération des analyses du livre');
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
