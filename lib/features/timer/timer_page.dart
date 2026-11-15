import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

enum ModeTimer { focus, pomodoro }

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  static const _pilihanMenit = [25, 45, 60, 90];
  static const _menitIstirahat = 5;

  ModeTimer _mode = ModeTimer.focus;
  int _menit = 25;
  bool _istirahat = false;
  bool _berjalan = false;
  late int _sisaDetik = _menit * 60;
  Timer? _timer;

  int get _totalDetik => _istirahat ? _menitIstirahat * 60 : _menit * 60;

  @override
  void dispose() {
    _timer?.cancel(); // wajib: hentikan timer saat halaman ditutup
    super.dispose();
  }

  String get _teksWaktu {
    final m = (_sisaDetik ~/ 60).toString().padLeft(2, '0');
    final s = (_sisaDetik % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _mulai() {
    setState(() => _berjalan = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_sisaDetik <= 1) {
        _selesai();
      } else {
        setState(() => _sisaDetik--);
      }
    });
  }

  void _jeda() {
    _timer?.cancel();
    setState(() => _berjalan = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _berjalan = false;
      _istirahat = false;
      _sisaDetik = _menit * 60;
    });
  }

  void _selesai() {
    _timer?.cancel();
    final pesan = _istirahat ? 'Istirahat selesai!' : 'Sesi fokus selesai!';
    setState(() {
      _berjalan = false;
      // Mode pomodoro: bergantian fokus <-> istirahat
      if (_mode == ModeTimer.pomodoro) _istirahat = !_istirahat;
      _sisaDetik = _totalDetik;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  void _ubahMode(ModeTimer mode) {
    if (mode == _mode) return;
    _timer?.cancel();
    setState(() {
      _mode = mode;
      _berjalan = false;
      _istirahat = false;
      if (mode == ModeTimer.pomodoro) _menit = 25;
      _sisaDetik = _menit * 60;
    });
  }

  void _pilihDurasi(int menit) {
    if (_berjalan) return; // tidak boleh ganti saat berjalan
    setState(() {
      _menit = menit;
      _sisaDetik = menit * 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _bangunToggleMode(),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
            decoration: BoxDecoration(
              color: context.kartu,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _bangunLingkaran(),
                const SizedBox(height: 24),
                if (_mode == ModeTimer.focus) _bangunChipDurasi(),
                if (_mode == ModeTimer.focus) const SizedBox(height: 24),
                _bangunTombolStart(),
                if (_sisaDetik != _totalDetik)
                  TextButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunToggleMode() {
    Widget tombol(String teks, ModeTimer m) {
      final aktif = _mode == m;
      return Expanded(
        child: GestureDetector(
          onTap: () => _ubahMode(m),
          child: Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: aktif ? context.kartu : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              teks,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: aktif ? context.teksUtama : context.teksHint,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E8EE),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          tombol('Focus', ModeTimer.focus),
          tombol('Pomodoro', ModeTimer.pomodoro),
        ],
      ),
    );
  }

  Widget _bangunLingkaran() {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: _sisaDetik / _totalDetik,
              strokeWidth: 14,
              strokeCap: StrokeCap.round,
              color: context.aksen,
              backgroundColor: const Color(0xFFE6E8EE),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _teksWaktu,
                style: TextStyle(
                  fontSize: 56,
                  color: context.teksUtama,
                ),
              ),
              Text(
                _istirahat ? 'BREAK' : 'MINUTE',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1,
                  color: context.teksHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bangunChipDurasi() {
    return Wrap(
      spacing: 8,
      children: _pilihanMenit.map((m) {
        final aktif = m == _menit;
        return GestureDetector(
          onTap: () => _pilihDurasi(m),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: aktif ? context.aksen : const Color(0xFFE6E8EE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${m}m',
              style: TextStyle(
                fontSize: 12,
                color: aktif ? Colors.white : context.teksRedup,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _bangunTombolStart() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _berjalan ? _jeda : _mulai,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.aksen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _berjalan ? 'Pause' : 'Start',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
