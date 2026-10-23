import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Item {
  final String nama;
  final IconData ikon;
  final Color warna;

  const Item(this.nama, this.ikon, this.warna);
}

const daftarItem = [
  Item('Flutter', Icons.flutter_dash, Colors.blue),
  Item('Musik', Icons.music_note, Colors.pink),
  Item('Kamera', Icons.camera_alt, Colors.orange),
  Item('Peta', Icons.map, Colors.green),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes dan Hero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const BerandaTab(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final argumen = settings.arguments;

          if (argumen is Item) {
            return MaterialPageRoute(
              builder: (_) => DetailPage(item: argumen),
              settings: settings,
            );
          }
        }

        return MaterialPageRoute(
          builder: (_) => const TidakDitemukanPage(),
        );
      },
    );
  }
}

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Item'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: daftarItem.length,
        itemBuilder: (context, index) {
          final item = daftarItem[index];

          return Card(
            child: ListTile(
              leading: Hero(
                tag: 'ikon-${item.nama}',
                child: CircleAvatar(
                  backgroundColor: item.warna,
                  child: Icon(
                    item.ikon,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                item.nama,
                style: tema.textTheme.titleMedium,
              ),
              subtitle: const Text('Tekan untuk melihat detail'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: item,
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
  final Item item;

  const DetailPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.nama),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                radius: 64,
                backgroundColor: item.warna,
                child: Icon(
                  item.ikon,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item.nama,
              style: tema.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Detail untuk ${item.nama}',
              style: tema.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

class TidakDitemukanPage extends StatelessWidget {
  const TidakDitemukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Tidak Ditemukan'),
      ),
      body: const Center(
        child: Text('404 - Halaman tidak ditemukan'),
      ),
    );
  }
}