import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String initialRoute;
  
  const SplashScreen({super.key, required this.initialRoute});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialiser les animations immédiatement
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Démarrer l'animation immédiatement
    _controller.forward();

    // Navigation après l'animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.pushReplacementNamed(context, widget.initialRoute);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo avec animation de scale
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    Icons.library_books,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                // Titre avec animation de slide
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
                  )),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
                    )),
                    child: Text(
                      'Megalib',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Sous-titre avec animation de fade
                FadeTransition(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                  )),
                  child: Text(
                    'Votre bibliothèque numérique',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary.withAlpha(179),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
