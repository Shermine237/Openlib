import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://192.168.43.43:8000/api';  // Local backend
  static const String _tokenKey = 'auth_token';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']);
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la connexion');
      }
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

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
          'phone': phone,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'inscription');
      }
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
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
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de l\'envoi du mail de réinitialisation');
      }
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Échec de la réinitialisation du mot de passe');
      }
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
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
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
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
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
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
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
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
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
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
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
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
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
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
    } on SocketException {
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet ou que le serveur est en cours d\'exécution.');
    } on HttpException {
      throw Exception('Service non disponible. Veuillez réessayer plus tard.');
    } on FormatException {
      throw Exception('Réponse du serveur invalide. Veuillez contacter le support.');
    } catch (e) {
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }
}
