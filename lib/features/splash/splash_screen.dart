import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo: kotak putih + border + bayangan
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset('assets/images/logo_lil.png'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'LockInLearn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.teksUtama,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lock your focus',
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: context.teksRedup,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Hanya progress bar (teks versi dihapus)
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SizedBox(
                width: 160,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(seconds: 3),
                  builder: (context, nilai, _) => LinearProgressIndicator(
                    value: nilai,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                    color: context.aksen,
                    backgroundColor: const Color(0xFFE6E8EE),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
