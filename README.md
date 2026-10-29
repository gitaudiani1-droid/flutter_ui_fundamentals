# flutter_ui_fundamentals

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Course Explorer v2

## Struktur Folder dan Tanggung Jawab

- **`lib/models/`**: Mendefinisikan struktur data dan konversi JSON menjadi objek, seperti model `Course`.
- **`lib/services/`**: Mengambil data dari sumber data, seperti membaca file JSON dari assets.
- **`lib/repositories/`**: Menjadi perantara antara Provider dan Service untuk menyediakan data kepada lapisan pengelola state.
- **`lib/providers/`**: Mengelola state aplikasi, termasuk daftar mata kuliah, status loading, error, dan favorit, serta memberi tahu UI ketika state berubah.
- **`lib/screens/`**: Menyusun halaman aplikasi, menangani navigasi, dan menampilkan data melalui Provider.
- **`lib/widgets/`**: Menyediakan komponen UI yang dapat digunakan kembali, seperti kartu mata kuliah.
- **`assets/data/`**: Menyimpan data JSON mata kuliah yang digunakan aplikasi.

## Alur Data

Screen/Widget → Provider → Repository → Service/Data Source.

UI tidak membaca file JSON secara langsung. Pembacaan data dilakukan oleh Service, sedangkan Provider mengelola state agar perubahan data dapat ditampilkan pada UI.

## Teknologi

- Flutter dan Dart
- Provider untuk state management
- JSON assets sebagai sumber data mata kuliah

## Observasi Endpoint
### Informasi Endpoint
- Endpoint URL: https://jsonplaceholder.typicode.com/posts/1
- HTTP Method: GET
- Status Code: 200 OK
- Resource: posts (single post, ID 1)

### Field JSON
1 `userId` --> Integer --> ID pengguna pemilik post 
2 `id` --> Integer --> ID post 
3 `title` --> String --> Judul post
4 `body` --> String --> Isi post 

### Catatan/Temuan
Endpoint berhasil menampilkan data dalam format JSON melalui HTTP method GET. 
Respons berisi empat field, yaitu `userId`, `id`, `title`, dan `body`. 
Endpoint ini digunakan sebagai latihan awal untuk memahami struktur data REST API 
sebelum diintegrasikan ke aplikasi Course Data Manager. 
JSONPlaceholder merupakan API dummy sehingga operasi penulisan data tidak disimpan secara permanen.

# Course Data Manager

## Deskripsi Aplikasi

Course Data Manager adalah aplikasi Flutter untuk mengelola data mata kuliah. Aplikasi ini dikembangkan sebagai mini project integrasi dengan backend Supabase.

Fitur utama:
- Menampilkan daftar mata kuliah.
- Menambahkan mata kuliah baru.
- Mengedit dan menghapus data mata kuliah.
- Menampilkan detail mata kuliah.
- Menyimpan mata kuliah favorit.
- Menampilkan loading, empty state, error state, dan feedback kepada pengguna.
- Mendukung navigasi responsif untuk ukuran layar berbeda.

## Teknologi

- Flutter dan Dart
- Provider untuk state management
- Supabase sebagai backend dan database
- Git dan GitHub untuk version control

## Arsitektur Singkat

Aplikasi menggunakan pemisahan tanggung jawab sebagai berikut:

- **Model:** merepresentasikan data mata kuliah.
- **Service/Data Source:** menangani komunikasi dengan REST API atau Supabase.
- **Repository:** menjadi perantara antara data source dan provider.
- **Provider:** mengelola state dan operasi data.
- **Screen:** menampilkan halaman dan interaksi pengguna.
- **Widgets:** menyediakan komponen UI yang dapat digunakan kembali.

Pemilihan data source aktif dilakukan di `main.dart`.

## Cara Menjalankan
1. Pastikan Flutter SDK dan Git telah terpasang.
2. Clone repository:
   ```bash
   git clone https://github.com/gitaudiani1-droid/flutter_ui_fundamentals.git
   ```
3. Masuk ke direktori proyek:
   ```bash
   cd flutter_ui_fundamentals
   ```
4. Unduh dependency:
   ```bash
   flutter pub get
   ```
5. Konfigurasikan URL dan publishable key Supabase sesuai lingkungan proyek.
6. Pastikan tabel `courses` dan policy RLS telah disiapkan.
7. Jalankan pemeriksaan:

   ```bash
   flutter analyze
   ```

8. Jalankan aplikasi:

   ```bash
   flutter run
   ```

## Backend
Backend menggunakan Supabase dengan tabel `courses` untuk menyimpan data mata kuliah. Akses data dilakukan melalui `CourseSupabaseService` dan diteruskan melalui repository serta provider.
**Catatan keamanan:** Jangan menyimpan `service_role` key, password, atau credential rahasia di repository. Policy RLS harus disesuaikan dengan kebutuhan keamanan aplikasi.

## Pengembang
Nama: I Gusti Ayu Agung Gita Udiani  
NIM: 2415051010
