import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final String dibuat;

  const Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.dibuat,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'judul': judul,
        'isi': isi,
        'dibuat': dibuat,
      };

  factory Catatan.fromMap(Map<String, Object?> map) {
    return Catatan(
      id: map['id'] as int,
      judul: map['judul'] as String,
      isi: map['isi'] as String,
      dibuat: map['dibuat'] as String,
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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE catatan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            isi TEXT NOT NULL,
            dibuat TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, versiLama, versiBaru) async {
        if (versiLama < 2) {
          await db.execute(
            "ALTER TABLE catatan ADD COLUMN dibuat TEXT NOT NULL DEFAULT ''",
          );
        }
      },
    );

    return _db!;
  }

  static Future<int> tambah(Catatan catatan) async {
    final db = await database;
    return db.insert('catatan', catatan.toMap());
  }

  static Future<List<Catatan>> semua({
    String kata = '',
    bool terbaru = true,
  }) async {
    final db = await database;

    final rows = await db.query(
      'catatan',
      where: kata.trim().isEmpty ? null : 'judul LIKE ?',
      whereArgs: kata.trim().isEmpty ? null : ['%${kata.trim()}%'],
      orderBy: terbaru ? 'id DESC' : 'id ASC',
    );

    return rows.map(Catatan.fromMap).toList();
  }

  static Future<int> ubah(Catatan catatan) async {
    final db = await database;

    return db.update(
      'catatan',
      catatan.toMap(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
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
  final TextEditingController _pencarian = TextEditingController();

  late Future<List<Catatan>> _future;
  bool _terbaru = true;

  @override
  void initState() {
    super.initState();
    _muatPengaturan();
  }

  Future<void> _muatPengaturan() async {
    final prefs = await SharedPreferences.getInstance();

    _terbaru = prefs.getBool('urutanTerbaru') ?? true;

    if (!mounted) return;

    setState(_muat);
  }

  void _muat() {
    _future = DbHelper.semua(
      kata: _pencarian.text,
      terbaru: _terbaru,
    );
  }

  Future<void> _ubahUrutan(bool terbaru) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('urutanTerbaru', terbaru);

    if (!mounted) return;

    setState(() {
      _terbaru = terbaru;
      _muat();
    });
  }

  Future<void> _bukaForm([Catatan? catatan]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormCatatanPage(catatan: catatan),
      ),
    );

    if (!mounted) return;

    setState(_muat);
  }

  Future<void> _hapus(Catatan catatan) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Hapus catatan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin != true) return;

    await DbHelper.hapus(catatan.id!);

    if (!mounted) return;

    setState(_muat);
  }

  @override
  void dispose() {
    _pencarian.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
        actions: [
          PopupMenuButton<bool>(
            tooltip: 'Urutan catatan',
            initialValue: _terbaru,
            onSelected: _ubahUrutan,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: true,
                child: Text('Terbaru'),
              ),
              PopupMenuItem(
                value: false,
                child: Text('Terlama'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _pencarian,
              onChanged: (_) {
                setState(_muat);
              },
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan judul...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _pencarian.clear();
                    setState(_muat);
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Catatan>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
                    child: Text('Catatan tidak ditemukan'),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final catatan = data[index];

                    return ListTile(
                      leading: const Icon(Icons.note_alt),
                      title: Text(catatan.judul),
                      subtitle: Text(
                        '${catatan.isi}\nDibuat: ${catatan.dibuat}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      onTap: () => _bukaForm(catatan),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () => _hapus(catatan),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormCatatanPage extends StatefulWidget {
  final Catatan? catatan;

  const FormCatatanPage({
    super.key,
    this.catatan,
  });

  @override
  State<FormCatatanPage> createState() => _FormCatatanPageState();
}

class _FormCatatanPageState extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judul;
  late final TextEditingController _isi;

  @override
  void initState() {
    super.initState();

    _judul = TextEditingController(
      text: widget.catatan?.judul ?? '',
    );
    _isi = TextEditingController(
      text: widget.catatan?.isi ?? '',
    );
  }

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final sekarang = DateTime.now().toIso8601String();

    final catatan = Catatan(
      id: widget.catatan?.id,
      judul: _judul.text.trim(),
      isi: _isi.text.trim(),
      dibuat: widget.catatan?.dibuat ?? sekarang,
    );

    if (widget.catatan == null) {
      await DbHelper.tambah(catatan);
    } else {
      await DbHelper.ubah(catatan);
    }

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.catatan == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(baru ? 'Catatan Baru' : 'Ubah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Judul wajib diisi'
                      : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _isi,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi catatan',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Isi catatan wajib diisi'
                      : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simpan,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}