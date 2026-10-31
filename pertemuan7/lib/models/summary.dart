class RingkasanData {
  final int totalTransaksi;
  final int totalPemasukan;
  final int totalPengeluaran;
  final int saldo;

  const RingkasanData({
    required this.totalTransaksi,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldo,
  });

  factory RingkasanData.fromMap(Map<String, dynamic> map) {
    return RingkasanData(
      totalTransaksi: (map['total_transaksi'] as int?) ?? 0,
      totalPemasukan: (map['total_pemasukan'] as int?) ?? 0,
      totalPengeluaran: (map['total_pengeluaran'] as int?) ?? 0,
      saldo: (map['saldo'] as int?) ?? 0,
    );
  }
}
