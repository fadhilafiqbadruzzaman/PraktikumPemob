
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum 4',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const PenggunaPage(),
    );
  }
}

class Pengguna {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String kota;

  const Pengguna({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.kota,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>;

    return Pengguna(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      kota: address['city'] as String,
    );
  }
}

Future<List<Pengguna>> ambilPengguna() async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/users',
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal memuat data (kode ${response.statusCode})',
    );
  }

  final List<dynamic> data = jsonDecode(response.body);

  return data
      .map(
        (item) => Pengguna.fromJson(
          item as Map<String, dynamic>,
        ),
      )
      .toList();
}

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({super.key});

  @override
  State<PenggunaPage> createState() => _PenggunaPageState();
}

class _PenggunaPageState extends State<PenggunaPage> {
  late Future<List<Pengguna>> _future;

  @override
  void initState() {
    super.initState();
    _future = ambilPengguna();
  }

  Future<void> _muatUlang() async {
    final futureBaru = ambilPengguna();

    setState(() {
      _future = futureBaru;
    });

    await futureBaru;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: FutureBuilder<List<Pengguna>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Pengguna (${snapshot.data!.length})',
              );
            }

            return const Text('Daftar Pengguna');
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _muatUlang().catchError((_) {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Pengguna>>(
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Terjadi kesalahan:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        _muatUlang().catchError((_) {});
                      },
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _muatUlang,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final pengguna = data[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(pengguna.name[0]),
                  ),
                  title: Text(pengguna.name),
                  subtitle: Text(
                    '@${pengguna.username}\n'
                    '${pengguna.email}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPenggunaPage(
                          pengguna: pengguna,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailPenggunaPage extends StatelessWidget {
  final Pengguna pengguna;

  const DetailPenggunaPage({
    super.key,
    required this.pengguna,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pengguna.name),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Nama Lengkap'),
            subtitle: Text(pengguna.name),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Username'),
            subtitle: Text(pengguna.username),
          ),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Kota'),
            subtitle: Text(pengguna.kota),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(pengguna.email),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Telepon'),
            subtitle: Text(pengguna.phone),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Website'),
            subtitle: Text(pengguna.website),
          ),
        ],
      ),
    );
  }
}
