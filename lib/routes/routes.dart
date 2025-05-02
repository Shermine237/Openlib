import 'package:flutter/material.dart';
import 'package:openlib/screens/auth/login_screen.dart';
import 'package:openlib/screens/auth/register_screen.dart';
import 'package:openlib/screens/auth/forgot_password_screen.dart';
import 'package:openlib/ui/home_page.dart';
import 'package:openlib/ui/mylibrary_page.dart';
import 'package:openlib/ui/search_page.dart';
import 'package:openlib/ui/settings_page.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String myLibrary = '/my-library';
  static const String search = '/search';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const HomePage(),
      myLibrary: (context) => const MyLibraryPage(),
      search: (context) => const SearchPage(),
      settings: (context) => const SettingsPage(),
    };
  }
}
