import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatatanPage(),
    );
  }
}

class Catatan {
  final int? id;
  final String judul;
  final String isi;

  const Catatan({
    this.id,
    required this.judul,
    required this.isi,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'judul': judul,
        'isi': isi,
      };

  factory Catatan.fromMap(Map<String, Object?> map) {
    return Catatan(
      id: map['id'] as int,
      judul: map['judul'] as String,
      isi: map['isi'] as String,
    );
  }
}

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final lokasi = p.join(
      await getDatabasesPath(),
      'catatan.db',
    );

    _db = await openDatabase(
      lokasi,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE catatan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            isi TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }

  static Future<int> tambah(Catatan catatan) async {
    final db = await database;
    return db.insert('catatan', catatan.toMap());
  }

  static Future<List<Catatan>> semua() async {
    final db = await database;
    final rows = await db.query(
      'catatan',
      orderBy: 'id DESC',
    );
    return rows.map(Catatan.fromMap).toList();
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    return db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class CatatanPage extends StatefulWidget {
  const CatatanPage({super.key});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  late Future<List<Catatan>> _future;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  void _muat() {
    _future = DbHelper.semua();
  }

  Future<void> _tambahCatatan() async {
    final judulController = TextEditingController();
    final isiController = TextEditingController();

    final berhasil = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tambah Catatan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: isiController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Isi catatan',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (judulController.text.trim().isEmpty ||
                    isiController.text.trim().isEmpty) {
                  return;
                }
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (berhasil == true) {
      await DbHelper.tambah(
        Catatan(
          judul: judulController.text.trim(),
          isi: isiController.text.trim(),
        ),
      );
    }

    judulController.dispose();
    isiController.dispose();

    if (!mounted) return;

    setState(_muat);
  }

  Future<void> _hapusCatatan(Catatan catatan) async {
    await DbHelper.hapus(catatan.id!);

    if (!mounted) return;

    setState(_muat);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
      ),
      body: FutureBuilder<List<Catatan>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Galat: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text('Belum ada catatan'),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final catatan = data[index];

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.note),
                ),
                title: Text(catatan.judul),
                subtitle: Text(
                  catatan.isi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  tooltip: 'Hapus catatan',
                  onPressed: () => _hapusCatatan(catatan),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahCatatan,
        child: const Icon(Icons.add),
      ),
    );
  }
}