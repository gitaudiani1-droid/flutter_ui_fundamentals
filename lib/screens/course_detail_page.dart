import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_constants.dart';
import '../models/course.dart';
import '../providers/course_state.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({
    super.key,
    required this.course,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mata Kuliah')),
      body: Consumer<CourseState>(
        builder: (context, courseState, child) {
          final isFavorite = courseState.isFavorite(course.code);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Icon(Icons.menu_book,size: 80)),
                const SizedBox(height: 24),
                Text(course.title,style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildDetailRow('Kode Mata Kuliah', course.code),
                _buildDetailRow('Jumlah SKS', '${course.credits} SKS'),
                _buildDetailRow('Status', course.status),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    title: Text(
                      isFavorite
                          ? 'Sudah ditambahkan ke favorit'
                          : 'Belum ditambahkan ke favorit',
                    ),
                    trailing: IconButton(
                      tooltip: isFavorite
                          ? 'Hapus dari favorit'
                          : 'Tambahkan ke favorit',
                      onPressed: () {
                        courseState.toggleFavorite(course.code);
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 32),
                const Text('Informasi Mahasiswa',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('Nama: $studentName'),
                const SizedBox(height: 8),
                const Text('NIM: $studentId'),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label,style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
