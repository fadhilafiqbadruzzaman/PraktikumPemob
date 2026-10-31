import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/database_helper.dart';
import '../models/kegiatan.dart';

class FormKegiatanScreen extends StatefulWidget {
  final Kegiatan? kegiatan;

  const FormKegiatanScreen({super.key, this.kegiatan});

  @override
  State<FormKegiatanScreen> createState() => _FormKegiatanScreenState();
}

class _FormKegiatanScreenState extends State<FormKegiatanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _nominalController = TextEditingController();
  final _catatanController = TextEditingController();
  final db = DatabaseHelper.instance;
  final List<Map<String, dynamic>> _kategoriList = [];
  String _jenis = 'pengeluaran';
  int? _kategoriId;
  DateTime _tanggal = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadKategori();
    if (widget.kegiatan != null) {
      final item = widget.kegiatan!;
      _judulController.text = item.judul;
      _nominalController.text = item.nominal.toString();
      _catatanController.text = item.catatan ?? '';
      _jenis = item.jenis;
      _kategoriId = item.kategoriId;
      _tanggal = DateTime.tryParse(item.tanggal) ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _loadKategori() async {
    final list = await db.getKategori();
    if (!mounted) return;
    setState(() {
      _kategoriList.addAll(list);
      if (_kategoriId == null && list.isNotEmpty) {
        _kategoriId = list.first['id'] as int;
      }
    });
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _tanggal = picked);
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nominal = int.tryParse(_nominalController.text.trim());
    if (nominal == null || nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal harus lebih dari 0')),
      );
      return;
    }

    final item = Kegiatan(
      id: widget.kegiatan?.id,
      judul: _judulController.text.trim(),
      nominal: nominal,
      jenis: _jenis,
      tanggal: DateFormat('yyyy-MM-dd').format(_tanggal),
      kategoriId: _kategoriId,
      catatan: _catatanController.text.trim(),
    );

    try {
      if (widget.kegiatan == null) {
        await db.insertKegiatan(item);
      } else {
        await db.updateKegiatan(item);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kegiatan == null ? 'Tambah Kegiatan' : 'Ubah Kegiatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(labelText: 'Judul kegiatan'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _jenis,
                items: const [
                  DropdownMenuItem(value: 'pemasukan', child: Text('Pemasukan')),
                  DropdownMenuItem(value: 'pengeluaran', child: Text('Pengeluaran')),
                ],
                onChanged: (value) => setState(() => _jenis = value ?? 'pengeluaran'),
                decoration: const InputDecoration(labelText: 'Jenis'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tanggal'),
                subtitle: Text(DateFormat('dd MMMM yyyy').format(_tanggal)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pilihTanggal,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _kategoriId,
                items: _kategoriList
                    .map(
                      (item) => DropdownMenuItem<int>(
                        value: item['id'] as int,
                        child: Text(item['nama'] as String),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _kategoriId = value),
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Catatan (opsional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpan,
                child: Text(widget.kegiatan == null ? 'Simpan' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
