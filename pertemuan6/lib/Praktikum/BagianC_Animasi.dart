import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const AnimasiTab(),
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
  int _hitung = 0;

  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();

    _putar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Animasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '1. AnimatedContainer',
            style: tema.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: _besar ? 200 : 100,
              height: 100,
              decoration: BoxDecoration(
                color: _besar ? warna.primary : warna.tertiary,
                borderRadius: BorderRadius.circular(
                  _besar ? 50 : 8,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.animation,
                color: warna.onPrimary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _besar = !_besar;
                });
              },
              child: const Text('Ubah bentuk'),
            ),
          ),
          const Divider(height: 32),
          Text(
            '2. AnimatedSwitcher',
            style: tema.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
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
                '$_hitung',
                key: ValueKey(_hitung),
                style: tema.textTheme.displayMedium,
              ),
            ),
          ),
          Center(
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _hitung++;
                });
              },
              child: const Text('Tambah angka'),
            ),
          ),
          const Divider(height: 32),
          Text(
            '3. AnimationController',
            style: tema.textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          Center(
            child: RotationTransition(
              turns: _putar,
              child: Icon(
                Icons.settings,
                size: 72,
                color: warna.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: FilledButton(
              onPressed: () {
                setState(() {
                  if (_putar.isAnimating) {
                    _putar.stop();
                  } else {
                    _putar.repeat();
                  }
                });
              },
              child: Text(
                _putar.isAnimating ? 'Berhenti' : 'Putar',
              ),
            ),
          ),
        ],
      ),
    );
  }
}