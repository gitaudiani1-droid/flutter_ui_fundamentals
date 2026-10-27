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