import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

const pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

const pilihanWarnaNama = [
  'Indigo',
  'Teal',
  'Oranye',
  'Pink',
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  themeMode.value = prefs.getBool('modeGelap') == true
      ? ThemeMode.dark
      : ThemeMode.light;

  final warnaIndex = prefs.getInt('warnaTema') ?? 0;

  seedColor.value = pilihanWarna[
    warnaIndex.clamp(0, pilihanWarna.length - 1)
  ];

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Latihan Praktikum 6',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final argumen = settings.arguments;

              if (argumen is Item) {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, animation, secondaryAnimation) {
                    return DetailPage(item: argumen);
                  },
                  transitionsBuilder:
                      (_, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration:
                      const Duration(milliseconds: 400),
                );
              }
            }

            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => const TidakDitemukanPage(),
            );
          },
        );
      },
    );
  }
}

class Item {
  final String nama;
  final IconData ikon;
  final Color warna;
  final String deskripsi;

  const Item(
    this.nama,
    this.ikon,
    this.warna,
    this.deskripsi,
  );
}

const daftarItem = [
  Item(
    'Flutter',
    Icons.flutter_dash,
    Colors.blue,
    'Flutter adalah framework untuk membangun aplikasi '
        'multiplatform menggunakan bahasa Dart.',
  ),
  Item(
    'Musik',
    Icons.music_note,
    Colors.pink,
    'Musik merupakan susunan bunyi dan irama yang '
        'dapat dinikmati untuk hiburan.',
  ),
  Item(
    'Kamera',
    Icons.camera_alt,
    Colors.orange,
    'Kamera digunakan untuk mengambil foto dan '
        'merekam berbagai momen.',
  ),
  Item(
    'Peta',
    Icons.map,
    Colors.green,
    'Peta membantu pengguna melihat lokasi dan '
        'memahami arah perjalanan.',
  ),
];

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _judul = [
    'Beranda',
    'Animasi',
    'Pengaturan',
  ];

  static const _halaman = [
    BerandaTab(),
    AnimasiTab(),
    PengaturanTab(),
  ];

  void _pindahTab(int index) {
    setState(() {
      _index = index;
    });

    Navigator.popUntil(context, (route) => route.isFirst);
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
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Center(
                  child: Text(
                    'Menu Praktikum 6',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Beranda'),
                selected: _index == 0,
                onTap: () => _pindahTab(0),
              ),
              ListTile(
                leading: const Icon(Icons.animation),
                title: const Text('Animasi'),
                selected: _index == 1,
                onTap: () => _pindahTab(1),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
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
        children: _halaman,
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
            icon: Icon(Icons.animation),
            label: 'Animasi',
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

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final item in daftarItem)
          Card(
            child: ListTile(
              leading: Hero(
                tag: 'ikon-${item.nama}',
                child: CircleAvatar(
                  backgroundColor: item.warna,
                  child: Icon(item.ikon, color: Colors.white),
                ),
              ),
              title: Text(item.nama),
              subtitle: Text(item.deskripsi),
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
      appBar: AppBar(title: Text(item.nama)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 12),
              Text(
                item.deskripsi,
                textAlign: TextAlign.center,
                style: tema.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab>
    with SingleTickerProviderStateMixin {
  bool _besar = false;
  bool _terlihat = true;
  int _angka = 0;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '1. AnimatedContainer',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _besar ? 220 : 100,
            height: 90,
            decoration: BoxDecoration(
              color: _besar ? warna.primary : warna.tertiary,
              borderRadius: BorderRadius.circular(
                _besar ? 40 : 8,
              ),
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _besar = !_besar;
              });
            },
            child: const Text('Ubah bentuk'),
          ),
        ),
        const Divider(),
        Text(
          '2. AnimatedSwitcher',
          style: tema.textTheme.titleMedium,
        ),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animasi) {
              return ScaleTransition(
                scale: animasi,
                child: child,
              );
            },
            child: Text(
              '$_angka',
              key: ValueKey(_angka),
              style: tema.textTheme.displayMedium,
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _angka++;
              });
            },
            child: const Text('Tambah angka'),
          ),
        ),
        const Divider(),
        Text(
          '3. AnimationController',
          style: tema.textTheme.titleMedium,
        ),
        Center(
          child: RotationTransition(
            turns: _controller,
            child: Icon(
              Icons.settings,
              size: 64,
              color: warna.primary,
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                if (_controller.isAnimating) {
                  _controller.stop();
                } else {
                  _controller.repeat();
                }
              });
            },
            child: Text(
              _controller.isAnimating ? 'Berhenti' : 'Putar',
            ),
          ),
        ),
        const Divider(),
        Text(
          '4. AnimatedOpacity',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedOpacity(
            opacity: _terlihat ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 48,
                      color: warna.primary,
                    ),
                    const SizedBox(height: 8),
                    const Text('Kartu animasi'),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _terlihat = !_terlihat;
              });
            },
            child: Text(
              _terlihat ? 'Sembunyikan kartu' : 'Tampilkan kartu',
            ),
          ),
        ),
      ],
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  Future<void> _simpanMode(bool gelap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modeGelap', gelap);
    themeMode.value = gelap ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _simpanWarna(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('warnaTema', index);
    seedColor.value = pilihanWarna[index];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        final tema = Theme.of(context);
        final indexWarna = pilihanWarna.indexWhere(
  (warna) => warna.value == seedColor.value.value,
);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Pengaturan Tema',
              style: tema.textTheme.titleLarge,
            ),
            SwitchListTile(
              title: const Text('Mode gelap'),
              value: themeMode.value == ThemeMode.dark,
              onChanged: _simpanMode,
            ),
            const SizedBox(height: 16),
            Text(
              'Warna tema',
              style: tema.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < pilihanWarna.length; i++)
              RadioListTile<int>(
                value: i,
                groupValue: indexWarna,
                title: Text(pilihanWarnaNama[i]),
                secondary: CircleAvatar(
                  backgroundColor: pilihanWarna[i],
                ),
                onChanged: (nilai) {
                  if (nilai != null) {
                    _simpanWarna(nilai);
                  }
                },
              ),
          ],
        );
      },
    );
  }
}

class TidakDitemukanPage extends StatelessWidget {
  const TidakDitemukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: tema.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              '404 - Halaman tidak ditemukan',
              style: tema.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}