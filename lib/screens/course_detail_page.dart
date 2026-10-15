import 'package:flutter/material.dart';
import '../app_constants.dart';

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseDetailPage({
    super.key,
    required this.course,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mata Kuliah')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.menu_book,size: 80),
            ),
            const SizedBox(height: 24),
            Text(
              course['title']?.toString() ?? 'Tanpa Judul',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Kode Mata Kuliah',course['code']?.toString() ?? '-'),
            _buildDetailRow('Jumlah SKS','${course['credits'] ?? '-'} SKS'),
            _buildDetailRow('Status',course['status']?.toString() ?? '-'),
            const Divider(height: 32),
            const Text('Informasi Mahasiswa',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Nama: $studentName'),
            const SizedBox(height: 8),
            Text('NIM: $studentId'),
          ],
        ),
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
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
