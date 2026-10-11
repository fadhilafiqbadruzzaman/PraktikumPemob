import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================
// MODEL PENGELUARAN
// ============================================================

class Pengeluaran {
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;

  const Pengeluaran({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'kategori': kategori,
      'tanggal': tanggal,
    };
  }

  factory Pengeluaran.fromMap(Map<String, Object?> map) {
    return Pengeluaran(
      id: map['id'] as int,
      nama: map['nama'] as String,
      jumlah: map['jumlah'] as int,
      kategori: map['kategori'] as String,
      tanggal: map['tanggal'] as String,
    );
  }
}

// ============================================================
// DATABASE SQLITE
// ============================================================

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final lokasi = p.join(
      await getDatabasesPath(),
      'pengeluaran.db',
    );

    _db = await openDatabase(
      lokasi,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pengeluaran(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            jumlah INTEGER NOT NULL,
            kategori TEXT NOT NULL,
            tanggal TEXT NOT NULL
          )
        ''');
      },
    );

    return _db!;
  }

  // CREATE
  static Future<int> tambah(Pengeluaran data) async {
    final db = await database;

    return db.insert(
      'pengeluaran',
      data.toMap(),
    );
  }

  // READ
  static Future<List<Pengeluaran>> semua() async {
    final db = await database;

    final rows = await db.query(
      'pengeluaran',
      orderBy: 'tanggal DESC, id DESC',
    );

    return rows.map(Pengeluaran.fromMap).toList();
  }

  // UPDATE
  static Future<int> ubah(Pengeluaran data) async {
    final db = await database;

    return db.update(
      'pengeluaran',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  // DELETE
  static Future<int> hapus(int id) async {
    final db = await database;

    return db.delete(
      'pengeluaran',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // TOTAL PENGELUARAN
  static Future<int> total() async {
    final db = await database;

    final hasil = await db.rawQuery(
      'SELECT SUM(jumlah) AS total FROM pengeluaran',
    );

    return (hasil.first['total'] as int?) ?? 0;
  }
}

// ============================================================
// APLIKASI UTAMA
// ============================================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _muatTema();
  }

  Future<void> _muatTema() async {
    final prefs = await SharedPreferences.getInstance();
    final gelap = prefs.getBool('modeGelap') ?? false;

    if (!mounted) return;

    setState(() {
      _themeMode = gelap ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _ubahTema(bool gelap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', gelap);

    if (!mounted) return;

    setState(() {
      _themeMode = gelap ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pencatat Pengeluaran',
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: PengeluaranPage(
        modeGelap: _themeMode == ThemeMode.dark,
        onTemaBerubah: _ubahTema,
      ),
    );
  }
}

// ============================================================
// HALAMAN DAFTAR PENGELUARAN
// ============================================================

class PengeluaranPage extends StatefulWidget {
  final bool modeGelap;
  final ValueChanged<bool> onTemaBerubah;

  const PengeluaranPage({
    super.key,
    required this.modeGelap,
    required this.onTemaBerubah,
  });

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  List<Pengeluaran> _daftar = [];
  int _total = 0;
  bool _memuat = true;
  String? _galat;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    try {
      final daftar = await DbHelper.semua();
      final total = await DbHelper.total();

      if (!mounted) return;

      setState(() {
        _daftar = daftar;
        _total = total;
        _memuat = false;
        _galat = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _memuat = false;
        _galat = e.toString();
      });
    }
  }

  String _rupiah(int nilai) {
    final angka = nilai.toString();
    final hasil = StringBuffer();

    for (int i = 0; i < angka.length; i++) {
      hasil.write(angka[i]);

      final sisa = angka.length - i - 1;

      if (sisa > 0 && sisa % 3 == 0) {
        hasil.write('.');
      }
    }

    return 'Rp$hasil';
  }

  String _formatTanggal(String tanggal) {
    final date = DateTime.tryParse(tanggal);

    if (date == null) return tanggal;

    final hari = date.day.toString().padLeft(2, '0');
    final bulan = date.month.toString().padLeft(2, '0');

    return '$hari/$bulan/${date.year}';
  }

  Future<void> _bukaForm([Pengeluaran? data]) async {
    final berubah = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengeluaranPage(data: data),
      ),
    );

    if (berubah == true && mounted) {
      await _muatData();
    }
  }

  Future<void> _konfirmasiHapus(Pengeluaran data) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Pengeluaran'),
          content: Text(
            'Hapus transaksi "${data.nama}"?',
          ),
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
        );
      },
    );

    if (yakin != true) return;

    await DbHelper.hapus(data.id!);

    if (!mounted) return;

    await _muatData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengeluaran berhasil dihapus'),
      ),
    );
  }

  IconData _ikonKategori(String kategori) {
    switch (kategori) {
      case 'Makanan':
        return Icons.restaurant;
      case 'Transportasi':
        return Icons.directions_bus;
      case 'Belanja':
        return Icons.shopping_bag;
      case 'Tagihan':
        return Icons.receipt_long;
      case 'Hiburan':
        return Icons.movie;
      default:
        return Icons.payments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatat Pengeluaran'),
        actions: [
          IconButton(
            tooltip: 'Ganti tema',
            onPressed: () {
              widget.onTemaBerubah(!widget.modeGelap);
            },
            icon: Icon(
              widget.modeGelap ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: _memuat
          ? const Center(child: CircularProgressIndicator())
          : _galat != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Terjadi kesalahan: $_galat'),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _muatData,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.account_balance_wallet),
                                  SizedBox(width: 8),
                                  Text('Total Pengeluaran'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _rupiah(_total),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_daftar.length} transaksi tersimpan',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Riwayat Pengeluaran',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Muat ulang',
                            onPressed: _muatData,
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      if (_daftar.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 64,
                              ),
                              SizedBox(height: 12),
                              Text('Belum ada pengeluaran'),
                              Text('Tekan tombol + untuk menambahkan data'),
                            ],
                          ),
                        )
                      else
                        ..._daftar.map((data) {
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Icon(
                                  _ikonKategori(data.kategori),
                                ),
                              ),
                              title: Text(
                                data.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${data.kategori} • '
                                '${_formatTanggal(data.tanggal)}',
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (pilihan) {
                                  if (pilihan == 'ubah') {
                                    _bukaForm(data);
                                  } else if (pilihan == 'hapus') {
                                    _konfirmasiHapus(data);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'ubah',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('Ubah'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'hapus',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 8),
                                        Text('Hapus'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _bukaForm(data),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bukaForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

// ============================================================
// FORM TAMBAH DAN UBAH PENGELUARAN
// ============================================================

class FormPengeluaranPage extends StatefulWidget {
  final Pengeluaran? data;

  const FormPengeluaranPage({
    super.key,
    this.data,
  });

  @override
  State<FormPengeluaranPage> createState() =>
      _FormPengeluaranPageState();
}

class _FormPengeluaranPageState extends State<FormPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _jumlahController;

  final List<String> _kategoriList = const [
    'Makanan',
    'Transportasi',
    'Belanja',
    'Tagihan',
    'Hiburan',
    'Lainnya',
  ];

  String? _kategori;
  DateTime _tanggal = DateTime.now();
  bool _menyimpan = false;

  bool get _sedangMengubah => widget.data != null;

  @override
  void initState() {
    super.initState();

    _namaController = TextEditingController(
      text: widget.data?.nama ?? '',
    );

    _jumlahController = TextEditingController(
      text: widget.data?.jumlah.toString() ?? '',
    );

    _kategori = widget.data?.kategori ?? _kategoriList.first;

    if (widget.data != null) {
      _tanggal = DateTime.tryParse(widget.data!.tanggal) ??
          DateTime.now();
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  String _tanggalUntukDatabase(DateTime date) {
    final tahun = date.year.toString();
    final bulan = date.month.toString().padLeft(2, '0');
    final hari = date.day.toString().padLeft(2, '0');

    return '$tahun-$bulan-$hari';
  }

  String _tanggalUntukTampilan(DateTime date) {
    final hari = date.day.toString().padLeft(2, '0');
    final bulan = date.month.toString().padLeft(2, '0');

    return '$hari/$bulan/${date.year}';
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (hasil == null || !mounted) return;

    setState(() {
      _tanggal = hasil;
    });
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_kategori == null ||
        !_kategoriList.contains(_kategori)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih kategori'),
        ),
      );
      return;
    }

    setState(() {
      _menyimpan = true;
    });

    try {
      final data = Pengeluaran(
        id: widget.data?.id,
        nama: _namaController.text.trim(),
        jumlah: int.parse(_jumlahController.text.trim()),
        kategori: _kategori!,
        tanggal: _tanggalUntukDatabase(_tanggal),
      );

      if (_sedangMengubah) {
        await DbHelper.ubah(data);
      } else {
        await DbHelper.tambah(data);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _sedangMengubah
                ? 'Pengeluaran berhasil diperbarui'
                : 'Pengeluaran berhasil ditambahkan',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan pengeluaran: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _menyimpan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _sedangMengubah
              ? 'Ubah Pengeluaran'
              : 'Tambah Pengeluaran',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _namaController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nama Pengeluaran',
                hintText: 'Contoh: Makan siang',
                prefixIcon: Icon(Icons.edit_note),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama pengeluaran wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Pengeluaran',
                hintText: 'Contoh: 25000',
                prefixText: 'Rp ',
                prefixIcon: Icon(Icons.payments),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Jumlah pengeluaran wajib diisi';
                }

                final jumlah = int.tryParse(value.trim());

                if (jumlah == null) {
                  return 'Jumlah harus berupa angka bulat';
                }

                if (jumlah <= 0) {
                  return 'Jumlah harus lebih dari 0';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriList.map((kategori) {
                return DropdownMenuItem<String>(
                  value: kategori,
                  child: Text(kategori),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _kategori = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Kategori wajib dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pilihTanggal,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pengeluaran',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _tanggalUntukTampilan(_tanggal),
                      ),
                    ),
                    const Icon(Icons.date_range),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _menyimpan ? null : _simpan,
                icon: const Icon(Icons.save),
                label: Text(
                  _menyimpan
                      ? 'Menyimpan...'
                      : 'Simpan Pengeluaran',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}