# Dokumentasi Code Pertemuan 6

## 1. Pendahuluan
Pada pertemuan 6, materi yang dibahas berfokus pada pengembangan UI dan navigasi dalam Flutter. Kode yang ada di folder Praktikum dan Tugas membahas beberapa konsep utama, yaitu:

- pengaturan tema terang dan gelap
- navigasi antar halaman menggunakan named routes
- animasi sederhana pada widget
- navigasi tab bawah dan drawer
- penggabungan beberapa fitur dalam satu aplikasi tugas

Dokumen ini dibuat untuk menjelaskan setiap bagian sesuai dengan isi file `.dart` yang ada. Folder Modul tidak dibahas karena memang tidak termasuk dalam permintaan.

---

## 2. Bagian A: Tema Terang dan Gelap
File yang dibahas: `BagianA_TemaTerangdanGelap.dart`

Bagian ini fokus pada pengaturan tema aplikasi. Kode ini menggunakan `ValueNotifier` untuk mengamati perubahan mode dan warna tema.

Contoh kode utama:

```dart
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
```

### Penjelasan kode
- `themeMode` berfungsi untuk menampung status tema saat ini, apakah sedang light atau dark.
- `seedColor` berfungsi untuk menyimpan warna utama aplikasi.
- `buatTema` membuat objek `ThemeData` yang berisi konfigurasi tema, termasuk warna utama dan brightness.
- `MaterialApp` kemudian memakai `theme`, `darkTheme`, dan `themeMode` untuk mengubah tampilan seluruh aplikasi.

Contoh penggunaan dalam `MaterialApp`:

```dart
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
```

### Fitur yang ada di bagian ini
- `SwitchListTile` untuk mengaktifkan mode gelap
- `Wrap` berisi pilihan warna tema
- `CircleAvatar` untuk menampilkan warna pilihan
- `ListenableBuilder` untuk rebuild widget ketika nilai `themeMode` atau `seedColor` berubah

### Kesimpulan Bagian A
Bagian ini menjelaskan bahwa aplikasi dapat dibuat lebih menarik dan user-friendly dengan sistem tema yang dinamis. User bisa memilih tampilan terang atau gelap sesuai preferensi.

---

## 3. Bagian B: Named Routes
File yang dibahas: `BagianB_NamedRoutes.dart`

Bagian ini berfokus pada navigasi antar halaman dengan route yang diberi nama. Tujuannya agar aplikasi lebih terstruktur dan mudah dikelola.

Contoh kode utama:

```dart
return MaterialApp(
  title: 'Named Routes dan Hero',
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
```

### Penjelasan kode
- `initialRoute: '/'` menandakan halaman pertama yang dibuka adalah halaman beranda.
- `routes` digunakan untuk route yang sudah diketahui seperti `/`.
- `onGenerateRoute` dipakai untuk route dinamis seperti `/detail`.
- `settings.arguments` digunakan untuk mengirim data dari halaman satu ke halaman lain.

Contoh navigasi ke halaman detail:

```dart
Navigator.pushNamed(
  context,
  '/detail',
  arguments: item,
);
```

### Komponen penting
- `Item` adalah model data yang berisi `nama`, `ikon`, dan `warna`.
- `BerandaTab` menampilkan daftar item.
- `DetailPage` menampilkan informasi lengkap item yang dipilih.
- `Hero` digunakan agar icon item berpindah halus saat berpindah halaman.

Contoh `Hero`:

```dart
Hero(
  tag: 'ikon-${item.nama}',
  child: CircleAvatar(
    backgroundColor: item.warna,
    child: Icon(
      item.ikon,
      color: Colors.white,
    ),
  ),
)
```

### Kesimpulan Bagian B
Bagian ini menunjukkan bahwa route yang rapi akan memudahkan pengelolaan aplikasi yang lebih besar. Data dapat dikirim antar halaman, dan transisi antar halaman menjadi lebih halus.

---

## 4. Bagian C: Animasi Sederhana
File yang dibahas: `BagianC_Animasi.dart`

Bagian ini membahas penggunaan animasi pada widget agar aplikasi lebih hidup dan interaktif.

### a. AnimatedContainer
Contoh kode:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 500),
  curve: Curves.easeInOut,
  width: _besar ? 200 : 100,
  height: 100,
  decoration: BoxDecoration(
    color: _besar ? warna.primary : warna.tertiary,
    borderRadius: BorderRadius.circular(_besar ? 50 : 8),
  ),
)
```

Penjelasan:
- `AnimatedContainer` akan secara otomatis berubah bentuk saat nilai `width` atau `borderRadius` berubah.
- properti `duration` menentukan durasi animasi.
- `curve` menentukan jenis gerakan animasinya.

### b. AnimatedSwitcher
Contoh kode:

```dart
AnimatedSwitcher(
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
)
```

Penjelasan:
- `AnimatedSwitcher` berguna untuk mengganti tampilan lama dengan tampilan baru secara halus.
- Setiap perubahan bisa diberi `key` agar animasi bisa berjalan dengan benar.

### c. AnimationController dan RotationTransition
Contoh kode:

```dart
late final AnimationController _putar;

_putar = AnimationController(
  vsync: this,
  duration: const Duration(seconds: 2),
)..repeat();

RotationTransition(
  turns: _putar,
  child: Icon(
    Icons.settings,
    size: 72,
    color: warna.primary,
  ),
)
```

Penjelasan:
- `AnimationController` mengatur durasi dan kontrol animasi.
- `RotationTransition` memutar widget sesuai nilai controller.
- `repeat()` membuat animasi berputar terus-menerus sampai dihentikan.

### Kesimpulan Bagian C
Animasi membuat aplikasi tidak terlihat kaku. Widget seperti `AnimatedContainer`, `AnimatedSwitcher`, dan `RotationTransition` membantu menambah efek visual yang lebih hidup saat user berinteraksi.

---

## 5. Bagian D: Navigasi Tab Bawah
File yang dibahas: `BagianD_Navigasi Tab Bawah.dart`

Bagian ini berfokus pada struktur navigasi aplikasi yang memakai tab bawah. Tujuannya agar user bisa berpindah antar menu utama dengan cepat.

Contoh kode utama:

```dart
int _index = 0;

body: IndexedStack(
  index: _index,
  children: const [
    BerandaTab(),
    AnimasiTab(),
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
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'),
    NavigationDestination(icon: Icon(Icons.animation), label: 'Animasi'),
    NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Pengaturan'),
  ],
)
```

### Penjelasan kode
- `_index` menyimpan tab yang sedang aktif.
- `IndexedStack` menampilkan satu halaman sesuai dengan index yang aktif.
- `NavigationBar` berfungsi sebagai menu bawah aplikasi.
- `onDestinationSelected` dipanggil saat user memilih tab lain.

### Komponen lain yang ada
- `Drawer` untuk menu samping
- `AppBar` untuk judul halaman
- `ListTile` untuk setiap item menu

### Kesimpulan Bagian D
Bagian ini menjelaskan pola navigasi yang umum digunakan pada aplikasi mobile modern. Dengan navigasi tab bawah, user lebih mudah berpindah antar fitur utama.

---

## 6. Tugas: Aplikasi Galeri Wisata
File yang dibahas: `Tugas/tugas.dart`

Tugas pada pertemuan 6 menggabungkan semua materi sebelumnya menjadi satu aplikasi yang lebih lengkap. Aplikasi ini bernama Galeri Wisata.

Contoh kode utama:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Galeri Wisata',
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          home: const ShellPage(),
        );
      },
    );
  }
}
```

### Penjelasan
- Program menggunakan `ListenableBuilder` agar perubahan tema langsung diterapkan ke UI.
- `SharedPreferences` digunakan untuk menyimpan preferensi user seperti mode gelap dan warna tema.
- `ShellPage` adalah halaman induk yang berisi tiga tab utama: Beranda, Katalog Wisata, dan Pengaturan.

Contoh penyimpanan data:

```dart
Future<void> simpanTema() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('modeGelap', themeMode.value == ThemeMode.dark);
  await prefs.setInt('warnaTema', seedColor.value.value);
}
```

### Struktur data wisata
```dart
class ItemWisata {
  final String nama;
  final String lokasi;
  final String deskripsi;
  final IconData ikon;
}
```

### Fitur utama tugas ini
- halaman utama dengan data wisata
- daftar wisata yang bisa diklik
- halaman detail wisata
- menu drawer
- navigation bar
- tema gelap/terang yang tersimpan otomatis

### Kesimpulan Tugas
Tugas ini merupakan gabungan dari semua konsep pertemuan 6. Artinya, project ini tidak hanya menampilkan UI, tetapi juga menerapkan tema, navigasi, dan data yang lebih kompleks.

---

## 7. Latihan Mandiri
File yang dibahas: `Tugas/LatihanMandiri.dart`

Latihan mandiri ini memiliki pola yang mirip dengan tugas, tetapi lebih sederhana. Fokusnya tetap pada penerapan tema, navigasi, dan transisi halaman.

Contoh kode utama:

```dart
return MaterialApp(
  title: 'Latihan Praktikum 6',
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
          pageBuilder: (_, animation, secondaryAnimation) {
            return DetailPage(item: argumen);
          },
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      }
    }

    return null;
  },
);
```

### Penjelasan
- `initialRoute: '/'` menentukan halaman awal.
- `PageRouteBuilder` digunakan untuk membuat transisi custom.
- `FadeTransition` memberi efek muncul perlahan saat user membuka detail.
- `NavigationBar` juga dipakai untuk berpindah antar tab.

### Kesimpulan Latihan Mandiri
Latihan ini mencontohkan bagaimana konsep-konsep dasar pertemuan 6 dapat dikombinasikan dalam satu aplikasi kecil, tanpa terlalu rumit.

---

## 8. Kesimpulan Umum
Dari semua file di folder Praktikum dan Tugas, dapat disimpulkan bahwa pertemuan 6 membahas pengembangan aplikasi Flutter yang lebih interaktif dan terstruktur.

Konsep utama yang ada di setiap bagian adalah:

- Bagian A: tema gelap/terang
- Bagian B: named routes
- Bagian C: animasi
- Bagian D: tab bawah dan navigasi
- Tugas: integrasi semua konsep menjadi aplikasi nyata

Intinya, pertemuan 6 mengajarkan bagaimana membangun aplikasi mobile yang tidak hanya tampil berfungsi, tetapi juga lebih nyaman digunakan, lebih rapi, dan lebih menarik secara visual.

---

## 9. Catatan Akhir
Dokumentasi ini dibuat berdasarkan analisis kode yang ada di folder Praktikum dan Tugas pada pertemuan 6. Penjelasan di tiap bagian disusun sesuai dengan fungsi dan logika setiap file `.dart` yang ada.
