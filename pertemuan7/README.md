# TabungKu

Deskripsi: TabungKu adalah aplikasi pencatatan keuangan sederhana berbasis SQLite untuk membantu pengguna mencatat pemasukan, pengeluaran, serta melihat ringkasan dan laporan per kategori dalam 7 hari terakhir.

## Daftar fitur
- F1: menambah kategori dan kegiatan
- F2: menampilkan daftar kegiatan
- F3: menghitung ringkasan saldo, pemasukan, dan pengeluaran
- F4: melihat laporan per kategori
- F5: melihat laporan 7 hari terakhir
- F6: mengubah dan menghapus kegiatan
- F7: pencarian dan filter kegiatan
- F8: ekspor laporan ke Clipboard
- F9: validasi form dan kondisi kosong

## Cara menjalankan
1. Pastikan Flutter sudah terpasang.
2. Masuk ke folder proyek.
3. Jalankan `flutter pub get`.
4. Jalankan aplikasi dengan `flutter run`.

## Struktur folder
- lib/main.dart
- lib/data/database_helper.dart
- lib/models/kegiatan.dart
- lib/models/summary.dart
- lib/screens/home_screen.dart
- lib/screens/kegiatan_screen.dart
- lib/screens/laporan_screen.dart
- lib/screens/form_kegiatan_screen.dart
- test/database_test.dart

## Fitur lanjutan yang dipilih
- Pencarian dan filter kegiatan dengan query `LIKE` dan `WHERE`
- Ekspor laporan ke Clipboard

## Asumsi
- Aplikasi dipersiapkan untuk platform Android saja.
- Web tidak digunakan karena `sqflite` tidak mendukung web.
- Label nama/NIM tetap placeholder: [isi nama / NIM].

## Informasi pengguna
- Nama: [isi nama / NIM]
