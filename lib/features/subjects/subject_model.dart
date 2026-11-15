import 'package:flutter/material.dart';

class Subject {
  final String nama;
  final IconData ikon;
  final Color warnaLatar;
  final String catatan;

  const Subject({
    required this.nama,
    required this.ikon,
    required this.warnaLatar,
    this.catatan = '',
  });

  // Data bersifat final, jadi untuk "mengubah" kita buat salinan baru
  Subject copyWith({String? catatan}) => Subject(
    nama: nama,
    ikon: ikon,
    warnaLatar: warnaLatar,
    catatan: catatan ?? this.catatan,
  );
}
