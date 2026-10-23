# Dokumentasi Pertemuan 5

## 1. Pendahuluan
Pada pertemuan 5, materi yang dibahas adalah penyimpanan data lokal dan manajemen database. Kode yang ada menggunakan `SharedPreferences` untuk menyimpan pengaturan sederhana dan SQLite untuk menyimpan catatan atau data aplikasi.

Folder yang dibahas:

- Praktikum: `BagianA_SharedPreferences.dart`, `BagianB_MenyiapkanSQLite.dart`, `BagianC_HalamanDaftarCatatan.dart`, `BagianD_FormTambahdanUbahCatatan.dart`
- Tugas: `Tugas.dart`, `LatihanMandiri.dart`

---

## 2. Bagian A: SharedPreferences
File: `BagianA_SharedPreferences.dart`

Bagian ini menjelaskan cara menyimpan data sederhana seperti nama user dan mode gelap pada aplikasi. Data disimpan ke perangkat lokal menggunakan `SharedPreferences`.

Contoh kode utama:

```dart
final prefs = await SharedPreferences.getInstance();

await prefs.setString('nama', _controller.text.trim());
await prefs.setBool('gelap', nilai);
```

Pada saat loading aplikasi:

```dart
_controller.text = prefs.getString('nama') ?? '';
_gelap = prefs.getBool('gelap') ?? false;
```

### Penjelasan
- `SharedPreferences` cocok untuk data kecil seperti pengaturan aplikasi.
- `setString` menyimpan nama user.
- `setBool` menyimpan status mode gelap.
- `ThemeData` diubah sesuai nilai `_gelap` untuk mengubah tampilan aplikasi.

### Kesimpulan
Bagian ini menunjukkan cara aplikasi dapat mengingat pengaturan user saat dibuka lagi.

---

## 3. Bagian B: Menyiapkan SQLite
File: `BagianB_MenyiapkanSQLite.dart`

Bagian ini mengenalkan SQLite sebagai database lokal yang digunakan untuk menyimpan data lebih kompleks daripada SharedPreferences.

Contoh kode utama:

```dart
_db = await openDatabase(
  lokasi,
  version: 1,
  onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE catatan('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'judul TEXT NOT NULL, '
      'isi TEXT NOT NULL)'
    );
  },
);
```

Fungsi insert dan query:

```dart
static Future<int> tambah(Catatan c) async {
  final db = await database;
  return db.insert('catatan', c.toMap());
}

static Future<List<Catatan>> semua() async {
  final db = await database;
  final rows = await db.query('catatan', orderBy: 'id DESC');
  return rows.map(Catatan.fromMap).toList();
}
```

### Penjelasan
- `openDatabase` membuat atau membuka database local.
- `CREATE TABLE` mendefinisikan struktur data tabel.
- `toMap()` dan `fromMap()` memindahkan data objek ke format database.

### Kesimpulan
Bagian ini membuktikan bahwa aplikasi bisa menyimpan data yang lebih besar dan lebih terstruktur dengan SQLite.

---

## 4. Bagian C: Halaman Daftar Catatan
File: `BagianC_HalamanDaftarCatatan.dart`

Bagian ini menampilkan catatan yang sudah tersimpan dalam database. User dapat melihat daftar catatan, menambah, dan menghapusnya.

Contoh fetch data:

```dart
late Future<List<Catatan>> _future;

void _muat() {
  _future = DbHelper.semua();
}
```

Pada tampilan:

```dart
FutureBuilder<List<Catatan>>(
  future: _future,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = snapshot.data ?? [];
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final catatan = data[index];
        return ListTile(
          title: Text(catatan.judul),
          subtitle: Text(catatan.isi),
        );
      },
    );
  },
)
```

### Penjelasan
- `FutureBuilder` dipakai untuk menampilkan isi database secara dinamis.
- `FloatingActionButton` digunakan untuk menambah catatan baru.
- `IconButton` delete dipakai untuk menghapus catatan tertentu.

### Kesimpulan
Bagian ini mengajarkan prinsip CRUD (Create, Read, Update, Delete) dasar pada data lokal.

---

## 5. Bagian D: Form Tambah dan Ubah Catatan
File: `BagianD_FormTambahdanUbahCatatan.dart`

Bagian ini mengembangkan fitur sebelumnya dengan form tambah dan edit. User bisa membuat catatan baru atau memperbarui catatan lama.

Contoh pembuatan form:

```dart
await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => FormCatatanPage(catatan: catatan),
  ),
);
```

Pada form page:

```dart
final _formKey = GlobalKey<FormState>();
late final TextEditingController _judul;
late final TextEditingController _isi;
```

### Penjelasan
- `FormCatatanPage` dipakai untuk form tambah atau edit.
- `catatan` optional berarti form bisa dipakai untuk edit atau tambah data baru.
- `DbHelper.ubah()` dipakai saat data lama diperbarui.
- `showDialog` digunakan untuk konfirmasi hapus sebelum data benar-benar dihapus.

### Kesimpulan
Bagian ini menutup siklus CRUD dengan penambahan fitur edit dan delete yang lebih aman.

---

## 6. Tugas: Pencatat Pengeluaran
File: `Tugas.dart`

Tugas pertemuan 5 adalah aplikasi pencatat pengeluaran. Aplikasi ini menggabungkan tiga konsep utama: SQLite, SharedPreferences, dan tema gelap/terang.

### Model data
```dart
class Pengeluaran {
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;
}
```

### Database SQLite
```dart
CREATE TABLE pengeluaran(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  jumlah INTEGER NOT NULL,
  kategori TEXT NOT NULL,
  tanggal TEXT NOT NULL
)
```

### Tema gelap/terang
```dart
ThemeMode _themeMode = ThemeMode.light;

Future<void> _ubahTema(bool gelap) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('modeGelap', gelap);
  setState(() {
    _themeMode = gelap ? ThemeMode.dark : ThemeMode.light;
  });
}
```

### Penjelasan
- `DbHelper` menampung operasi CRUD untuk pengeluaran.
- `total()` menghitung total semua pengeluaran.
- `SharedPreferences` menyimpan status tema user.
- Aplikasi menampilkan jumlah pengeluaran dan daftar aktivitas.

### Kesimpulan
Tugas ini merupakan implementasi nyata dari penyimpanan data lokal dengan fitur tambahan seperti tema dan total data.

---

## 7. Latihan Mandiri
File: `LatihanMandiri.dart`

Latihan mandiri ini memperluas aplikasi catatan dengan fitur pencarian dan pengaturan urutan tampilan. Selain itu, data catatan juga memiliki kolom `dibuat` untuk menampilkan tanggal pembuatan.

Contoh query pencarian:

```dart
where: kata.trim().isEmpty ? null : 'judul LIKE ?',
whereArgs: kata.trim().isEmpty ? null : ['%${kata.trim()}%'],
orderBy: terbaru ? 'id DESC' : 'id ASC',
```

### Penjelasan
- `TextField` digunakan untuk mencari catatan berdasarkan judul.
- `PopupMenuButton` memberikan pilihan urutan catatan terbaru atau lama.
- `SharedPreferences` digunakan untuk menyimpan preferensi urutan catatan.

### Kesimpulan
Latihan mandiri ini mengajarkan bagaimana aplikasi lokal dapat ditingkatkan dengan fitur pencarian, pengurutan, dan preferensi pengguna.

---

## 8. Kesimpulan Umum
Pertemuan 5 membahas pentingnya penyimpanan data lokal dalam aplikasi mobile. `SharedPreferences` cocok untuk penyimpanan kecil dan sederhana, sedangkan SQLite sangat cocok untuk data yang lebih besar dan lebih kompleks. Kombinasi keduanya memungkinkan aplikasi menjadi lebih personal, terstruktur, dan mudah digunakan.
