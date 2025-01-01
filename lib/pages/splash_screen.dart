import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myanimelist/pages/anime_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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

    // Inisialisasi Animasi
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Mulai Animasi
    _animationController.forward();

    // Pindah ke halaman Home setelah beberapa detik
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.network(
              'https://scontent.fsrg6-1.fna.fbcdn.net/v/t39.30808-6/299821468_493457372785284_6623888224725649048_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=e3rTZaQ_5g8Q7kNvgG80Qyr&_nc_oc=AdifxhBCIEuIeZNOO5QHPNmlAfMfZyDj8vrdGzZzETmP-uWu5VrxSC5zo6imk6NuSn4ge2CsoQuQiHCnt24HRt3x&_nc_zt=23&_nc_ht=scontent.fsrg6-1.fna&_nc_gid=A-n5GNoJuWCxwCKuwtxAcQ7&oh=00_AYAoR4Me5ytvp_KyLKwRU6lPJCtrgib5VTYNmgamRUVGlw&oe=67781128',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
