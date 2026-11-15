import 'package:flutter/material.dart';

import '../../core/app_settings.dart';
import '../../core/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaCtrl;
  late final TextEditingController _emailCtrl;
  late bool _gelap;
  late Color _aksen;

  @override
  void initState() {
    super.initState();
    final s = AppSettings.instance;
    _namaCtrl = TextEditingController(text: s.nama);
    _emailCtrl = TextEditingController(text: s.email);
    _gelap = s.gelap;
    _aksen = s.aksen;
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    AppSettings.instance.simpan(
      nama: _namaCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      gelap: _gelap,
      aksen: _aksen,
    );
    setState(() {}); // segarkan nama di bawah avatar
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Perubahan disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _bangunAvatar(),
            const SizedBox(height: 24),
            _bangunInfoPribadi(),
            const SizedBox(height: 24),
            _bangunTampilan(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.aksen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bangunAvatar() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: const Color(0xFFE6E8EE),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.person, size: 48, color: Color(0xFF9AA0AE)),
        ),
        const SizedBox(height: 16),
        Text(
          AppSettings.instance.nama,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ganti foto segera hadir')),
          ),
          child: const Text('Edit Photo', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _bangunInfoPribadi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'PERSONAL INFORMATION',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              color: context.teksRedup,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: context.kartu,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _barisInput(
                label: 'Name',
                controller: _namaCtrl,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama tidak boleh kosong'
                    : null,
              ),
              const Divider(height: 1),
              _barisInput(
                label: 'Email',
                controller: _emailCtrl,
                tipe: TextInputType.emailAddress,
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Email tidak boleh kosong';
                  if (!t.contains('@') || !t.contains('.')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _barisInput({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType? tipe,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: tipe,
              textAlign: TextAlign.right,
              validator: validator,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bangunTampilan() {
    Widget kotakIkon(IconData ikon) => Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFE6E8EE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(ikon, size: 16, color: const Color(0xFF414754)),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.kartu,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              kotakIkon(Icons.dark_mode_outlined),
              const SizedBox(width: 12),
              const Expanded(child: Text('Dark Mode')),
              Switch(
                value: _gelap,
                onChanged: (v) => setState(() => _gelap = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              kotakIkon(Icons.palette_outlined),
              const SizedBox(width: 12),
              const Text('Accent Color'),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Row(
              children: AppSettings.pilihanAksen.map((warna) {
                final dipilih = warna == _aksen;
                return GestureDetector(
                  onTap: () => setState(() => _aksen = warna),
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: warna,
                      shape: BoxShape.circle,
                      border: dipilih
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                      boxShadow: dipilih
                          ? [BoxShadow(color: warna, spreadRadius: 2)]
                          : null,
                    ),
                    child: dipilih
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
