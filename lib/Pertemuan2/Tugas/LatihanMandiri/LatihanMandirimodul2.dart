import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;

  const Makanan(
    this.nama,
    this.harga,
    this.deskripsi,
  );
}

const daftarMenu = [
  Makanan(
    'Nasi Goreng',
    15000,
    'Nasi goreng dengan telur dan bumbu spesial.',
  ),
  Makanan(
    'Mie Ayam',
    12000,
    'Mie ayam dengan topping ayam dan sayuran.',
  ),
  Makanan(
    'Es Teh',
    4000,
    'Minuman teh manis dingin dan menyegarkan.',
  ),
  Makanan(
    'Ayam Bakar',
    20000,
    'Ayam bakar dengan bumbu kecap spesial.',
  ),
  Makanan(
    'Bakso',
    15000,
    'Bakso sapi dengan kuah gurih.',
  ),
  Makanan(
    'Soto Ayam',
    18000,
    'Soto ayam dengan kuah hangat dan gurih.',
  ),
  Makanan(
    'Jus Alpukat',
    10000,
    'Jus alpukat segar dengan susu.',
  ),

  // 5 menu tambahan
  Makanan(
    'Nasi Uduk',
    13000,
    'Nasi uduk gurih dengan lauk dan sambal.',
  ),
  Makanan(
    'Ayam Geprek',
    18000,
    'Ayam crispy dengan sambal geprek pedas.',
  ),
  Makanan(
    'Kwetiau Goreng',
    17000,
    'Kwetiau goreng dengan sayuran dan telur.',
  ),
  Makanan(
    'Es Jeruk',
    6000,
    'Minuman jeruk dingin yang segar.',
  ),
  Makanan(
    'Pecel Lele',
    16000,
    'Lele goreng dengan sambal dan lalapan.',
  ),
];

String formatRupiah(int harga) {
  return harga.toString().replaceAllMapped(
    RegExp(r'(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum 2',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF82FC00),
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Menu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF82FC00).withOpacity(0.65),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];

          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              // Warna #82FC00 dibuat lebih lembut
              color: const Color(0xFF82FC00).withOpacity(0.25),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFF82FC00).withOpacity(0.65),
                width: 1.5,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    const Color(0xFF82FC00).withOpacity(0.75),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.black,
                ),
              ),
              title: Text(
                item.nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Rp ${formatRupiah(item.harga)}',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      makanan: item,
                    ),
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

class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({
    super.key,
    required this.makanan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(makanan.nama),
        backgroundColor:
            const Color(0xFF82FC00).withOpacity(0.65),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor:
                    const Color(0xFF82FC00).withOpacity(0.35),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 55,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                makanan.nama,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${formatRupiah(makanan.harga)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF82FC00)
                      .withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  makanan.deskripsi,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
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
      ),
    );
  }
}