class Kegiatan {
  final int? id;
  final String judul;
  final int nominal;
  final String jenis;
  final String tanggal;
  final int? kategoriId;
  final String? kategoriNama;
  final String? catatan;

  const Kegiatan({
    this.id,
    required this.judul,
    required this.nominal,
    required this.jenis,
    required this.tanggal,
    this.kategoriId,
    this.kategoriNama,
    this.catatan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'nominal': nominal,
      'jenis': jenis,
      'tanggal': tanggal,
      'kategori_id': kategoriId,
      'catatan': catatan,
    };
  }

  factory Kegiatan.fromMap(Map<String, dynamic> map) {
    return Kegiatan(
      id: map['id'] as int?,
      judul: map['judul'] as String? ?? '',
      nominal: map['nominal'] as int? ?? 0,
      jenis: map['jenis'] as String? ?? 'pengeluaran',
      tanggal: map['tanggal'] as String? ?? DateTime.now().toIso8601String(),
      kategoriId: map['kategori_id'] as int?,
      kategoriNama: map['kategori_nama'] as String?,
      catatan: map['catatan'] as String?,
    );
  }
}
