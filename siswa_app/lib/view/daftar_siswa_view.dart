import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../models/siswa_model.dart';
import '../viewmodel/siswa_viewmodel.dart';
import 'form_siswa_view.dart';

class DaftarSiswaView extends StatefulWidget {
  const DaftarSiswaView({super.key});

  @override
  State<DaftarSiswaView> createState() => _DaftarSiswaViewState();
}

class _DaftarSiswaViewState extends State<DaftarSiswaView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';
  int _selectedIndex = 1; // "Siswa" is selected

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SiswaViewModel>().loadSiswa();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteResult(bool success, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? const Color(0xFF1A6B3A) : AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
              _showDeleteResult(success, success ? vm.successMessage : vm.errorMessage);
            },
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int total) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    total.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Akademik 2023/2024',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.groups_rounded, color: AppColors.secondary, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Semester Ganjil • Minggu ke-12',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSiswaItem(BuildContext context, SiswaModel siswa) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: AppColors.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceContainer,
          child: Text(
            siswa.nama[0].toUpperCase(),
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          siswa.nama,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        subtitle: Text(
          'NIS: ${siswa.nis} • Kelas ${siswa.kelas}',
          style: GoogleFonts.inter(fontSize: 13),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (val) {
            if (val == 'edit') {
              _navigateToEdit(context, siswa);
            } else if (val == 'delete') {
              _showDeleteConfirmDialog(context, siswa);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Hapus')),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context, SiswaModel siswa) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FormSiswaView(siswa: siswa)),
    );
    if (result == true && context.mounted) {
      context.read<SiswaViewModel>().loadSiswa();
    }
  }

  Future<void> _navigateToAdd(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FormSiswaView()),
    );
    if (result == true && context.mounted) {
      context.read<SiswaViewModel>().loadSiswa();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduManage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {}, // Implementation of search could be here
          ),
        ],
      ),
      body: Consumer<SiswaViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.siswaList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredList = vm.searchSiswa(_searchQuery);

          return RefreshIndicator(
            onRefresh: vm.loadSiswa,
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Siswa',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola data akademik dan informasi personal siswa secara terpusat.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _buildSummaryCard(vm.siswaList.length),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Data Siswa',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Menampilkan ${filteredList.length} siswa',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (filteredList.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('Tidak ada data siswa'),
                  ))
                else
                  ...filteredList.map((siswa) => _buildSiswaItem(context, siswa)),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _navigateToAdd(context);
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups_rounded),
            label: 'Siswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_outlined),
            activeIcon: Icon(Icons.person_add_rounded),
            label: 'Tambah',
          ),
        ],
      ),
    );
  }
}
