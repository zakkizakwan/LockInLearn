import 'package:flutter/material.dart';

ThemeData buatTema({required Color aksen, required bool gelap}) {
  final skema = ColorScheme.fromSeed(
    seedColor: aksen,
    brightness: gelap ? Brightness.dark : Brightness.light,
  ).copyWith(primary: aksen);

  return ThemeData(
    useMaterial3: true,
    colorScheme: skema,
    scaffoldBackgroundColor: gelap
        ? const Color(0xFF111318)
        : const Color(0xFFF9F9FF),
  );
}

// Jalan pintas: context.aksen, context.kartu, dst.
extension TemaContext on BuildContext {
  bool get _gelap => Theme.of(this).brightness == Brightness.dark;
  Color get aksen => Theme.of(this).colorScheme.primary;
  Color get kartu => _gelap ? const Color(0xFF1D2025) : Colors.white;
  Color get permukaan =>
      _gelap ? const Color(0xFF282B32) : const Color(0xFFF3F3FA);
  Color get teksUtama => Theme.of(this).colorScheme.onSurface;
  Color get teksRedup => _gelap ? Colors.white70 : const Color(0xFF414754);
  Color get teksHint => _gelap ? Colors.white38 : const Color(0xFF717786);
  Color get pembatas =>
      _gelap ? const Color(0xFF2A2D33) : const Color(0xFFE6E8EE);
}
