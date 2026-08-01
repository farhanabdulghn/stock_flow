# Stock Flow

<p align="center">
  Aplikasi mobile pencatatan stok gudang berbasis histori transaksi, dibangun menggunakan Flutter, Riverpod, dan Hive CE.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile%20App-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.12%2B-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/State-Riverpod-6C5CE7" alt="Riverpod">
  <img src="https://img.shields.io/badge/Storage-Hive%20CE-F7B731" alt="Hive CE">
</p>

## Tentang Aplikasi

**Stock Flow** adalah aplikasi mobile untuk membantu perusahaan mencatat dan memantau persediaan barang pada satu gudang utama.

Aplikasi dirancang untuk mengurangi selisih stok akibat pencatatan yang tidak konsisten. Stok tidak disimpan sebagai nilai yang berdiri sendiri, tetapi dihitung berdasarkan seluruh histori transaksi:

```text
Stok Saat Ini = Total Barang Masuk - Total Barang Keluar
```

Setiap transaksi menyimpan referensi barang menggunakan **SKU**, sehingga perhitungan stok tetap konsisten meskipun nama barang berubah.

## Fitur Utama

### 1. Autentikasi dan Hak Akses

Aplikasi menyediakan login sederhana dengan dua jenis pengguna:

| Role | Hak Akses |
|---|---|
| **Admin** | Mengakses master barang, transaksi barang masuk, dan transaksi barang keluar |
| **Operator** | Mengakses transaksi barang masuk dan transaksi barang keluar |

Session pengguna disimpan secara lokal sehingga pengguna yang sudah login dapat langsung diarahkan ke halaman utama saat aplikasi dibuka kembali.

### 2. Master Barang

Admin dapat mengelola data barang dengan informasi:

- SKU
- Nama barang
- Kategori
- Satuan
- Stok saat ini

Kemampuan yang tersedia:

- Menambah barang
- Mengubah barang
- Menghapus barang
- Mencari berdasarkan SKU, nama, kategori, atau satuan
- Validasi field wajib
- Validasi SKU unik tanpa membedakan huruf besar dan kecil
- Normalisasi SKU menjadi huruf kapital
- Mencegah penghapusan barang yang sudah memiliki histori transaksi
- Menampilkan indikator stok kosong

### 3. Transaksi Barang Masuk

Pengguna dapat mencatat barang yang masuk ke gudang dengan data:

- Tanggal
- Barang
- Jumlah
- Keterangan opsional

Kemampuan tambahan:

- Pemilihan barang dari master barang
- Penyimpanan SKU sebagai referensi transaksi
- Validasi jumlah harus lebih dari nol
- Pencarian histori transaksi
- Ringkasan jumlah transaksi dan total barang masuk
- Detail transaksi melalui bottom sheet
- Pull-to-refresh
- Konfirmasi untuk tindakan destruktif

### 4. Transaksi Barang Keluar

Pengguna dapat mencatat barang yang keluar dari gudang dengan data:

- Tanggal
- Barang
- Jumlah
- Tujuan

Kemampuan tambahan:

- Pemilihan barang dari master barang
- Validasi tujuan wajib diisi
- Validasi jumlah harus lebih dari nol
- Pemeriksaan stok sebelum transaksi disimpan
- Penolakan transaksi apabila jumlah melebihi stok tersedia
- Pencarian histori transaksi
- Ringkasan jumlah transaksi dan total barang keluar
- Detail transaksi melalui bottom sheet
- Pull-to-refresh
- Konfirmasi untuk tindakan destruktif

### 5. Perhitungan Stok Otomatis

Stok dihitung secara reaktif menggunakan Riverpod.

Untuk setiap SKU, aplikasi melakukan agregasi:

```text
totalIn  = jumlah seluruh transaksi masuk dengan SKU yang sama
totalOut = jumlah seluruh transaksi keluar dengan SKU yang sama
quantity = totalIn - totalOut
```

Perubahan transaksi masuk atau keluar akan langsung memengaruhi stok yang tampil pada daftar barang.

### 6. Migrasi Referensi Transaksi

Project memiliki migrasi lokal untuk mengubah data transaksi lama yang masih menyimpan nama barang menjadi SKU.

Migrasi dijalankan saat inisialisasi Hive dan hanya mengubah referensi apabila barang dapat dikenali secara aman dari SKU atau nama barang yang unik.

### 7. Penyimpanan Lokal

Aplikasi dapat digunakan tanpa backend karena data disimpan secara lokal menggunakan Hive CE.

Data yang disimpan meliputi:

- Session pengguna
- Master barang
- Transaksi barang masuk
- Transaksi barang keluar

Box autentikasi menggunakan enkripsi Hive AES. Kunci enkripsi dibuat satu kali dan disimpan melalui Flutter Secure Storage.

## Akun Demo

Gunakan akun berikut untuk mencoba perbedaan hak akses:

| Role | Email | Password |
|---|---|---|
| Admin | `admin@stockflow.com` | `admin123` |
| Operator | `operator@stockflow.com` | `operator123` |

> Akun di atas masih bersifat hardcoded untuk kebutuhan demonstrasi dan studi kasus. Jangan gunakan pendekatan ini untuk autentikasi production.

## Teknologi

- Flutter
- Dart
- Riverpod
- Riverpod Generator
- Freezed
- JSON Serializable
- Hive CE
- Flutter Secure Storage
- Material Design
- Google Fonts
- Phosphor Icons

## Package

### Dependencies

| Package | Versi | Kegunaan |
|---|---:|---|
| `flutter_riverpod` | `^3.3.2` | State management dan dependency injection |
| `riverpod_annotation` | `^4.0.3` | Annotation untuk provider berbasis code generation |
| `hive_ce` | `^2.19.3` | Database key-value lokal |
| `hive_ce_flutter` | `^2.3.4` | Integrasi Hive CE dengan Flutter |
| `flutter_secure_storage` | `^10.3.1` | Menyimpan kunci enkripsi secara aman |
| `freezed_annotation` | `^3.1.0` | Immutable model dan union class |
| `json_annotation` | `^4.12.0` | Annotation serialisasi JSON |
| `google_fonts` | `^8.2.1` | Font untuk tampilan aplikasi |
| `phosphoricons_flutter` | `^1.0.0` | Koleksi ikon |
| `dio` | `^5.11.0` | HTTP client yang tersedia untuk pengembangan integrasi API |

### Dev Dependencies

| Package | Versi | Kegunaan |
|---|---:|---|
| `build_runner` | `^2.15.1` | Menjalankan code generator |
| `riverpod_generator` | `^4.0.4` | Menghasilkan provider Riverpod |
| `freezed` | `^3.2.5` | Menghasilkan immutable model |
| `json_serializable` | `^6.14.0` | Menghasilkan fungsi serialisasi JSON |
| `hive_ce_generator` | `^1.11.2` | Menghasilkan adapter Hive |
| `flutter_gen_runner` | `^5.15.0` | Menghasilkan akses asset secara type-safe |
| `riverpod_lint` | `^3.1.4` | Lint tambahan untuk Riverpod |
| `flutter_lints` | `^6.0.0` | Rekomendasi lint resmi Flutter |

## Struktur Project

Struktur utama project:

```text
lib/
├── extensions/
│   └── Extension untuk context dan role pengguna
├── models/
│   ├── auth/
│   ├── product/
│   ├── stock/
│   ├── transaction_product_inbound/
│   └── transaction_product_outbound/
├── pages/
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── splash_screen.dart
│   │   ├── main_frame_screen.dart
│   │   ├── product_list_screen.dart
│   │   ├── transaction_product_inbound_screen.dart
│   │   └── transaction_product_outbound_screen.dart
│   └── sections/
│       ├── product_form_section.dart
│       ├── add_inbound_transaction_section.dart
│       └── add_outbound_transaction_section.dart
├── states/
│   ├── actions/
│   │   ├── product/
│   │   └── stock/
│   └── stores/
│       ├── auth/
│       ├── product/
│       ├── transaction_product_inbound/
│       └── transaction_product_outbound/
├── storage/
│   ├── hive/
│   └── secure_storage/
├── tools/
├── utils/
├── app_routes.dart
├── app_theme.dart
└── main.dart
```

## Model Data

### Product

```dart
ProductModel(
  sku: String,
  itemName: String,
  category: String,
  unit: String,
)
```

### Transaksi Barang Masuk

```dart
TransactionProductInboundModel(
  date: DateTime,
  product: String, // SKU
  quantity: int,
  description: String?,
)
```

### Transaksi Barang Keluar

```dart
TransactionProductOutboundModel(
  date: DateTime,
  product: String, // SKU
  quantity: int,
  destination: String,
)
```

### Stok

```dart
StockModel(
  sku: String,
  itemName: String,
  category: String,
  unit: String,
  totalIn: int,
  totalOut: int,
)
```

Nilai stok tersedia melalui getter:

```dart
int get quantity => totalIn - totalOut;
```

## Alur Aplikasi

```text
Splash Screen
     │
     ├── Session tersedia ──> Main Frame
     │
     └── Session tidak ada ─> Login
                                  │
                                  ├── Admin ──> Master Barang
                                  │            Barang Masuk
                                  │            Barang Keluar
                                  │
                                  └── Operator -> Barang Masuk
                                                Barang Keluar
```

## Business Rules

1. SKU wajib diisi dan harus unik.
2. SKU dinormalisasi menjadi huruf kapital.
3. Nama barang, kategori, dan satuan wajib diisi.
4. Referensi barang pada transaksi disimpan menggunakan SKU.
5. Jumlah transaksi harus lebih dari nol.
6. Tujuan transaksi barang keluar wajib diisi.
7. Barang keluar tidak boleh melebihi stok tersedia.
8. Stok dihitung dari histori transaksi, bukan diubah secara manual.
9. Barang yang memiliki histori transaksi tidak dapat dihapus.
10. Data lama yang menggunakan nama barang akan dicoba dimigrasikan ke SKU.

## Menjalankan Project

### Prasyarat

Pastikan perangkat sudah memiliki:

- Flutter SDK yang kompatibel dengan Dart `^3.12.2`
- Android Studio atau Visual Studio Code
- Android SDK
- Emulator atau perangkat Android

Periksa instalasi Flutter:

```bash
flutter doctor
```

### Instalasi

Clone repository:

```bash
git clone https://github.com/farhanabdulghn/stock_flow.git
cd stock_flow
```

Install dependency:

```bash
flutter pub get
```

Jalankan code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Jalankan aplikasi:

```bash
flutter run
```

## Code Generation

Project menggunakan code generation untuk:

- Freezed
- JSON Serializable
- Riverpod
- Hive adapter
- Flutter Gen

Saat mengembangkan model atau provider, gunakan mode watch:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Route juga memiliki generator internal yang dapat dijalankan dengan:

```bash
dart lib/tools/generate_routes.dart
```

## Penyimpanan dan Keamanan

Saat aplikasi pertama kali dijalankan:

1. Hive diinisialisasi.
2. Seluruh adapter model didaftarkan.
3. Kunci enkripsi dibuat apabila belum tersedia.
4. Kunci disimpan di Flutter Secure Storage.
5. Box autentikasi dibuka menggunakan `HiveAesCipher`.
6. Box barang dan transaksi dibuka.
7. Migrasi referensi transaksi dari nama barang ke SKU dijalankan.

> Data barang dan transaksi saat ini disimpan secara lokal pada perangkat. Menghapus data aplikasi akan menghapus database lokal.

## Catatan Pengembangan

- Nama package internal pada `pubspec.yaml` saat ini masih `untitled`.
- Autentikasi masih menggunakan akun demo lokal.
- `dio` sudah tersedia sebagai dependency, tetapi aplikasi saat ini berfokus pada penyimpanan lokal.
- Aplikasi dikunci pada orientasi portrait.
- Belum terdapat sinkronisasi cloud atau backend.
- Belum terdapat automated test yang mencakup seluruh business rule.

## Pengembangan Berikutnya

Beberapa pengembangan yang dapat dilakukan:

- Integrasi REST API dan backend
- Autentikasi production
- Sinkronisasi data multi-device
- Audit trail pengguna untuk setiap transaksi
- Pagination dan filter berdasarkan tanggal
- Export laporan ke PDF atau Excel
- Dashboard statistik stok
- Notifikasi stok menipis
- Barcode atau QR scanner untuk memilih barang
- Unit test dan widget test untuk business rule
- Role dan permission yang dikelola dari server

## Author

**Farhan Abdul Ghani**

- GitHub: [farhanabdulghn](https://github.com/farhanabdulghn)
- Repository: [stock_flow](https://github.com/farhanabdulghn/stock_flow)
