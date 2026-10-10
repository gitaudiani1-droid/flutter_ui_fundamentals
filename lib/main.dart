import 'package:flutter/material.dart';
const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentId - $studentName'),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade100,
              child: const Text(
                'Daftar Kursus\n'
                    '1. Flutter Dasar\n'
                    '2. Desain UI/UX\n'
                    '3. Pemrograman Web',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
