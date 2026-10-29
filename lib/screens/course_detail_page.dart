import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_constants.dart';
import '../models/course.dart';
import '../providers/course_state.dart';
import 'course_edit_page.dart';
import '../providers/course_provider.dart';

//2415051010_I Gusti Ayu Agung Gita Udiani
class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({
    super.key,
    required this.course,
  });
  Future<void> _confirmDelete(
      BuildContext context,
      Course course,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Mata Kuliah?'),
        content: Text(
          'Yakin ingin menghapus ${course.title}?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final provider = context.read<CourseProvider>();
    final courseState = context.read<CourseState>();
    final success = await provider.deleteCourse(
      course.id ?? -1,
    );
    if (!context.mounted) return;
    if (success) {
      if (courseState.isFavorite(course.code)) {
        courseState.toggleFavorite(course.code);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil dihapus'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus mata kuliah'),
        ),
      );
    }
  }
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
                //2415051010_I Gusti Ayu Agung Gita Udiani
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _confirmDelete(context, course),
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus Mata Kuliah'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseEditPage(course: course),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Mata Kuliah'),
                  ),
                ),
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
