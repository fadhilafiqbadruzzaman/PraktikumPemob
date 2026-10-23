import 'package:flutter/material.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

const pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );
}

void main() {
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
          title: 'Praktikum 6',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Pengaturan Tema'),
            ),
            body: const PengaturanTab(),
          ),
        );
      },
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        final tema = Theme.of(context);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Pengaturan Tampilan',
              style: tema.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Mode gelap'),
              subtitle: const Text(
                'Aktifkan atau nonaktifkan tema gelap',
              ),
              value: themeMode.value == ThemeMode.dark,
              onChanged: (nilai) {
                themeMode.value =
                    nilai ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Warna tema',
              style: tema.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final warna in pilihanWarna)
                  GestureDetector(
                    onTap: () {
                      seedColor.value = warna;
                    },
                    child: CircleAvatar(
                      backgroundColor: warna,
                      child: seedColor.value == warna
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.palette,
                  color: tema.colorScheme.primary,
                ),
                title: const Text('Pratinjau tema'),
                subtitle: const Text(
                  'Warna mengikuti pilihan tema saat ini.',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}