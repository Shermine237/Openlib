import 'package:flutter/material.dart';
import 'package:openlib/screens/auth/login_screen.dart';
import 'package:openlib/screens/auth/register_screen.dart';
import 'package:openlib/ui/home_page.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomePage(),
    };
  }
}
