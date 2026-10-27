import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;
  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    required this.onLongPress,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });
  @override
  Widget build(BuildContext context) {
    final String title =
        course['title']?.toString() ?? 'Tanpa Judul';
    final String code = course['code']?.toString() ?? '-';
    final String status =
        course['status']?.toString() ?? 'planned';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.book, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Kode: $code'),
                    const SizedBox(height: 4),
                    Text('Status: $status'),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite
                    ? 'Hapus dari favorit'
                    : 'Tambahkan ke favorit',
                onPressed: onFavoriteChanged,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
