import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  return AuthStateNotifier();
});

class AuthStateNotifier extends StateNotifier<bool> {
  AuthStateNotifier() : super(false);

  void setAuthenticated(bool value) {
    state = value;
  }

  void logout(BuildContext context) {
    state = false;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
