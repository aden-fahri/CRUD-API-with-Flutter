import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../viewmodel/siswa_viewmodel.dart';
import 'dashboard_view.dart';
import 'daftar_siswa_view.dart';
import 'form_siswa_view.dart';

class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardView(
        onViewStudents: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),
      const DaftarSiswaView(),
    ];
  }

  Future<void> _navigateToAdd(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FormSiswaView()),
    );
    if (result == true && mounted) {
      context.read<SiswaViewModel>().loadSiswa();
      setState(() {
        _selectedIndex = 1; // Navigate to Student List to view the newly added student
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _navigateToAdd(context);
          } else {
            setState(() {
              _selectedIndex = index;
            });
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
