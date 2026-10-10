import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Future<Map<String, dynamic>> loadData() async {
    final jsonString =
    await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              return const Center(child: Text('Gagal memuat data'));
            }
            return const Center(child: CircularProgressIndicator());
          }
          final courses = snapshot.data!['courses'] as List<dynamic>;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('$studentName\nNIM: $studentId', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              for (final item in courses)
                Card(
                  child: ListTile(
                    title: Text(item['title'].toString()),
                    subtitle: Text('Kode: ${item['code']}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailPage(
                            course: Map<String, dynamic>.from(item),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseDetailPage({
    super.key,
    required this.course,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Course')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentName\nNIM: $studentId', style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(height: 32),
            Text(course['title'].toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),
            const SizedBox(height: 16),
            Text('Kode: ${course['code']}'),
            Text('SKS: ${course['credits']}'),
            Text('Status: ${course['status']}'),
          ],
        ),
      ),
    );
  }
}
