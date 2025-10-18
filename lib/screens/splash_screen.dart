import 'package:flutter/material.dart';
import 'package:login/screens/home/home_page.dart';
import 'login_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    _cekLogin();
  }

  Future<void> _cekLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (isLoggedIn) {
      final String email = prefs.getString('userEmail') ?? '';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyHomePage(title: 'Selamat Datang', email: email),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  // Animation
  // _controller = AnimationController(
  //   vsync: this,
  //   duration: const Duration(seconds: 2),
  // );
  // _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  // _controller.forward();

  // // Delay 3 detik sebelum pindah ke LoginPage
  // Future.delayed(const Duration(seconds: 3), () {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const LoginPage()),
  //   );
  // });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / gambar
              Image.asset(
                'assets/images/splashscreen.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),

              // Nama Aplikasi
              const Text(
                'Welcome to AniHua',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Tagline tambahan
              const Text(
                "Anime & Donghua",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 20),

              // Nama pembuat
              const Text(
                "Muhammad Dava Firmansyah",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 30),

              // Loading indicator
              LoadingAnimationWidget.dotsTriangle(
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
