import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String initialRoute;
  
  const SplashScreen({super.key, required this.initialRoute});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _sloganController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _sloganAnimation;

  @override
  void initState() {
    super.initState();
    
    // Démarrer l'initialisation de l'application en parallèle
    _initializeApp();
    
    // Animation du logo
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Animation du texte
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    // Animation du slogan
    _sloganController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _sloganAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sloganController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
    ));

    // Démarrer les animations
    _scaleController.forward();
    _fadeController.forward();
    _sloganController.forward();
  }

  // Initialiser l'application en parallèle
  Future<void> _initializeApp() async {
    // Attendre que l'application soit initialisée
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, widget.initialRoute);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _sloganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo avec animation d'échelle élastique
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.secondary.withAlpha(60),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/icons/appIcon.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Texte avec animation de fondu
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Megalib',
                style: TextStyle(
                  fontSize: 28,
                  color: Theme.of(context).colorScheme.onSurface,  // Couleur du texte sur la surface
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Slogan avec animation de fondu
            FadeTransition(
              opacity: _sloganAnimation,
              child: Text(
                'Votre bibliothèque numérique',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),  // Version plus claire
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
