import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  late Future<Map<String, dynamic>> dataFuture;
  @override
  void initState() {
    super.initState();
    dataFuture = loadData();
  }
  Future<Map<String, dynamic>> loadData() async {
    final jsonString =
    await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      CoursesPage(dataFuture: dataFuture),
      const ProfilePage(),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.home, size: 70),
            const SizedBox(height: 16),
            const Text('Selamat Datang!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Course Explorer'),
            const Divider(height: 32),
            const Text(studentName),
            const Text('NIM: $studentId'),
          ],
        ),
      ),
    );
  }
}
class CoursesPage extends StatelessWidget {
  final Future<Map<String, dynamic>> dataFuture;
  const CoursesPage({super.key, required this.dataFuture});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Gagal memuat data mata kuliah'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final courses = snapshot.data!['courses'] as List<dynamic>;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Daftar Mata Kuliah', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final course in courses)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(course['title'].toString()),
                  subtitle: Text('Kode: ${course['code']}'),
                ),
              ),
          ],
        );
      },
    );
  }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 45, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            const Text('Profil Mahasiswa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(studentName),
            const SizedBox(height: 8),
            const Text('NIM: $studentId'),
            const SizedBox(height: 8),
            const Text('Program Studi: Pendidikan Teknik Informatika'),
          ],
        ),
      ),
    );
  }
}
