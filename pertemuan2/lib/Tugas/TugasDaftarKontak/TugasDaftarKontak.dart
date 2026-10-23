import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Kontak {
  final String nama;
  final String telepon;
  final String email;

  const Kontak({
    required this.nama,
    required this.telepon,
    required this.email,
  });
}

const daftarKontak = [
  Kontak(
    nama: 'Kaisar Dukes',
    telepon: '081234567890',
    email: 'kaisardukes@gmail.com',
  ),
  Kontak(
    nama: 'Bagas',
    telepon: '081234567891',
    email: 'bagas@gmail.com',
  ),
  Kontak(
    nama: 'Amalia Mutia',
    telepon: '081234567892',
    email: 'amaliamutia@gmail.com',
  ),
  Kontak(
    nama: 'Dinda Putri',
    telepon: '081234567893',
    email: 'dinda@gmail.com',
  ),
  Kontak(
    nama: 'Jacobi',
    telepon: '081234567894',
    email: 'jacobi@gmail.com',
  ),
  Kontak(
    nama: 'Amba Suki',
    telepon: '081234567895',
    email: 'amba@gmail.com',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Kontak',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF82FC00),
        useMaterial3: true,
      ),
      home: const KontakPage(),
    );
  }
}

class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Kontak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            const Color(0xFF82FC00).withOpacity(0.65),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final kontak = daftarKontak[index];

          return Card(
            color: const Color(0xFF82FC00).withOpacity(0.25),
            surfaceTintColor: Colors.transparent,
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    const Color(0xFF82FC00).withOpacity(0.75),
                child: Text(
                  kontak.nama[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              title: Text(
                kontak.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                kontak.telepon,
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return DetailKontakPage(
                        kontak: kontak,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;

  const DetailKontakPage({
    super.key,
    required this.kontak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Kontak',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            const Color(0xFF82FC00).withOpacity(0.65),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),

            CircleAvatar(
              radius: 50,
              backgroundColor:
                  const Color(0xFF82FC00).withOpacity(0.75),
              child: Text(
                kontak.nama[0],
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              kontak.nama,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Nomor Telepon'),
              subtitle: Text(kontak.telepon),
            ),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(kontak.email),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF82FC00),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}