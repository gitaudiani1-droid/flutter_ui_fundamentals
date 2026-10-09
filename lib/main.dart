import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';

void main() {
  runApp(const MyApp());
}

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;
  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Learning Dashboard',style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3157C8),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Gagal memuat data:\n${snapshot.error}',textAlign: TextAlign.center)),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak tersedia.'));
          }

          final data = snapshot.data!;
          final Map<String, dynamic> student =
              data['student'] as Map<String, dynamic>;
          final List<dynamic> courses =
              data['courses'] as List<dynamic>;
          final int totalCredits = courses.fold<int>(
            0,
            (sum, item) =>
                sum + (item['credits'] as int),
          );
          final String programStudi = student['programStudi'] as String? ??'Program studi belum diisi';
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: const AssetImage('assets/images/profile.jpg'),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(studentName,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('NIM: $studentId'),
                              const SizedBox(height: 4),
                              Text(programStudi,style: const TextStyle(color: Colors.black54,fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Materi',
                          value: '${courses.length}',
                          icon: Icons.menu_book,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          title: 'Total SKS',
                          value: '$totalCredits',
                          icon: Icons.school,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text('Materi Pembelajaran',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> course = courses[index] as Map<String, dynamic>;
                      return CourseCard(course: course);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(value,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: color)),
            const SizedBox(height: 4),
            Text(title,textAlign: TextAlign.center,style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseCard({
    super.key,
    required this.course,
  });
  @override
  Widget build(BuildContext context) {
    final String status = course['status'] as String;
    final Color statusColor;
    final IconData statusIcon;
    final String statusLabel;

    switch (status) {
      case 'done':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusLabel = 'Selesai';
        break;
      case 'active':
        statusColor = Colors.orange;
        statusIcon = Icons.play_circle;
        statusLabel = 'Dipelajari';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.schedule;
        statusLabel = 'Direncanakan';
    }
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.12),
          child: Icon(statusIcon,color: statusColor)),
        title: Text(course['title'] as String,style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text('${course['code']} • ${course['credits']} SKS')),
        trailing: Text(statusLabel,style: TextStyle(color: statusColor,fontSize: 11,fontWeight: FontWeight.bold)),
      ),
    );
  }
}