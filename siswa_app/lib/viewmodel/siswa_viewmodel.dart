import 'package:flutter/foundation.dart';
import '../models/siswa_model.dart';
import '../services/siswa_service.dart';

enum ViewState { idle, loading, success, error }

class SiswaViewModel extends ChangeNotifier {
  final SiswaService _service = SiswaService();

  List<SiswaModel> _siswaList = [];
  ViewState _state = ViewState.idle;
  String _errorMessage = '';
  String _successMessage = '';

  // Getters
  List<SiswaModel> get siswaList => _siswaList;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;
  bool get isLoading => _state == ViewState.loading;

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = '';
    _successMessage = '';
  }

  /// Muat semua data siswa dari API
  Future<void> loadSiswa() async {
    _setState(ViewState.loading);
    clearMessages();
    try {
      _siswaList = await _service.getAllSiswa();
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  /// Tambah siswa baru
  Future<bool> addSiswa(SiswaModel siswa) async {
    _setState(ViewState.loading);
    clearMessages();
    try {
      await _service.addSiswa(siswa);
      _successMessage = 'Data siswa berhasil ditambahkan!';
      await loadSiswa();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return false;
    }
  }

  /// Update data siswa
  Future<bool> updateSiswa(int id, SiswaModel siswa) async {
    _setState(ViewState.loading);
    clearMessages();
    try {
      await _service.updateSiswa(id, siswa);
      _successMessage = 'Data siswa berhasil diupdate!';
      await loadSiswa();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return false;
    }
  }

  /// Hapus data siswa
  Future<bool> deleteSiswa(int id) async {
    clearMessages();
    try {
      await _service.deleteSiswa(id);
      _siswaList.removeWhere((s) => s.id == id);
      _successMessage = 'Data siswa berhasil dihapus!';
      _setState(ViewState.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
      return false;
    }
  }

  /// Filter/cari siswa berdasarkan nama atau kelas
  List<SiswaModel> searchSiswa(String query) {
    if (query.isEmpty) return _siswaList;
    final q = query.toLowerCase();
    return _siswaList.where((s) {
      return s.nama.toLowerCase().contains(q) ||
          s.kelas.toLowerCase().contains(q) ||
          s.nis.toLowerCase().contains(q);
    }).toList();
  }
}
