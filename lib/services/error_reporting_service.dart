import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:openlib/services/api_service.dart';

class ErrorReportingService {
  static final ErrorReportingService _instance = ErrorReportingService._internal();
  factory ErrorReportingService() => _instance;
  ErrorReportingService._internal();

  final ApiService _apiService = ApiService();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<void> reportError(dynamic error, StackTrace stackTrace) async {
    try {
      final errorReport = await _buildErrorReport(error, stackTrace);
      await _apiService.sendErrorReport(errorReport);
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'envoi du rapport: $e');
      }
    }
  }

  Future<Map<String, dynamic>> _buildErrorReport(dynamic error, StackTrace stackTrace) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final Map<String, dynamic> deviceData = await _getDeviceInfo();

    return {
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'appInfo': {
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      },
      'deviceInfo': deviceData,
    };
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return {
        'platform': 'Android',
        'version': androidInfo.version.release,
        'sdkInt': androidInfo.version.sdkInt,
        'manufacturer': androidInfo.manufacturer,
        'model': androidInfo.model,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return {
        'platform': 'iOS',
        'systemName': iosInfo.systemName,
        'systemVersion': iosInfo.systemVersion,
        'model': iosInfo.model,
        'localizedModel': iosInfo.localizedModel,
      };
    }
    return {
      'platform': 'Unknown',
    };
  }
}
