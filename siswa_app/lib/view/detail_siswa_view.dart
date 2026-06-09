import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/siswa_model.dart';
import '../viewmodel/siswa_viewmodel.dart';
import 'form_siswa_view.dart';

class DetailSiswaView extends StatelessWidget {
  final int siswaId;

  const DetailSiswaView({super.key, required this.siswaId});

  void _showDeleteConfirmDialog(BuildContext context, SiswaModel siswa) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Hapus Siswa'),
        content: Text('Apakah Anda yakin ingin menghapus data ${siswa.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final vm = context.read<SiswaViewModel>();
              final success = await vm.deleteSiswa(siswa.id!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? vm.successMessage : vm.errorMessage),
                    backgroundColor: success ? const Color(0xFF1A6B3A) : AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                if (success) {
                  Navigator.pop(context); // Go back to student list
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
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
        title: const Text('Detail Siswa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<SiswaViewModel>(
        builder: (context, vm, _) {
          // Find student reactively from viewModel list
          final siswa = vm.siswaList.firstWhere(
            (s) => s.id == siswaId,
            orElse: () => SiswaModel(id: -1, nama: '', kelas: '', nis: ''),
          );

          if (siswa.id == -1) {
            return const Center(
              child: Text(
                'Data siswa tidak ditemukan atau telah dihapus.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF6B2FF8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: Text(
                          siswa.nama.isNotEmpty ? siswa.nama[0].toUpperCase() : '?',
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        siswa.nama,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Kelas ${siswa.kelas}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Credentials Information Card
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Personal',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoTile(
                          icon: Icons.person_rounded,
                          label: 'Nama Lengkap',
                          value: siswa.nama,
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F1FD)),
                        _buildInfoTile(
                          icon: Icons.badge_rounded,
                          label: 'Nomor Induk Siswa (NIS)',
                          value: siswa.nis,
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F1FD)),
                        _buildInfoTile(
                          icon: Icons.class_rounded,
                          label: 'Kelas Saat Ini',
                          value: siswa.kelas,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Academic Performance Card (Premium Mocked Metrics)
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Performa Akademik (Semester Ganjil)',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Mocked Attendance Gauge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Persentase Kehadiran',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '98.4%',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00B27A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            value: 0.984,
                            minHeight: 8,
                            backgroundColor: Color(0xFFE8F9F3),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B27A)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Mocked Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.06)),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Rata-Rata Nilai',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '89.2',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00B27A).withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF00B27A).withValues(alpha: 0.06)),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Status Siswa',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Aktif',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF00B27A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Edit & Delete Action Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => FormSiswaView(siswa: siswa)),
                            );
                          },
                          icon: const Icon(Icons.edit_rounded, size: 20),
                          label: const Text('Edit Profil'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () => _showDeleteConfirmDialog(context, siswa),
                          icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 20),
                          label: Text(
                            'Hapus',
                            style: GoogleFonts.inter(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
