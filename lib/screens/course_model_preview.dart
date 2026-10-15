import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_constants.dart';
import '../providers/course_provider.dart';

class CourseModelPreview extends StatelessWidget {
  const CourseModelPreview({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Course Model')),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Gagal memuat data: ${provider.error}',textAlign: TextAlign.center),
              ),
            );
          }
          if (provider.courses.isEmpty) {
            return const Center(child: Text('Belum ada data mata kuliah'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('$studentName\nNIM: $studentId',style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    return ListTile(
                      title: Text(course.title),
                      subtitle: Text(
                        '${course.code} • ${course.credits} SKS',
                      ),
                      trailing: Text(course.status),
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
