# Dokumentasi Pertemuan 4

## 1. Pendahuluan
Pada pertemuan 4, materi yang dibahas adalah async, Future, dan penggunaan `FutureBuilder` untuk mengambil data dari API. Kode yang ada menekankan bagaimana Flutter menangani data yang datang secara asynchronous tanpa membuat UI freeze.

Folder yang dibahas:

- Praktikum: `BagianA_MengenalFuturedanFutureBuilder.dart`, `BagianC_ModeldanFungsiPengambilData.dart`, `BagianD_MenampilkanDatadenganFutureBuilder.dart`, `BagianE_HalamanDetailPengguna.dart`
- Tugas: `tugas.dart`, `LatihanMandiri.dart`

---

## 2. Bagian A: Mengenal Future dan FutureBuilder
File: `BagianA_MengenalFuturedanFutureBuilder.dart`

Bagian ini memperkenalkan konsep asynchronous. Fungsi `ambilSalam()` menunggu selama 2 detik sebelum mengembalikan string.

Contoh kode utama:

```dart
Future<String> ambilSalam() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Halo dari masa depan!';
}
```

Pada tampilan:

```dart
FutureBuilder<String>(
  future: _future,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    return Text(snapshot.data!);
  },
)
```

### Penjelasan
- `Future` adalah objek yang akan menghasilkan data nanti.
- `FutureBuilder` berguna untuk membangun UI berdasarkan status future.
- `ConnectionState.waiting` menampilkan loading indicator.
- `snapshot.data` menampilkan hasil data yang sudah selesai diproses.

### Kesimpulan
Bagian ini adalah dasar pengelolaan data async di Flutter dan penting untuk fetching data dari server atau database.

---

## 3. Bagian C: Model dan Fungsi Pengambil Data
File: `BagianC_ModeldanFungsiPengambilData.dart`

Bagian ini fokus pada pembuatan model data dari JSON. Kode memanggil API dummy `https://jsonplaceholder.typicode.com/users` dan mengubah data JSON menjadi objek `Pengguna`.

Contoh model:

```dart
class Pengguna {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  const Pengguna({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
    );
  }
}
```

Fungsi API:

```dart
Future<List<Pengguna>> ambilPengguna() async {
  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Gagal memuat data');
  }

  final List<dynamic> data = jsonDecode(response.body);

  return data.map((item) => Pengguna.fromJson(item as Map<String, dynamic>)).toList();
}
```

### Penjelasan
- `fromJson` mengubah data JSON menjadi objek Dart.
- `http.get` mengambil data dari internet.
- `jsonDecode` mengubah body JSON menjadi list map.
- `throw Exception` menangani kegagalan request.

### Kesimpulan
Bagian ini memperlihatkan cara memisahkan data model dan fungsi pengambil data agar struktur kode lebih rapi.

---

## 4. Bagian D: Menampilkan Data dengan FutureBuilder
File: `BagianD_MenampilkanDatadenganFutureBuilder.dart`

Bagian ini menampilkan daftar pengguna dari API ke `ListView`. Saat data sedang diambil, tampilkan loading. Jika gagal, tampilkan error. Jika sukses, tampilkan user list.

Contoh utama:

```dart
FutureBuilder<List<Pengguna>>(
  future: _future,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Terjadi kesalahan:\n${snapshot.error}'));
    }

    final data = snapshot.data!;
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, i) {
        final pengguna = data[i];
        return ListTile(
          leading: CircleAvatar(child: Text(pengguna.name[0])),
          title: Text(pengguna.name),
          subtitle: Text(pengguna.email),
        );
      },
    );
  },
)
```

### Penjelasan
- `FutureBuilder` sangat cocok untuk menampilkan data dari internet.
- `ListView.builder` digunakan agar data yang panjang bisa ditampilkan dengan efisien.
- `Navigator.push` dipakai saat item ditekan untuk membuka halaman detail.

### Kesimpulan
Bagian ini menjelaskan bagaimana aplikasi bisa menampilkan data online secara dinamis dan rapi.

---

## 5. Bagian E: Halaman Detail Pengguna
File: `BagianE_HalamanDetailPengguna.dart`

Bagian ini melanjutkan daftar pengguna menjadi halaman detail. Setelah user memilih item, akan dibuka halaman baru yang menampilkan lebih banyak informasi seperti email, telepon, dan website.

Contoh navigasi:

```dart
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetailPenggunaPage(pengguna: item),
    ),
  );
},
```

Pada halaman detail:

```dart
body: ListView(
  children: [
    ListTile(
      leading: const Icon(Icons.email),
      title: const Text('Email'),
      subtitle: Text(pengguna.email),
    ),
    ListTile(
      leading: const Icon(Icons.phone),
      title: const Text('Telepon'),
      subtitle: Text(pengguna.phone),
    ),
  ],
);
```

### Penjelasan
- `DetailPenggunaPage` menerima `Pengguna` sebagai parameter.
- `ListTile` sering dipakai untuk menampilkan informasi detail.
- `Navigator` kembali digunakan saat user menutup halaman.

### Kesimpulan
Bagian ini menunjukkan bahwa aplikasi data API biasanya terdiri dari daftar dan detail yang saling terhubung.

---

## 6. Tugas: Daftar Postingan
File: `tugas.dart`

Tugas ini menggunakan API yang lebih kompleks. Aplikasi menampilkan daftar postingan, lalu saat salah satu postingan dipilih, aplikasi menampilkan detail postingan dan daftar komentar terkait.

### Struktur utama
- `PostPage` untuk menampilkan daftar postingan.
- `DetailPostPage` untuk menampilkan detail postingan.
- `ApiService` digunakan untuk mengambil data dari API.

Contoh fetch data:

```dart
late Future<List<Post>> futurePostingan;

@override
void initState() {
  super.initState();
  futurePostingan = ApiService.ambilPostingan();
}
```

### Penjelasan
- `FutureBuilder` digunakan pada halaman daftar dan detail komentar.
- `ListTile` menampilkan judul dan isi postingan secara ringkas.
- `DetailPostPage` memanggil `ApiService.ambilKomentar(widget.post.id)` untuk mengambil komentar.

### Kesimpulan
Tugas ini menunjukkan integrasi data API, list, detail, dan nested future secara bersamaan.

---

## 7. Latihan Mandiri
File: `LatihanMandiri.dart`

Latihan mandiri ini merupakan variasi dari daftar pengguna dengan fitur tambahan:

- menampilkan username dan kota
- fitur muat ulang dengan `RefreshIndicator`
- `FutureBuilder` yang menampilkan judul jumlah pengguna di AppBar
- halaman detail tambahan yang menampilkan data lengkap

Contoh fitur refresh:

```dart
Future<void> _muatUlang() async {
  final futureBaru = ambilPengguna();

  setState(() {
    _future = futureBaru;
  });

  await futureBaru;
}
```

### Penjelasan
- `RefreshIndicator` memberi pengalaman pull-to-refresh di layar.
- `AppBar` menampilkan jumlah pengguna jika data sudah berhasil diambil.
- `author` model juga mengambil field `address.city` untuk menampilkan kota.

### Kesimpulan
Latihan mandiri ini mengajarkan pengelolaan data dan UX yang lebih modern pada aplikasi berbasis API.

---

## 8. Kesimpulan Umum
Pertemuan 4 mengajarkan bahwa Flutter dapat berinteraksi dengan data eksternal secara asynchronous. Konsep utama adalah Future, FutureBuilder, model dari JSON, dan navigasi detail. Materi ini sangat penting untuk membangun aplikasi yang mengambil data dari server atau API.
