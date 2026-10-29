import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_constants.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/course_state.dart';
import 'course_edit_page.dart';

// 2415051010_I Gusti Ayu Agung Gita Udiani

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.blue;
      case 'done':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Berlangsung';
      case 'done':
        return 'Selesai';
      default:
        return 'Direncanakan';
    }
  }

  Future<void> _confirmDelete(BuildContext context, Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 36,
        ),
        title: const Text('Hapus Mata Kuliah?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus '
          '"${course.title}"? Data yang dihapus tidak dapat '
          'ditampilkan kembali tanpa menambahkannya lagi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final courseId = course.id;
    if (courseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID mata kuliah tidak ditemukan.')),
      );
      return;
    }

    final provider = context.read<CourseProvider>();
    final courseState = context.read<CourseState>();

    final success = await provider.deleteCourse(courseId);

    if (!context.mounted) return;

    if (success) {
      if (courseState.isFavorite(course.code)) {
        courseState.toggleFavorite(course.code);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil dihapus.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus mata kuliah. Silakan coba lagi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(course.status);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Mata Kuliah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<CourseState>(
        builder: (context, courseState, child) {
          final isFavorite = courseState.isFavorite(course.code);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header detail
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      course.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF24245A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel(course.status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Informasi Mata Kuliah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    _detailTile(
                      icon: Icons.tag_rounded,
                      label: 'Kode Mata Kuliah',
                      value: course.code,
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _detailTile(
                      icon: Icons.school_outlined,
                      label: 'Jumlah SKS',
                      value: '${course.credits} SKS',
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _detailTile(
                      icon: Icons.flag_outlined,
                      label: 'Status',
                      value: _statusLabel(course.status),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Aksi Mata Kuliah',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseEditPage(course: course),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Edit Mata Kuliah'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmDelete(context, course),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Hapus Mata Kuliah'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Favorit
              Card(
                child: ListTile(
                  leading: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 28,
                  ),
                  title: Text(
                    isFavorite ? 'Mata kuliah favorit' : 'Tambahkan ke favorit',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    isFavorite
                        ? 'Tersimpan dalam daftar favoritmu.'
                        : 'Simpan agar mudah ditemukan kembali.',
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
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Informasi mahasiswa
              const Text(
                'Informasi Mahasiswa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _studentInfo(
                        icon: Icons.person_outline_rounded,
                        label: 'Nama',
                        value: studentName,
                      ),
                      const Divider(height: 24),
                      _studentInfo(
                        icon: Icons.badge_outlined,
                        label: 'NIM',
                        value: studentId,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'Course Data Manager',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _detailTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4F46E5)),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _studentInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4F46E5)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
