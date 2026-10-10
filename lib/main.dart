import 'package:flutter/material.dart';
const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';
const List<String> skills = [
  'Flutter','Dart', 'Web', 'Mobile', 'Expanded', 'Flexible', 'Wrap',
];

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    Widget buildBox(String text){
      return Container(
        height: 100,
        alignment: Alignment.center,
        color: Colors.cyan,
        child: Text('Panel $text', style: const TextStyle(color: Colors.white)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentId - $studentName', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(flex: 2,child: buildBox('A')),
                const SizedBox(width: 8),
                Expanded(child: buildBox('B')),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Flexible(
                  flex: 2, 
                  child: Container(
                    width: double.infinity, 
                    padding: const EdgeInsets.all(16), 
                    color: Colors.tealAccent.shade100,
                    child: const Text('Flexible A', textAlign: TextAlign.center)),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.teal.shade100,
                      child: const Text('Flexible B', textAlign: TextAlign.center)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Perbandingan Row dan Wrap', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            const Text('Row biasa tidak otomatis memindahkan child ke baris berikutnya. Wrap dapat membungkus child saat ruang tidak cukup.'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Contoh Row: semua child tetap disusun secara horizontal. Jika ukurannya melebihi ruang tersedia, dapat terjadi overflow.'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBox(String text, Color color){
  return Container(
    height: 120,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}