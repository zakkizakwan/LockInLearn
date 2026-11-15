import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import 'subject_model.dart';

Future<String?> tampilkanCatatan(BuildContext context, Subject subject) {
  return showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup',
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (ctx, _, __) => _CatatanPopup(subject: subject),
    transitionBuilder: (ctx, anim, _, child) {
      final kurva = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: kurva,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(kurva),
          child: child,
        ),
      );
    },
  );
}

class _CatatanPopup extends StatefulWidget {
  final Subject subject;
  const _CatatanPopup({required this.subject});

  @override
  State<_CatatanPopup> createState() => _CatatanPopupState();
}

class _CatatanPopupState extends State<_CatatanPopup> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.subject.catatan);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _ctrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(child: _bangunKartu()),
          ),
        ],
      ),
    );
  }

  Widget _bangunKartu() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: context.kartu,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: context.permukaan,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.subject.nama,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.teksUtama,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ctrl,
              autofocus: true,
              minLines: 4,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Tulis catatanmu . . .',
                filled: true,
                fillColor: context.permukaan,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Catatan tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.permukaan,
                        foregroundColor: context.teksUtama,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.aksen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Note'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
