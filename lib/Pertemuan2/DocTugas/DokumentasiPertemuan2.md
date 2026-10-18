# Dokumentasi Pertemuan 2

## 1. Pendahuluan
Pada pertemuan 2, materi yang dibahas adalah pengenalan layout, daftar data, dan navigasi antar halaman. Kode yang tersedia menunjukkan bagaimana membuat tampilan profil, menampilkan list data, serta membuka halaman detail dari item yang dipilih.

Folder yang dibahas:

- Praktikum: `BagianA_LayoutKartuProfil.dart`, `BagianB_ModelDataListView.dart`, `BagianC_NavigasiHalamanDetail.dart`
- Tugas: `TugasDaftarKontak.dart`, `LatihanMandirimodul2.dart`

---

## 2. Bagian A: Layout Kartu Profil
File: `BagianA_LayoutKartuProfil.dart`

Bagian ini membahas cara membuat layout profil berbentuk kartu menggunakan `Container`, `Row`, dan `CircleAvatar`.

Contoh kode utama:

```dart
return Scaffold(
  appBar: AppBar(
    title: const Text('Profil'),
  ),
  body: Padding(
    padding: const EdgeInsets.all(16),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 32,
            child: Icon(Icons.person, size: 32),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fadhil Afiq Badruzzaman', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('2010010476'),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);
```

### Penjelasan
- `Container` digunakan untuk membungkus elemen dengan padding dan dekorasi.
- `Row` menata avatar dan teks secara horizontal.
- `Column` menata teks sesuai posisi.
- `CircleAvatar` digunakan untuk representasi gambar profil.

### Kesimpulan
Bagian ini mengajarkan cara menyusun komponen UI agar tampilan profil terlihat rapi dan terstruktur.

---

## 3. Bagian B: Model Data dan ListView
File: `BagianB_ModelDataListView.dart`

Bagian ini menjelaskan cara menampilkan data dalam bentuk list. Data dibuat dalam bentuk model class dan ditampilkan dengan `ListView.builder`.

Contoh kode utama:

```dart
class Makanan {
  final String nama;
  final int harga;

  const Makanan(this.nama, this.harga);
}

const daftarMenu = [
  Makanan('Nasi Goreng', 15000),
  Makanan('Mie Ayam', 12000),
  Makanan('Es Teh', 4000),
  Makanan('Ayam Bakar', 20000),
];
```

Pada `build`:

```dart
body: ListView.builder(
  itemCount: daftarMenu.length,
  itemBuilder: (context, index) {
    final item = daftarMenu[index];

    return Card(
      child: ListTile(
        leading: const Icon(Icons.restaurant),
        title: Text(item.nama),
        subtitle: Text('Rp ${item.harga}'),
      ),
    );
  },
);
```

### Penjelasan
- `class Makanan` adalah model data.
- `ListView.builder` digunakan untuk menampilkan data secara dinamis.
- `itemBuilder` akan membuat widget sesuai jumlah item.
- `ListTile` membuat tampilan item list yang rapi.

### Kesimpulan
Bagian ini menunjukkan bahwa data bisa diolah dari model lalu ditampilkan ke UI secara efisien.

---

## 4. Bagian C: Navigasi Halaman Detail
File: `BagianC_NavigasiHalamanDetail.dart`

Bagian ini menambahkan fitur navigasi dari daftar item ke halaman detail. Saat item dipilih, aplikasi akan membuka halaman baru yang menampilkan informasi lebih lengkap.

Contoh kode utama:

```dart
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DetailPage(makanan: item),
    ),
  );
},
```

### Penjelasan
- `Navigator.push` berguna untuk membuka halaman baru.
- `MaterialPageRoute` mendefinisikan halaman yang akan dibuka.
- `DetailPage` menerima data `makanan` dari item yang dipilih.

Di halaman detail:

```dart
class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({
    super.key,
    required this.makanan,
  });
}
```

### Kesimpulan
Bagian ini memperkenalkan navigasi antar halaman dan bagaimana data dikirim antara page satu ke page lainnya.

---

## 5. Tugas: Daftar Kontak
File: `TugasDaftarKontak/TugasDaftarKontak.dart`

Tugas ini menggabungkan konsep list data dan halaman detail menjadi aplikasi daftar kontak. Setiap kontak memiliki nama, telepon, dan email.

Contoh kode utama:

```dart
class Kontak {
  final String nama;
  final String telepon;
  final String email;

  const Kontak({
    required this.nama,
    required this.telepon,
    required this.email,
  });
}
```

Pada list:

```dart
ListView.builder(
  itemCount: daftarKontak.length,
  itemBuilder: (context, index) {
    final kontak = daftarKontak[index];

    return ListTile(
      leading: CircleAvatar(
        child: Text(kontak.nama[0]),
      ),
      title: Text(kontak.nama),
      subtitle: Text(kontak.telepon),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailKontakPage(kontak: kontak),
          ),
        );
      },
    );
  },
);
```

### Penjelasan
- `CircleAvatar` digunakan untuk menampilkan huruf awal nama.
- `DetailKontakPage` menampilkan informasi lengkap kontak.
- `ElevatedButton.icon` pada halaman detail digunakan untuk kembali ke halaman sebelumnya.

### Kesimpulan
Tugas ini mengajarkan cara membuat aplikasi daftar kontak yang rapi dan mudah dibaca dengan navigasi detail.

---

## 6. Latihan Mandiri
File: `LatihanMandirimodul2.dart`

Latihan mandiri ini memperluas daftar menu dengan fitur deskripsi makanan. Pada halaman detail, ditampilkan harga dan deskripsi.

Contoh kode penting:

```dart
class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;

  const Makanan(this.nama, this.harga, this.deskripsi);
}
```

Pembuatan format rupiah:

```dart
String formatRupiah(int harga) {
  return harga.toString().replaceAllMapped(
    RegExp(r'(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
}
```

### Penjelasan
- `deskripsi` ditambahkan agar detail item lebih informatif.
- `formatRupiah` digunakan untuk memformat angka menjadi format rupiah.
- `Container` dan `BoxDecoration` dibuat agar kartu menu terlihat lebih menarik.

### Kesimpulan
Latihan mandiri ini mengajarkan bagaimana data kompleks bisa ditampilkan ke tampilan yang lebih kaya, tidak hanya nama dan harga, tetapi juga deskripsi.

---

## 7. Kesimpulan Umum
Pertemuan 2 membahas pentingnya layout yang rapi, pengelolaan data model, dan navigasi antar halaman. Dari sini, mahasiswa mulai belajar bagaimana aplikasi dapat menampilkan data secara dinamis dan berpindah halaman dengan data yang relevan.
