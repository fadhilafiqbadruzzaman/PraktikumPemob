
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<ThemeMode> themeMode =
    ValueNotifier<ThemeMode>(ThemeMode.light);

final ValueNotifier<Color> seedColor =
    ValueNotifier<Color>(Colors.indigo);

const List<Color> pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

Future<void> simpanTema() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool(
    'modeGelap',
    themeMode.value == ThemeMode.dark,
  );

  await prefs.setInt(
    'warnaTema',
    seedColor.value.value,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final modeGelap = prefs.getBool('modeGelap') ?? false;
  final warnaTersimpan = prefs.getInt('warnaTema');

  themeMode.value =
      modeGelap ? ThemeMode.dark : ThemeMode.light;

  if (warnaTersimpan != null) {
    seedColor.value = Color(warnaTersimpan);
  }

  runApp(const MyApp());
}

ThemeData buatTema(Color warna, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: warna,
    brightness: brightness,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Galeri Wisata',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          home: const ShellPage(),
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final argumen = settings.arguments;

              if (argumen is ItemWisata) {
                return MaterialPageRoute(
                  builder: (_) => DetailWisata(item: argumen),
                  settings: settings,
                );
              }
            }

            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => const Halaman404(),
            );
          },
        );
      },
    );
  }
}

// MODEL DATA WISATA

class ItemWisata {
  final String nama;
  final String lokasi;
  final String deskripsi;
  final IconData ikon;

  const ItemWisata({
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.ikon,
  });
}

const List<ItemWisata> daftarWisata = [
  ItemWisata(
    nama: 'Pantai',
    lokasi: 'Wisata alam',
    deskripsi:
        'Pantai menjadi tempat yang cocok untuk menikmati '
        'pemandangan laut, pasir, dan suasana matahari terbenam.',
    ikon: Icons.beach_access,
  ),
  ItemWisata(
    nama: 'Pegunungan',
    lokasi: 'Wisata alam',
    deskripsi:
        'Pegunungan menawarkan udara sejuk, pemandangan '
        'alam, serta pengalaman menikmati keindahan dataran tinggi.',
    ikon: Icons.landscape,
  ),
  ItemWisata(
    nama: 'Air Terjun',
    lokasi: 'Wisata alam',
    deskripsi:
        'Air terjun menyajikan pemandangan aliran air yang '
        'indah dan suasana alam yang menyegarkan.',
    ikon: Icons.water,
  ),
  ItemWisata(
    nama: 'Hutan',
    lokasi: 'Wisata alam',
    deskripsi:
        'Hutan merupakan tempat untuk menikmati pepohonan '
        'hijau dan mengenal keanekaragaman alam.',
    ikon: Icons.forest,
  ),
  ItemWisata(
    nama: 'Perkotaan',
    lokasi: 'Wisata kota',
    deskripsi:
        'Wisata kota menawarkan berbagai tempat menarik, '
        'bangunan ikonik, dan pengalaman menjelajahi kota.',
    ikon: Icons.location_city,
  ),
  ItemWisata(
    nama: 'Taman',
    lokasi: 'Wisata keluarga',
    deskripsi:
        'Taman cocok untuk bersantai, berjalan-jalan, dan '
        'menikmati ruang terbuka bersama keluarga.',
    ikon: Icons.park,
  ),
];

// HALAMAN UTAMA DENGAN TIGA TAB

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const List<String> _judul = [
    'Beranda',
    'Katalog Wisata',
    'Pengaturan',
  ];

  void _pindahTab(int index) {
    Navigator.pop(context);
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_judul[_index]),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.travel_explore,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Galeri Wisata',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Beranda'),
                selected: _index == 0,
                onTap: () => _pindahTab(0),
              ),
              ListTile(
                leading: const Icon(Icons.explore_outlined),
                title: const Text('Katalog Wisata'),
                selected: _index == 1,
                onTap: () => _pindahTab(1),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Pengaturan'),
                selected: _index == 2,
                onTap: () => _pindahTab(2),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          BerandaTab(),
          KatalogTab(),
          PengaturanTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

// TAB BERANDA

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(
          Icons.travel_explore,
          size: 90,
          color: tema.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Jelajahi Keindahan Wisata',
          textAlign: TextAlign.center,
          style: tema.textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(
          'Temukan berbagai inspirasi tempat wisata melalui '
          'Galeri Wisata Interaktif. Pilih tempat favoritmu '
          'dan buka detail untuk membaca informasinya.',
          textAlign: TextAlign.center,
          style: tema.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            // Berpindah ke tab katalog dilakukan melalui
            // NavigationBar atau Drawer.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Pilih tab Katalog untuk melihat daftar wisata.',
                ),
              ),
            );
          },
          icon: const Icon(Icons.explore),
          label: const Text('Jelajahi Katalog'),
        ),
        const SizedBox(height: 24),
        const DemoAnimasi(),
      ],
    );
  }
}

// TAB KATALOG

class KatalogTab extends StatelessWidget {
  const KatalogTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Pilihan Tempat Wisata',
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Tekan salah satu kartu untuk melihat detail wisata.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        for (final item in daftarWisata)
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Hero(
                tag: 'wisata-${item.nama}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: tema.colorScheme.primaryContainer,
                  child: Icon(
                    item.ikon,
                    color: tema.colorScheme.onPrimaryContainer,
                    size: 30,
                  ),
                ),
              ),
              title: Text(
                item.nama,
                style: tema.textTheme.titleMedium,
              ),
              subtitle: Text(item.lokasi),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: item,
                );
              },
            ),
          ),
      ],
    );
  }
}

// HALAMAN DETAIL DENGAN HERO

class DetailWisata extends StatelessWidget {
  final ItemWisata item;

  const DetailWisata({
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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Hero(
              tag: 'wisata-${item.nama}',
              child: CircleAvatar(
                radius: 70,
                backgroundColor: tema.colorScheme.primaryContainer,
                child: Icon(
                  item.ikon,
                  size: 76,
                  color: tema.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            item.nama,
            textAlign: TextAlign.center,
            style: tema.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            item.lokasi,
            textAlign: TextAlign.center,
            style: tema.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                item.deskripsi,
                style: tema.textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali ke Katalog'),
          ),
        ],
      ),
    );
  }
}

// TAB PENGATURAN TEMA

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        final tema = Theme.of(context);

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Pengaturan Tampilan',
              style: tema.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mode gelap'),
              subtitle: const Text(
                'Simpan pilihan mode terang atau gelap.',
              ),
              value: themeMode.value == ThemeMode.dark,
              onChanged: (value) async {
                themeMode.value =
                    value ? ThemeMode.dark : ThemeMode.light;

                await simpanTema();
              },
            ),
            const Divider(height: 32),
            Text(
              'Warna Tema',
              style: tema.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih warna utama aplikasi.',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final warna in pilihanWarna)
                  Semantics(
                    button: true,
                    label: 'Pilih warna ${warna.toString()}',
                    child: GestureDetector(
                      onTap: () async {
                        seedColor.value = warna;
                        await simpanTema();
                      },
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: warna,
                        child: seedColor.value.value == warna.value
                            ? Icon(
                                Icons.check,
                                color: warna.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.palette_outlined,
                  color: tema.colorScheme.primary,
                ),
                title: const Text('Tema aktif'),
                subtitle: Text(
                  themeMode.value == ThemeMode.dark
                      ? 'Mode gelap'
                      : 'Mode terang',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// DEMO ANIMASI IMPLISIT DAN EKSPLISIT

class DemoAnimasi extends StatefulWidget {
  const DemoAnimasi({super.key});

  @override
  State<DemoAnimasi> createState() => _DemoAnimasiState();
}

class _DemoAnimasiState extends State<DemoAnimasi>
    with SingleTickerProviderStateMixin {
  bool _diperbesar = false;

  late final AnimationController _controller;

  late final Animation<double> _rotasi;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rotasi = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Demo Animasi',
              style: tema.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Animasi implisit: AnimatedContainer.
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: _diperbesar ? 180 : 120,
              height: _diperbesar ? 120 : 80,
              decoration: BoxDecoration(
                color: tema.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(
                  _diperbesar ? 32 : 12,
                ),
              ),
              child: Icon(
                Icons.landscape,
                size: _diperbesar ? 64 : 42,
                color: tema.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                setState(() {
                  _diperbesar = !_diperbesar;
                });
              },
              child: const Text('Ubah Ukuran Kartu'),
            ),
            const Divider(height: 32),

            // Animasi eksplisit: AnimationController.
            RotationTransition(
              turns: _rotasi,
              child: Icon(
                Icons.explore,
                size: 64,
                color: tema.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: () => _controller.forward(from: 0),
                  child: const Text('Putar'),
                ),
                OutlinedButton(
                  onPressed: () => _controller.stop(),
                  child: const Text('Berhenti'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// HALAMAN 404

class Halaman404 extends StatelessWidget {
  const Halaman404({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman tidak ditemukan'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: tema.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '404 - Halaman tidak ditemukan',
                textAlign: TextAlign.center,
                style: tema.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShellPage(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
