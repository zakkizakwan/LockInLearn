import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import 'subject_model.dart';
import 'note_popup.dart';

enum TampilanSubject { grid, list }

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  static const _paletWarna = [
    Color(0xFFDCE5FF),
    Color(0xFF69FF87),
    Color(0xFFFFDCC3),
    Color(0xFFE0E2E8),
  ];

  // Dummydata aja
  final List<Subject> _semua = [
    const Subject(
      nama: 'Advanced Mathematics',
      ikon: Icons.calculate,
      warnaLatar: Color(0xFFDCE5FF),
    ),
    const Subject(
      nama: 'Computer Science',
      ikon: Icons.code,
      warnaLatar: Color(0xFF69FF87),
    ),
    const Subject(
      nama: 'Basic Web',
      ikon: Icons.language,
      warnaLatar: Color(0xFFFFDCC3),
    ),
    const Subject(
      nama: 'UI/UX Design Systems',
      ikon: Icons.palette,
      warnaLatar: Color(0xFFE0E2E8),
    ),
  ];

  TampilanSubject _tampilan = TampilanSubject.list;
  String _kataKunci = '';

  // filter getter
  List<Subject> get _terfilter => _semua
      .where((s) => s.nama.toLowerCase().contains(_kataKunci.toLowerCase()))
      .toList();

  Future<void> _tambahSubject() async {
    final formKey = GlobalKey<FormState>();
    String namaBaru = '';

    final hasil = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Subject'),
        content: Form(
          key: formKey,
          child: TextFormField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Nama mata kuliah'),
            onSaved: (v) => namaBaru = v!.trim(),
            validator: (v) {
              final teks = v?.trim() ?? '';
              if (teks.isEmpty) return 'Nama tidak boleh kosong';
              final kembar = _semua.any(
                (s) => s.nama.toLowerCase() == teks.toLowerCase(),
              );
              if (kembar) return 'Mata kuliah sudah ada';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                Navigator.pop(ctx, namaBaru);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (hasil == null) return; // dibatalkan
    setState(() {
      _semua.add(
        Subject(
          nama: hasil,
          ikon: Icons.menu_book,
          warnaLatar: _paletWarna[_semua.length % _paletWarna.length],
        ),
      );
    });
  }

  Future<void> _bukaSubject(Subject s) async {
    final hasil = await tampilkanCatatan(context, s);
    if (hasil == null || !mounted) return; // dibatalkan

    setState(() {
      final i = _semua.indexOf(s);
      _semua[i] = s.copyWith(catatan: hasil);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan "${s.nama}" disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _terfilter;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _bangunBarisCari(),
          const SizedBox(height: 16),
          if (data.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Text('Mata kuliah tidak ditemukan'),
            )
          else if (_tampilan == TampilanSubject.list)
            _bangunList(data)
          else
            _bangunGrid(data),
          const SizedBox(height: 24),
          _bangunTombolTambah(),
        ],
      ),
    );
  }

  Widget _bangunBarisCari() {
    Widget tombolTampilan(IconData ikon, TampilanSubject nilai) {
      final aktif = _tampilan == nilai;
      return GestureDetector(
        onTap: () => setState(() => _tampilan = nilai),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: aktif ? context.kartu : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(ikon, size: 18, color: context.teksUtama),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (v) => setState(() => _kataKunci = v),
            decoration: InputDecoration(
              hintText: 'Search subjects or tags...',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: const Color(0xFFE6E8EE),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFE6E8EE),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              tombolTampilan(Icons.grid_view, TampilanSubject.grid),
              const SizedBox(width: 4),
              tombolTampilan(Icons.format_list_bulleted, TampilanSubject.list),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kotakIkon(Subject s) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: s.warnaLatar,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(s.ikon, size: 22, color: const Color(0xFF191C20)),
    );
  }

  Widget _bangunList(List<Subject> data) {
    return Column(
      children: data.map((s) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _bukaSubject(s),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.kartu,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _kotakIkon(s),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      s.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (s.catatan.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.sticky_note_2_outlined, size: 18),
                    ),
                  Icon(Icons.chevron_right, color: context.teksHint),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _bangunGrid(List<Subject> data) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true, // tinggi mengikuti isi
      physics: const NeverScrollableScrollPhysics(), // gulir ikut halaman
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1,
      children: data.map((s) {
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _bukaSubject(s),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.kartu,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _kotakIkon(s),
                const SizedBox(height: 16),
                Text(
                  s.nama,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _bangunTombolTambah() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _tambahSubject,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add New Subject', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.aksen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
