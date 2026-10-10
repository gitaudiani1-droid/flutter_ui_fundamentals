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
  int selectedIndex = 0;
  late Future<Map<String, dynamic>> dataFuture;
  @override
  void initState() {
    super.initState();
    dataFuture = loadData();
  }
  Future<Map<String, dynamic>> loadData() async {
    final jsonString = await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
  final List<Widget> pages = const [
    HomePage(),
    CoursesPagePlaceholder(),
    ProfilePage(),
  ];
  Widget buildNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
        NavigationRailDestination(icon: Icon(Icons.school), label: Text('Courses')),
        NavigationRailDestination(icon: Icon(Icons.person), label: Text('Profile')),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final responsivePages = [
      const HomePage(),
      CoursesPage(dataFuture: dataFuture),
      const ProfilePage(),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return Scaffold(
            appBar: AppBar(title: const Text('Course Explorer')),
            body: responsivePages[selectedIndex],
            bottomNavigationBar: buildNavigationBar(),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Course Explorer')),
          body: Row(
            children: [
              buildNavigationRail(),
              const VerticalDivider(width: 1),
              Expanded(child: responsivePages[selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home, size: 70),
            SizedBox(height: 16),
            Text('Selamat Datang!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(studentName),
            Text('NIM: $studentId'),
          ],
        ),
      ),
    );
  }
}
class CoursesPage extends StatelessWidget {
  final Future<Map<String, dynamic>> dataFuture;
  const CoursesPage({
    super.key,
    required this.dataFuture,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Gagal memuat data'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final courses = snapshot.data!['courses'] as List<dynamic>;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Daftar Mata Kuliah', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
class CoursesPagePlaceholder extends StatelessWidget {
  const CoursesPagePlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Courses'));
  }
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 45, child: Icon(Icons.person, size: 50)),
            SizedBox(height: 20),
            Text('Profil Mahasiswa', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(studentName),
            SizedBox(height: 8),
            Text('NIM: $studentId'),
            SizedBox(height: 8),
            Text('Program Studi: Pendidikan Teknik Informatika'),
          ],
        ),
      ),
    );
  }
}
