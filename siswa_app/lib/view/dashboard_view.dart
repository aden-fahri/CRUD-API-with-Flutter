import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../viewmodel/siswa_viewmodel.dart';
import 'form_siswa_view.dart';

class DashboardView extends StatefulWidget {
  final VoidCallback? onViewStudents;

  const DashboardView({super.key, this.onViewStudents});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SiswaViewModel>().loadSiswa();
    });
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.08), width: 1.5),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTile({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.05), width: 1.2),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.outline,
              fontWeight: FontWeight.w500,
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
        automaticallyImplyLeading: false,
      ),
      body: Consumer<SiswaViewModel>(
        builder: (context, vm, _) {
          final totalSiswa = vm.siswaList.length;
          final classesList = vm.siswaList.map((e) => e.kelas.toLowerCase()).toSet();
          final totalClasses = classesList.length;

          return RefreshIndicator(
            onRefresh: vm.loadSiswa,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF6B2FF8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang,',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Administrator',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Tahun Ajaran 2023/2024',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Section Title
                  Text(
                    'Ringkasan Data',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Grid Layout
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Total Siswa',
                            value: totalSiswa.toString(),
                            icon: Icons.groups_rounded,
                            color: AppColors.primary,
                            bgColor: AppColors.primary.withValues(alpha: 0.05),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Jumlah Kelas',
                            value: totalClasses.toString(),
                            icon: Icons.meeting_room_rounded,
                            color: const Color(0xFF00B27A),
                            bgColor: const Color(0xFF00B27A).withValues(alpha: 0.05),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Kehadiran Harian',
                            value: '98.2%',
                            icon: Icons.fact_check_rounded,
                            color: const Color(0xFFFFB200),
                            bgColor: const Color(0xFFFFB200).withValues(alpha: 0.05),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Status Server',
                            value: 'Aktif',
                            icon: Icons.dns_rounded,
                            color: Colors.blue,
                            bgColor: Colors.blue.withValues(alpha: 0.05),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Section Title
                  Text(
                    'Tindakan Cepat',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Action Buttons Row
                  Row(
                    children: [
                      _buildActionButton(
                        label: 'Tambah\nSiswa',
                        icon: Icons.person_add_rounded,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FormSiswaView()),
                          );
                          vm.loadSiswa();
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        label: 'Lihat Daftar\nSiswa',
                        icon: Icons.view_list_rounded,
                        onTap: () {
                          if (widget.onViewStudents != null) {
                            widget.onViewStudents!();
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        label: 'Informasi\nAkademik',
                        icon: Icons.info_outline_rounded,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Halaman Informasi Akademik akan segera hadir!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Section Title
                  Text(
                    'Aktivitas Terbaru',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _buildActivityTile(
                    title: 'Koneksi Database',
                    subtitle: 'Server sukses terhubung ke MySQL lokal.',
                    time: 'Baru saja',
                    icon: Icons.check_circle_rounded,
                    iconColor: Colors.blue,
                  ),
                  _buildActivityTile(
                    title: 'Pembaruan Data Siswa',
                    subtitle: 'Data kelas dan profil siswa berhasil disinkronisasi.',
                    time: '10m yang lalu',
                    icon: Icons.edit_rounded,
                    iconColor: AppColors.primary,
                  ),
                  _buildActivityTile(
                    title: 'Sistem Inisialisasi',
                    subtitle: 'Aplikasi EduManage siap digunakan.',
                    time: '1 jam yang lalu',
                    icon: Icons.school_rounded,
                    iconColor: const Color(0xFF00B27A),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
