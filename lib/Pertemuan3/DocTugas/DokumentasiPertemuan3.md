# Dokumentasi Pertemuan 3

## 1. Pendahuluan
Pada pertemuan 3, materi yang dibahas adalah input user, validasi form, dan pengelolaan state dengan Provider. Isi kode pada praktikum dan tugas menunjukkan bahwa aplikasi mobile tidak hanya menampilkan data, tetapi juga menerima input dan mengolahnya.

Folder yang dibahas:

- Praktikum: `BagianA_InputDasar.dart`, `BagianB_FormdenganValidasi.dart`, `BagianD_DaftarTugasdenganProvider.dart`
- Tugas: `TugasAplikasiDaftarBelanja.dart`, `LatihanMandiri.dart`

---

## 2. Bagian A: Input Dasar
File: `BagianA_InputDasar.dart`

Bagian ini memperkenalkan input sederhana menggunakan `TextField`. User dapat mengetik nama dan menekan tombol untuk menampilkan salam.

Contoh kode utama:

```dart
final _controller = TextEditingController();
String _salam = '';

TextField(
  controller: _controller,
  decoration: const InputDecoration(
    labelText: 'Nama',
    border: OutlineInputBorder(),
  ),
),
```

Pada tombol:

```dart
onPressed: () {
  setState(() {
    _salam = 'Halo, ${_controller.text}!';
  });
},
```

### Penjelasan
- `TextEditingController` digunakan untuk menangkap nilai dari input.
- `TextField` membuat kolom input teks.
- `setState` dipakai agar tampilan berubah ketika tombol ditekan.

### Kesimpulan
Bagian ini adalah petunjuk awal bahwa Flutter bisa menangkap input pengguna dan menampilkan hasilnya secara realtime.

---

## 3. Bagian B: Form dengan Validasi
File: `BagianB_FormdenganValidasi.dart`

Bagian ini mengajarkan pembuatan form dengan validasi. Aplikasi mengecek apakah nama diisi dan email valid sebelum data dikirim.

Contoh kode:

```dart
final _formKey = GlobalKey<FormState>();

TextFormField(
  controller: _nama,
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }
    return null;
  },
),
```

Pada email:

```dart
validator: (value) {
  if (value == null || !value.contains('@')) {
    return 'Email tidak valid';
  }
  return null;
},
```

### Penjelasan
- `Form` digunakan untuk mengelola banyak input sekaligus.
- `GlobalKey<FormState>` membantu validasi form.
- `validator` berguna untuk mengecek apakah form sudah benar sebelum data dikirim.
- `CheckboxListTile` mengontrol persetujuan user.

### Kesimpulan
Bagian ini menekankan pentingnya validasi agar data yang masuk aman dan sesuai format.

---

## 4. Bagian D: Daftar Tugas dengan Provider
File: `BagianD_DaftarTugasdenganProvider.dart`

Bagian ini adalah contoh pengelolaan state yang lebih terstruktur dengan Provider. Aplikasi daftar tugas memakai model `TugasModel` yang mengelola data tugas.

Contoh model:

```dart
class TugasModel extends ChangeNotifier {
  final List<Tugas> _items = [];

  List<Tugas> get items => List.unmodifiable(_items);

  void tambah(String judul) {
    _items.add(Tugas(judul));
    notifyListeners();
  }

  void toggle(int index) {
    _items[index].selesai = !_items[index].selesai;
    notifyListeners();
  }
}
```

### Penjelasan
- `ChangeNotifier` digunakan agar state bisa diikuti oleh widget lain.
- `notifyListeners()` memberi sinyal bahwa data telah berubah.
- `context.watch<TugasModel>()` digunakan untuk mengambil data yang terbaru.
- `Checkbox` untuk menandai tugas selesai.

### Kesimpulan
Bagian ini menunjukkan konsep state management yang lebih rapi dibanding state lokal sederhana. Provider sangat cocok untuk aplikasi yang data dan tampilannya berubah banyak.

---

## 5. Tugas: Aplikasi Daftar Belanja
File: `TugasAplikasiDaftarBelanja/TugasAplikasiDaftarBelanja.dart`

Tugas ini memadukan form input, penyimpanan state, dan checkbox untuk menandai barang yang sudah dibeli. Aplikasi dibuat agar user dapat menambah barang belanjaan dan menandai status belanja.

Contoh model:

```dart
class Barang {
  String nama;
  int jumlah;
  String kategori;
  bool sudahDibeli;
}
```

Pada model state:

```dart
class BelanjaModel extends ChangeNotifier {
  final List<Barang> _items = [];

  void tambah({
    required String nama,
    required int jumlah,
    required String kategori,
  }) {
    _items.add(Barang(
      nama: nama,
      jumlah: jumlah,
      kategori: kategori,
    ));
    notifyListeners();
  }
}
```

### Penjelasan
- Aplikasi bisa menambahkan barang baru melalui form.
- Checkbox menandai barang sudah dibeli atau belum.
- `jumlah` dan `kategori` membuat data lebih detail.
- `AppBar` menampilkan jumlah barang yang belum dibeli.

### Kesimpulan
Tugas ini menunjukkan bagaimana model data dan Provider dipakai untuk membuat aplikasi sederhana yang fungsional seperti daftar belanja.

---

## 6. Latihan Mandiri
File: `LatihanMandiri.dart`

Latihan mandiri ini memiliki fitur yang lebih lengkap daripada contoh dasar. Selain menambah tugas dan memberi tanda selesai, terdapat fitur hapus tugas selesai dan validasi judul minimal 3 karakter.

Contoh validasi:

```dart
validator: (value) {
  final judul = value?.trim() ?? '';

  if (judul.isEmpty) {
    return 'Judul tugas wajib diisi';
  }

  if (judul.length < 3) {
    return 'Judul minimal 3 karakter';
  }

  return null;
},
```

Fitur tambahan:

```dart
void hapusSelesai() {
  _items.removeWhere((tugas) => tugas.selesai);
  notifyListeners();
}
```

### Penjelasan
- Validasi membuat input lebih aman.
- `hapusSelesai` memudahkan pengguna membersihkan tugas yang sudah selesai.
- `Navigator.pop(context, true)` memberi feedback bahwa penambahan berhasil.

### Kesimpulan
Latihan mandiri ini menambah pengalaman tentang implementasi aplikasi manajemen tugas yang lebih realistis.

---

## 7. Kesimpulan Umum
Pada pertemuan 3, mahasiswa mulai belajar mengolah data dari user dan memanage state dengan struktur yang lebih baik. Ada tiga konsep penting yang muncul, yaitu input form, validasi, dan Provider. Konsep-konsep ini menjadi dasar untuk membangun aplikasi yang lebih kompleks pada pertemuan berikutnya.
