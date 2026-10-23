# Dokumentasi Pertemuan 1

## 1. Pendahuluan
Pada pertemuan 1, materi yang dibahas adalah dasar-dasar Flutter. Fokus utama dari kode yang ada adalah bagaimana membangun aplikasi sederhana, memahami widget dasar, dan mengenal konsep stateful widget untuk interaksi.

Folder yang dibahas pada pertemuan ini adalah:

- Praktikum: `BagianD_HelloFlutter.dart`, `BagianE_WidgetLayoutDasar.dart`, `BagianF_StatefulWidgetCounter.dart`
- Tugas: `KartuPerkenalan.dart`, `lLatihanMandiriModul1.dart`

---

## 2. Bagian D: Hello Flutter
File: `BagianD_HelloFlutter.dart`

Kode ini adalah contoh paling sederhana dalam Flutter. Aplikasi menampilkan `MaterialApp` dengan `Scaffold`, `AppBar`, dan `Center`, lalu menampilkan teks "Halo, nama saya ...".

Contoh kode utama:

```dart
return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Praktikum 1',
  home: Scaffold(
    appBar: AppBar(
      title: const Text('Hello Flutter'),
    ),
    body: const Center(
      child: Text(
        'Halo, nama saya Fadhil Afiq Badruzzaman!',
        style: TextStyle(fontSize: 24),
      ),
    ),
  ),
);
```

### Penjelasan
- `MaterialApp` adalah root aplikasi Flutter.
- `Scaffold` menyediakan kerangka tampilan umum seperti AppBar dan body.
- `Center` membuat semua widget di tengah layar.
- `Text` dipakai untuk menampilkan tulisan.

### Kesimpulan
Bagian ini memperkenalkan struktur dasar aplikasi Flutter dan bagaimana widget ditampung di dalam widget tree.

---

## 3. Bagian E: Widget Layout Dasar
File: `BagianE_WidgetLayoutDasar.dart`

Bagian ini menjelaskan cara menyusun widget secara vertikal dengan `Column` serta menampilkan ikon dan teks. Tampilan dibuat lebih rapi dengan `SizedBox` untuk memberi jarak.

Contoh kode utama:

```dart
body: const Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.flutter_dash, size: 80, color: Colors.blue),
      SizedBox(height: 16),
      Text('Halo, nama saya Fadhil Afiq Badruzzaman!',
          style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
      SizedBox(height: 8),
      Text('NIM: 2010010476', style: TextStyle(fontSize: 18)),
    ],
  ),
);
```

### Penjelasan
- `Column` digunakan untuk menata elemen dari atas ke bawah.
- `Icon` menampilkan ikon.
- `SizedBox` memberi ruang antar komponen.
- `TextAlign.center` digunakan agar teks rata tengah.

### Kesimpulan
Bagian ini mengenalkan penggunaan widget layout sederhana untuk membuat tampilan profil atau halaman informasi.

---

## 4. Bagian F: StatefulWidget Counter
File: `BagianF_StatefulWidgetCounter.dart`

Bagian ini menunjukkan konsep stateful widget, yaitu widget yang bisa berubah saat user berinteraksi. Di sini, nilai counter bertambah setiap kali tombol ditekan.

Contoh kode utama:

```dart
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Saya'),
      ),
      body: Center(
        child: Text(
          '$_count',
          style: const TextStyle(fontSize: 48),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _count++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Penjelasan
- `StatefulWidget` digunakan ketika tampilan harus berubah secara dinamis.
- `_count` sebagai state yang disimpan.
- `setState` memicu rebuild widget agar tampilan mengikuti perubahan data.
- `FloatingActionButton` dipakai untuk aksi tambah nilai.

### Kesimpulan
Bagian ini adalah dasar dari interaksi di Flutter. Dengan `StatefulWidget`, aplikasi bisa merespons aksi pengguna seperti tap, input, dan perubahan kondisi.

---

## 5. Tugas: Kartu Perkenalan
File: `TugasKartuPerkenalan/KartuPerkenalan.dart`

Tugas ini dibuat untuk menampilkan profil diri dalam bentuk kartu sederhana. Aplikasi menampilkan ikon profil, nama, NIM, jurusan, dan hobi.

Contoh kode utama:

```dart
body: const Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.account_circle, size: 120, color: Colors.pinkAccent),
      SizedBox(height: 20),
      Text('Fadhil Afiq Badruzzaman', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Text('NIM: 2024080119', style: TextStyle(fontSize: 18)),
      SizedBox(height: 10),
      Text('Jurusan: Teknik Informatika', style: TextStyle(fontSize: 18)),
      SizedBox(height: 10),
      Icon(Icons.music_note, size: 100, color: Colors.pinkAccent),
      SizedBox(height: 5),
      Text('Hobi: MUSIK', style: TextStyle(fontSize: 18)),
    ],
  ),
);
```

### Penjelasan
- `Column` membuat tata letak vertikal.
- `Icon` digunakan untuk memperindah tampilan.
- `Text` menampilkan data diri.
- `AppBar` dan warna pink memberi nuansa kartu profil yang menarik.

### Kesimpulan
Tugas ini menunjukkan cara memanfaatkan widget dasar untuk membuat tampilan data diri yang rapi dan informatif.

---

## 6. Latihan Mandiri
File: `lLatihanMandiriModul1.dart`

Latihan mandiri ini mirip dengan counter, tetapi ditambahkan tombol tambah, kurang, dan reset. Ini membantu memahami cara kerja stateful widget yang lebih kompleks.

Contoh kode penting:

```dart
void tambah() {
  setState(() {
    _count++;
  });
}

void kurang() {
  if (_count > 0) {
    setState(() {
      _count--;
    });
  }
}

void reset() {
  setState(() {
    _count = 0;
  });
}
```

### Penjelasan
- `tambah` menambah nilai counter.
- `kurang` mengurangi nilai counter hanya jika lebih dari 0.
- `reset` mengembalikan nilai ke 0.
- Ketiga fungsi ini dipanggil dari `FloatingActionButton`.

### Kesimpulan
Latihan mandiri ini mengajarkan bahwa state dapat dimanipulasi melalui beberapa fungsi sekaligus, sehingga aplikasi menjadi lebih interaktif.

---

## 7. Kesimpulan Umum
Pertemuan 1 membahas dasar-dasar Flutter, mulai dari struktur aplikasi, widget layout, hingga stateful widget untuk interaksi. Materi ini menjadi pondasi untuk pertemuan berikutnya, karena semua fitur yang lebih kompleks di Flutter tetap dibangun dari prinsip dasar ini.
