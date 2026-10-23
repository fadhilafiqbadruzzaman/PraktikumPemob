import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum 3',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _email = TextEditingController();

  String? _jurusan;
  bool _setuju = false;

  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    super.dispose();
  }

  void _kirim() {
    if (_formKey.currentState!.validate()) {
      final jurusan = _jurusan ?? '-';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terdaftar: ${_nama.text} ($jurusan)',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pendaftaran'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama lengkap',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Email tidak valid';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Jurusan',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'TI',
                  child: Text('Teknik Informatika'),
                ),
                DropdownMenuItem(
                  value: 'SI',
                  child: Text('Sistem Informasi'),
                ),
                DropdownMenuItem(
                  value: 'TE',
                  child: Text('Teknik Elektro'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _jurusan = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Pilih jurusan';
                }

                return null;
              },
            ),

            CheckboxListTile(
              title: const Text('Saya menyetujui ketentuan'),
              value: _setuju,
              activeColor: Colors.green,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  _setuju = value ?? false;
                });
              },
            ),

            ElevatedButton(
              onPressed: _setuju ? _kirim : null,
              child: const Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}