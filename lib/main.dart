import 'package:flutter/material.dart';
const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Student Profile')),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName\nNIM: $studentId', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Form Profil Mahasiswa', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),

            const TextField(
              decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Program Studi', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Tentang Saya',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            for (int i = 1; i <= 5; i++)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.school),
                  title: Text('Informasi Akademik $i'),
                  subtitle: const Text('Detail informasi mahasiswa'),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informasi disimpan'),
                  ),
                );
              },
              child: const Text('Simpan Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
