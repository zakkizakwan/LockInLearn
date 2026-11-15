import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  static const pilihanAksen = [
    Color(0xFF0B5FC7),
    Color(0xFF1B7F3B),
    Color(0xFF8A4B00),
    Color(0xFFBA1A1A),
  ];

  String nama = 'UserApp';
  String email = 'user@example.com';
  bool gelap = false;
  Color aksen = pilihanAksen[0];

  void simpan({
    required String nama,
    required String email,
    required bool gelap,
    required Color aksen,
  }) {
    this.nama = nama;
    this.email = email;
    this.gelap = gelap;
    this.aksen = aksen;
    notifyListeners();
  }
}
