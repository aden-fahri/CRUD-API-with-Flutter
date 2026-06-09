import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/siswa_model.dart';
import '../viewmodel/siswa_viewmodel.dart';

class FormSiswaView extends StatefulWidget {
  final SiswaModel? siswa;

  const FormSiswaView({super.key, this.siswa});

  @override
  State<FormSiswaView> createState() => _FormSiswaViewState();
}

class _FormSiswaViewState extends State<FormSiswaView> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _nisController = TextEditingController();

  bool get _isEditMode => widget.siswa != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _namaController.text = widget.siswa!.nama;
      _kelasController.text = widget.siswa!.kelas;
      _nisController.text = widget.siswa!.nis;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kelasController.dispose();
    _nisController.dispose();
    super.dispose();
  }

  void _handleSubmitResult(bool success, String message) {
    if (!context.mounted) return;
    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<SiswaViewModel>();
    final siswa = SiswaModel(
      nama: _namaController.text.trim(),
      kelas: _kelasController.text.trim(),
      nis: _nisController.text.trim(),
    );

    bool success;
    if (_isEditMode) {
      success = await vm.updateSiswa(widget.siswa!.id!, siswa);
    } else {
      success = await vm.addSiswa(siswa);
    }
    _handleSubmitResult(success, success ? vm.successMessage : vm.errorMessage);
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduManage'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditMode ? 'Edit Data Siswa' : 'Tambah Siswa Baru',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Lengkapi data di bawah ini untuk mendaftarkan siswa baru ke sistem.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      hintText: 'Contoh: Aditya Pratama',
                    ),
                    validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nisController,
                    decoration: const InputDecoration(
                      labelText: 'NIS',
                      hintText: 'Contoh: 202104592',
                    ),
                    validator: (v) => v!.isEmpty ? 'NIS tidak boleh kosong' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _kelasController,
                    decoration: const InputDecoration(
                      labelText: 'Kelas',
                      hintText: 'Contoh: X-IPA-1',
                    ),
                    validator: (v) => v!.isEmpty ? 'Kelas tidak boleh kosong' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Tips Section wrapped in a premium card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Tips Pengisian',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem('Pastikan NIS belum pernah terdaftar sebelumnya di sistem.'),
                  _buildTipItem('Gunakan huruf kapital di awal setiap kata pada nama lengkap.'),
                  _buildTipItem('Data kelas akan menentukan daftar mata pelajaran siswa.'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(
                  _isEditMode ? 'Simpan Perubahan' : 'Daftarkan Siswa',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 1) Navigator.pop(context);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Siswa'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add_rounded), label: 'Tambah'),
        ],
      ),
    );
  }
}
