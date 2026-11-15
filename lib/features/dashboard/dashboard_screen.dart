import 'package:flutter/material.dart';
import 'package:lockinlearn/features/subjects/subjects_page.dart';

import '../../core/app_theme.dart';
import '../timer/timer_page.dart';
import '../auth/login_screen.dart';
import '../profile/profile_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tab = 0;

  static const _menu = [
    (Icons.timer_outlined, 'Timer'),
    (Icons.menu_book_outlined, 'Subjects'),
    // (Icons.bar_chart, 'Stats') coming soon,
    (Icons.person_outline, 'Profile'),
  ];

  Future<void> _konfirmasiKeluar() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text('Kamu akan kembali ke halaman login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (yakin == true && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (_tab == 2)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Color(0xFFBA1A1A),
                  size: 18,
                ),
                onPressed: _konfirmasiKeluar,
              ),
            ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: context.kartu,
        elevation: 2,
        shadowColor: Colors.black26,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset('assets/images/logo_lil.png', width: 32, height: 32),
            const SizedBox(width: 10),
            const Text(
              'Lock In Learn',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _tab,
        children: const [
          TimerPage(),
          SubjectsPage(),
          ProfilePage(),
          // Stats(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          height: 64,
          decoration: BoxDecoration(
            color: context.kartu,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_menu.length, (i) {
              final aktif = i == _tab;
              final warna = aktif ? context.aksen : context.teksRedup;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _tab = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_menu[i].$1, color: warna),
                      Text(
                        _menu[i].$2,
                        style: TextStyle(fontSize: 11, color: warna),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
