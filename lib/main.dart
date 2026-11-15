import 'package:flutter/material.dart';

import 'core/app_settings.dart';
import 'core/app_theme.dart';

import 'features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppSettings.instance,
      builder: (context, _) {
        final s = AppSettings.instance;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buatTema(aksen: s.aksen, gelap: s.gelap),
          home: const SplashScreen(),
        );
      },
    );
  }
}
