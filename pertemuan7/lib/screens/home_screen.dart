import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database_helper.dart';
import '../models/kegiatan.dart';
import 'form_kegiatan_screen.dart';
import 'laporan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final database = DatabaseHelper.instance;
  final searchController = TextEditingController();
  final valueNotifier = ValueNotifier<int>(0);
  List<Kegiatan> kegiatan = [];
  bool isLoading = true;
  String? jenisFilter;
  int? kategoriFilter;
  List<Map<String, dynamic>> kategoriList = [];

  @override
  void initState() {
    super.initState();
    valueNotifier.addListener(_refreshData);
    _loadKategori();
    _loadData();
  }

  @override
  void dispose() {
    valueNotifier.removeListener(_refreshData);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  Future<void> _loadKategori() async {
    final data = await database.getKategori();
    if (!mounted) return;
    setState(() {
      kategoriList = data;
    });
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await database.getKegiatan(
        search: searchController.text,
        jenis: jenisFilter,
        kategoriId: kategoriFilter,
      );
      if (!mounted) return;
      setState(() {
        kegiatan = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  Future<void> _hapusKegiatan(int id) async {
    try {
      await database.deleteKegiatan(id);
      valueNotifier.value = valueNotifier.value + 1;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kegiatan berhasil dihapus')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus kegiatan: $e')),
      );
    }
  }

  Future<void> _simpanPreferensi(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final totalPemasukan = kegiatan
        .where((item) => item.jenis == 'pemasukan')
        .fold<int>(0, (sum, item) => sum + item.nominal);
    final totalPengeluaran = kegiatan
        .where((item) => item.jenis == 'pengeluaran')
        .fold<int>(0, (sum, item) => sum + item.nominal);
    final saldo = totalPemasukan - totalPengeluaran;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TabungKu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LaporanScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormKegiatanScreen()),
          );
          if (result == true) {
            valueNotifier.value = valueNotifier.value + 1;
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari judul kegiatan',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => _loadData(),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: jenisFilter,
                  hint: const Text('Jenis'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Semua')),
                    DropdownMenuItem(value: 'pemasukan', child: Text('Pemasukan')),
                    DropdownMenuItem(value: 'pengeluaran', child: Text('Pengeluaran')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      jenisFilter = value;
                    });
                    _loadData();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (kategoriList.isNotEmpty)
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: kategoriList.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ChoiceChip(
                        label: const Text('Semua'),
                        selected: kategoriFilter == null,
                        onSelected: (_) {
                          setState(() => kategoriFilter = null);
                          _loadData();
                        },
                      );
                    }
                    final item = kategoriList[index - 1];
                    final id = item['id'] as int;
                    return ChoiceChip(
                      label: Text(item['nama'] as String),
                      selected: kategoriFilter == id,
                      onSelected: (_) {
                        setState(() => kategoriFilter = id);
                        _loadData();
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text('Pemasukan'),
                          Text('Rp $totalPemasukan', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text('Pengeluaran'),
                          Text('Rp $totalPengeluaran', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Saldo'),
                    Text('Rp $saldo', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : kegiatan.isEmpty
                      ? const Center(child: Text('Belum ada data kegiatan.'))
                      : ListView.separated(
                          itemCount: kegiatan.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final item = kegiatan[index];
                            final nominal = item.nominal;
                            final warna = item.jenis == 'pemasukan' ? Colors.green : Colors.red;
                            return ListTile(
                              title: Text(item.judul),
                              subtitle: Text('${item.tanggal} • ${item.kategoriNama ?? 'Tanpa kategori'}'),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${item.jenis == 'pemasukan' ? '+' : '-'}Rp $nominal',
                                    style: TextStyle(color: warna, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => FormKegiatanScreen(kegiatan: item),
                                            ),
                                          );
                                          if (result == true) {
                                            valueNotifier.value = valueNotifier.value + 1;
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 18),
                                        onPressed: () => _hapusKegiatan(item.id!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
