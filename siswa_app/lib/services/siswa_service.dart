import 'package:dio/dio.dart';
import '../core/api_constants.dart';
import '../models/siswa_model.dart';

class SiswaService {
  late final Dio _dio;

  SiswaService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor untuk logging (dev only)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  /// GET /siswa - Ambil semua data siswa
  Future<List<SiswaModel>> getAllSiswa() async {
    try {
      final response = await _dio.get(ApiConstants.siswaEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => SiswaModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Gagal memuat data siswa',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /siswa - Tambah data siswa baru
  Future<Map<String, dynamic>> addSiswa(SiswaModel siswa) async {
    try {
      final response = await _dio.post(
        ApiConstants.siswaEndpoint,
        data: siswa.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Gagal menambah data siswa',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT /siswa/:id - Update data siswa
  Future<Map<String, dynamic>> updateSiswa(int id, SiswaModel siswa) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.siswaEndpoint}/$id',
        data: siswa.toJson(),
      );
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Gagal mengupdate data siswa',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE /siswa/:id - Hapus data siswa
  Future<void> deleteSiswa(int id) async {
    try {
      final response = await _dio.delete('${ApiConstants.siswaEndpoint}/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Gagal menghapus data siswa',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Periksa jaringan Anda.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Pastikan API berjalan.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) return 'Data tidak ditemukan.';
        if (statusCode == 500) return 'Terjadi kesalahan pada server.';
        return 'Error $statusCode: ${e.response?.statusMessage}';
      default:
        return e.message ?? 'Terjadi kesalahan tidak diketahui.';
    }
  }
}
