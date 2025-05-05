import 'package:flutter/material.dart';
import 'package:openlib/services/api_service.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/foundation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'CM');

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // S'assurer que le numéro de téléphone est complet avec l'indicatif pays
      final phoneNumber = _phoneNumber.phoneNumber?.replaceAll(' ', '');
      if (phoneNumber == null || phoneNumber.isEmpty || !phoneNumber.startsWith('+')) {
        throw Exception('Le numéro de téléphone est requis et doit inclure l\'indicatif pays');
      }

      if (kDebugMode) {
        print('Sending registration with phone: $phoneNumber');
      }

      // Envoyer le numéro au format international sans espaces
      await ApiService().register(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: phoneNumber,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription réussie ! Veuillez vérifier votre email pour confirmer votre compte.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (kDebugMode) {
        print('REGISTER ERROR: $e');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('Le numéro de téléphone est requis')
                ? 'Veuillez entrer un numéro de téléphone valide'
                : 'Une erreur est survenue lors de l\'inscription. Veuillez réessayer.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Inscription',
          style: theme.textTheme.displayLarge?.copyWith(
            color: theme.colorScheme.tertiary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Image.asset(
                    'assets/icons/appIcon.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nom et Prenom',
                    labelStyle: TextStyle(color: theme.colorScheme.tertiary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.secondary),
                    ),
                    fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
                    filled: true,
                  ),
                  style: TextStyle(color: theme.colorScheme.tertiary),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom d\'utilisateur';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: theme.colorScheme.tertiary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.secondary),
                    ),
                    fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
                    filled: true,
                  ),
                  style: TextStyle(color: theme.colorScheme.tertiary),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.tertiary,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: isDark ? Colors.black12 : Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      _phoneNumber = number;
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                    ),
                    initialValue: _phoneNumber,
                    formatInput: true,
                    keyboardType: TextInputType.phone,
                    inputDecoration: InputDecoration(
                      labelText: 'Numéro de téléphone',
                      labelStyle: TextStyle(color: theme.colorScheme.tertiary),
                      border: InputBorder.none,
                    ),
                    selectorTextStyle: TextStyle(color: theme.colorScheme.tertiary),
                    textStyle: TextStyle(color: theme.colorScheme.tertiary),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: theme.colorScheme.tertiary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.secondary),
                    ),
                    fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: theme.colorScheme.tertiary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: theme.colorScheme.tertiary),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    labelStyle: TextStyle(color: theme.colorScheme.tertiary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.tertiary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.secondary),
                    ),
                    fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: theme.colorScheme.tertiary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: theme.colorScheme.tertiary),
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.surface,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.6),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.surface,
                            ),
                          ),
                        )
                      : const Text(
                          'S\'inscrire',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Déjà un compte ? Se connecter',
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
