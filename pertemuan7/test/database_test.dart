import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:tabungku/data/database_helper.dart';
import 'package:tabungku/models/kegiatan.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final db = await DatabaseHelper.instance.database;
    await db.delete('kegiatan');
    await db.delete('kategori');
    await db.insert('kategori', {'nama': 'Makanan'});
    await db.insert('kategori', {'nama': 'Transportasi'});
    await db.insert('kategori', {'nama': 'Pendidikan'});
    await db.insert('kategori', {'nama': 'Lainnya'});
  });

  tearDownAll(() async {
    await DatabaseHelper.close();
  });

  test('Skenario 1: database dibuat dengan tabel kategori dan kegiatan', () async {
    final db = await DatabaseHelper.instance.database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('kategori','kegiatan')",
    );
    expect(tables.length, 2);
  });

  test('Skenario 2: insert kategori berhasil', () async {
    final id = await DatabaseHelper.instance.insertKategori('Belanja');
    expect(id, isNonZero);
  });

  test('Skenario 3: insert kegiatan berhasil', () async {
    final kategori = (await DatabaseHelper.instance.getKategori()).first;
    final inserted = await DatabaseHelper.instance.insertKegiatan(
      Kegiatan(
        judul: 'Beras 5kg',
        nominal: 50000,
        jenis: 'pengeluaran',
        tanggal: '2026-10-21',
        kategoriId: kategori['id'] as int,
        catatan: 'Belanja bulanan',
      ),
    );
    expect(inserted, isNonZero);
  });

  test('Skenario 5: query ringkasan menghasilkan nilai total dan saldo', () async {
    final summary = await DatabaseHelper.instance.getRingkasan();
    expect(summary.totalTransaksi, greaterThanOrEqualTo(1));
    expect(summary.totalPemasukan, isA<int>());
    expect(summary.totalPengeluaran, isA<int>());
    expect(summary.saldo, isA<int>());
  });

  test('Skenario 6: laporan per kategori menampilkan data', () async {
    final report = await DatabaseHelper.instance.getLaporanPerKategori();
    expect(report, isNotEmpty);
    expect(report.first.keys, containsAll(['kategori', 'pemasukan', 'pengeluaran', 'saldo']));
  });

  test('Skenario 7: laporan 7 hari terakhir menampilkan data', () async {
    final report = await DatabaseHelper.instance.getLaporan7HariTerakhir();
    expect(report, isNotEmpty);
  });

  test('Skenario 8: pencarian dan filter kegiatan bekerja', () async {
    final list = await DatabaseHelper.instance.getKegiatan(search: 'Beras', jenis: 'pengeluaran');
    expect(list, isNotEmpty);
  });

  test('Skenario 10: delete kegiatan berhasil', () async {
    final items = await DatabaseHelper.instance.getKegiatan();
    if (items.isNotEmpty) {
      final id = items.first.id!;
      final deleted = await DatabaseHelper.instance.deleteKegiatan(id);
      expect(deleted, 1);
    }
  });
}
