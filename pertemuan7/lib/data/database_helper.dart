import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/kegiatan.dart';
import '../models/summary.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tabungku.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE kegiatan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        judul TEXT NOT NULL,
        nominal INTEGER NOT NULL,
        jenis TEXT NOT NULL CHECK(jenis IN ('pemasukan', 'pengeluaran')),
        tanggal TEXT NOT NULL,
        kategori_id INTEGER,
        catatan TEXT,
        FOREIGN KEY (kategori_id) REFERENCES kategori(id)
      )
    ''');

    await db.insert('kategori', {'nama': 'Makanan'});
    await db.insert('kategori', {'nama': 'Transportasi'});
    await db.insert('kategori', {'nama': 'Pendidikan'});
    await db.insert('kategori', {'nama': 'Lainnya'});
  }

  Future<int> insertKategori(String nama) async {
    final db = await database;
    return db.insert('kategori', {'nama': nama});
  }

  Future<List<Map<String, dynamic>>> getKategori() async {
    final db = await database;
    return db.query('kategori', orderBy: 'id ASC');
  }

  Future<int> insertKegiatan(Kegiatan kegiatan) async {
    final db = await database;
    return db.insert('kegiatan', kegiatan.toMap());
  }

  Future<List<Kegiatan>> getKegiatan({
    String? search,
    String? jenis,
    int? kategoriId,
  }) async {
    final db = await database;

    final conditions = <String>[];
    final args = <Object>[];

    if (search != null && search.trim().isNotEmpty) {
      conditions.add('judul LIKE ?');
      args.add('%${search.trim()}%');
    }

    if (jenis != null && jenis.isNotEmpty) {
      conditions.add('jenis = ?');
      args.add(jenis);
    }

    if (kategoriId != null) {
      conditions.add('kategori_id = ?');
      args.add(kategoriId);
    }

    String whereClause = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

    final result = await db.rawQuery('''
      SELECT k.*, c.nama AS kategori_nama
      FROM kegiatan k
      LEFT JOIN kategori c ON c.id = k.kategori_id
      $whereClause
      ORDER BY k.tanggal DESC, k.id DESC
    ''', args);

    return result.map((e) => Kegiatan.fromMap(e)).toList();
  }

  Future<int> updateKegiatan(Kegiatan kegiatan) async {
    final db = await database;
    if (kegiatan.id == null) return 0;
    return db.update(
      'kegiatan',
      kegiatan.toMap(),
      where: 'id = ?',
      whereArgs: [kegiatan.id],
    );
  }

  Future<int> deleteKegiatan(int id) async {
    final db = await database;
    return db.delete('kegiatan', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteKategori(int id) async {
    final db = await database;
    return db.delete('kategori', where: 'id = ?', whereArgs: [id]);
  }

  Future<RingkasanData> getRingkasan() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT
        COUNT(*) AS total_transaksi,
        COALESCE(SUM(CASE WHEN jenis = 'pemasukan' THEN nominal ELSE 0 END), 0) AS total_pemasukan,
        COALESCE(SUM(CASE WHEN jenis = 'pengeluaran' THEN nominal ELSE 0 END), 0) AS total_pengeluaran,
        COALESCE(SUM(CASE WHEN jenis = 'pemasukan' THEN nominal ELSE 0 END), 0)
          - COALESCE(SUM(CASE WHEN jenis = 'pengeluaran' THEN nominal ELSE 0 END), 0) AS saldo
      FROM kegiatan
    ''');

    if (result.isEmpty) {
      return const RingkasanData(
        totalTransaksi: 0,
        totalPemasukan: 0,
        totalPengeluaran: 0,
        saldo: 0,
      );
    }

    return RingkasanData.fromMap(result.first);
  }

  Future<List<Map<String, dynamic>>> getLaporanPerKategori() async {
    final db = await database;
    return db.rawQuery('''
      SELECT c.nama AS kategori, 
             COALESCE(SUM(CASE WHEN k.jenis = 'pemasukan' THEN k.nominal ELSE 0 END), 0) AS pemasukan,
             COALESCE(SUM(CASE WHEN k.jenis = 'pengeluaran' THEN k.nominal ELSE 0 END), 0) AS pengeluaran,
             COALESCE(SUM(CASE WHEN k.jenis = 'pemasukan' THEN k.nominal ELSE 0 END), 0)
             - COALESCE(SUM(CASE WHEN k.jenis = 'pengeluaran' THEN k.nominal ELSE 0 END), 0) AS saldo
      FROM kategori c
      LEFT JOIN kegiatan k ON k.kategori_id = c.id
      GROUP BY c.id, c.nama
      ORDER BY c.nama ASC
    ''');
  }

  Future<List<Map<String, dynamic>>> getLaporan7HariTerakhir() async {
    final db = await database;
    return db.rawQuery('''
      SELECT
        substr(tanggal, 1, 10) AS tanggal,
        COALESCE(SUM(CASE WHEN jenis = 'pemasukan' THEN nominal ELSE 0 END), 0) AS pemasukan,
        COALESCE(SUM(CASE WHEN jenis = 'pengeluaran' THEN nominal ELSE 0 END), 0) AS pengeluaran,
        COALESCE(SUM(CASE WHEN jenis = 'pemasukan' THEN nominal ELSE 0 END), 0)
          - COALESCE(SUM(CASE WHEN jenis = 'pengeluaran' THEN nominal ELSE 0 END), 0) AS saldo
      FROM kegiatan
      WHERE tanggal >= date('now', '-6 days')
      GROUP BY substr(tanggal, 1, 10)
      ORDER BY substr(tanggal, 1, 10) ASC
    ''');
  }

  Future<List<Map<String, dynamic>>> getLaporanExport() async {
    final db = await database;
    return db.rawQuery('''
      SELECT k.id, k.judul, k.jenis, k.nominal, k.tanggal, c.nama as kategori
      FROM kegiatan k
      LEFT JOIN kategori c ON c.id = k.kategori_id
      ORDER BY k.tanggal DESC, k.id DESC
    ''');
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete('kegiatan');
    await db.delete('kategori');
    await db.insert('kategori', {'nama': 'Makanan'});
    await db.insert('kategori', {'nama': 'Transportasi'});
    await db.insert('kategori', {'nama': 'Pendidikan'});
    await db.insert('kategori', {'nama': 'Lainnya'});
  }

  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
