import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sehati/providers/auth_provider.dart';
import 'package:Sehati/view/homeprofile/home.dart';
import 'package:Sehati/view/registerlogin/login_screen.dart';
import 'package:Sehati/view/splash/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Create scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // Start animation
    _animationController.forward();

    // Navigate after 1 second
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();
      final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      
      Widget nextScreen;
      
      if (authProvider.isAuthenticated) {
        // User sudah login, langsung ke HomePage
        nextScreen = const HomePage();
      } else if (onboardingComplete) {
        // User belum login tapi sudah pernah lihat onboarding
        nextScreen = const LoginScreen();
      } else {
        // User pertama kali buka app, tampilkan onboarding
        nextScreen = const OnboardingScreen();
      }
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/prenava_logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

