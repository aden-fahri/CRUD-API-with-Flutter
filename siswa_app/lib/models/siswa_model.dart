class SiswaModel {
  final int? id;
  final String nama;
  final String kelas;
  final String nis;

  SiswaModel({
    this.id,
    required this.nama,
    required this.kelas,
    required this.nis,
  });

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      nama: json['nama']?.toString() ?? '',
      kelas: json['kelas']?.toString() ?? '',
      nis: json['nis']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'kelas': kelas,
      'nis': nis,
    };
  }

  SiswaModel copyWith({
    int? id,
    String? nama,
    String? kelas,
    String? nis,
  }) {
    return SiswaModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kelas: kelas ?? this.kelas,
      nis: nis ?? this.nis,
    );
  }
}
