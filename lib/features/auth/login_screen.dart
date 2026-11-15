import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';
import '../../core/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _sembunyikan = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    // validate() if wrong reject
    if (!_formKey.currentState!.validate()) return;

    // Login dummy
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 48),
                Image.asset(
                  'assets/images/logo_lil.png',
                  width: 64,
                  height: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Welcome to LockInLearn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 40),

                // Kartu putih berisi form
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.kartu,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('EMAIL', style: _labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _dekorasi(context, 'user@example.com'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!v.contains('@') || !v.contains('.')) {
                            return 'Format email tidak valid';
                          }
                          return null; // null = valid
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('PASSWORD', style: _labelStyle),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _sembunyikan,
                        decoration: _dekorasi(context, 'Password').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _sembunyikan
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => _sembunyikan = !_sembunyikan),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (v.length < 6) return 'Minimal 6 karakter';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol utama
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.aksen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Login', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Pemisah
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR CONTINUE WITH', style: _labelStyle),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Tombol Google (tampilan saja)
                SizedBox(
                  width: double.infinity,
                  child: _tombolSosial(
                    Image.asset(
                      'assets/images/google.png',
                      width: 24,
                      height: 24,
                    ),
                    'Google',
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New here? '),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tombolSosial(Widget ikon, String teks) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Fitur ini segera hadir',
            ),
          ),
        ),
        icon: ikon,
        label: Text(teks, style: TextStyle(color: context.teksUtama)),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.kartu,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

const _labelStyle = TextStyle(
  fontSize: 12,
  letterSpacing: 0.5,
  color: Color(0xFF414754),
);

InputDecoration _dekorasi(BuildContext context, String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2D33)
        : const Color(0xFFF3F3FA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}
