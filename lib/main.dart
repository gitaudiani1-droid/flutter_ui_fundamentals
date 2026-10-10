import 'package:flutter/material.dart';
const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const CompactLayout();
          } else if (constraints.maxWidth < 840) {
            return const MediumLayout();
          } else {
            return const ExpandedLayout();
          }
        },
      ),
    );
  }
}

class StudentIdentity extends StatelessWidget {
  const StudentIdentity({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('$studentId - $studentName', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

const List<Map<String, dynamic>> courses = [
  {'title': 'Flutter Dasar','description': 'Dasar-dasar Flutter', 'icon': Icons.flutter_dash},
  {'title': 'Dart','description': 'Dasar-dasar dan komponen Dart', 'icon': Icons.web},
  {'title': 'Pemrograman Mobile','description': 'Dasar Pemrograman Mobile', 'icon': Icons.mobile_friendly},
];

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StudentIdentity(),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Compact Layout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: courses.map((course) {
              return CourseCard(
                title: course['title'] as String,
                description: course['description'] as String,
                icon: course['icon'] as IconData,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StudentIdentity(),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Medium Layout', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: courses.map((course) {
              return CourseCard(
                title: course['title'] as String,
                description: course['description'] as String,
                icon: course['icon'] as IconData,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StudentIdentity(),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(24),
          child: Text('Expanded Layout', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: courses.map((course) {
              return CourseCard(
                title: course['title'] as String,
                description: course['description'] as String,
                icon: course['icon'] as IconData,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
