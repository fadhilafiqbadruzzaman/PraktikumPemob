import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/database_helper.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final db = DatabaseHelper.instance;
  bool loading = true;
  List<Map<String, dynamic>> perKategori = [];
  List<Map<String, dynamic>> perHari = [];

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  Future<void> _loadLaporan() async {
    setState(() => loading = true);
    try {
      final kategori = await db.getLaporanPerKategori();
      final hari = await db.getLaporan7HariTerakhir();
      if (!mounted) return;
      setState(() {
        perKategori = kategori;
        perHari = hari;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat laporan: $e')),
      );
    }
  }

  String _ringkasLaporan() {
    final buffer = StringBuffer();
    buffer.writeln('Laporan TabungKu');
    buffer.writeln('--- Per Kategori ---');
    for (final item in perKategori) {
      buffer.writeln(
        '${item['kategori']} | Pemasukan: ${item['pemasukan']} | Pengeluaran: ${item['pengeluaran']} | Saldo: ${item['saldo']}',
      );
    }
    buffer.writeln('--- 7 Hari Terakhir ---');
    for (final item in perHari) {
      buffer.writeln(
        '${item['tanggal']} | Pemasukan: ${item['pemasukan']} | Pengeluaran: ${item['pengeluaran']} | Saldo: ${item['saldo']}',
      );
    }
    return buffer.toString();
  }

  Future<void> _salinKeClipboard() async {
    try {
      final isi = _ringkasLaporan();
      await Clipboard.setData(ClipboardData(text: isi));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil disalin ke clipboard')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyalin laporan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        actions: [
          IconButton(
            onPressed: _salinKeClipboard,
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Per Kategori', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (perKategori.isEmpty)
                  const Text('Belum ada data per kategori.')
                else
                  ...perKategori.map(
                    (item) => Card(
                      child: ListTile(
                        title: Text(item['kategori'] as String),
                        subtitle: Text(
                          'Pemasukan: ${item['pemasukan']} | Pengeluaran: ${item['pengeluaran']} | Saldo: ${item['saldo']}',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text('7 Hari Terakhir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (perHari.isEmpty)
                  const Text('Belum ada data 7 hari terakhir.')
                else
                  ...perHari.map(
                    (item) => Card(
                      child: ListTile(
                        title: Text(item['tanggal'] as String),
                        subtitle: Text(
                          'Pemasukan: ${item['pemasukan']} | Pengeluaran: ${item['pengeluaran']} | Saldo: ${item['saldo']}',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
