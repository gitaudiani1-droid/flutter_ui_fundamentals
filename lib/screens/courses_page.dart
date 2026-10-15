import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  final Future<Map<String, dynamic>> dataFuture;
  const CoursesPage({
    super.key,
    required this.dataFuture,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Data mata kuliah tidak tersedia.'));
        }
        final rawCourses = snapshot.data!['courses'];
        if (rawCourses is! List || rawCourses.isEmpty) {
          return const Center(child: Text('Belum ada mata kuliah.'));
        }
        final courses = rawCourses
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
        return Consumer<CourseState>(
          builder: (context, courseState, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Daftar Mata Kuliah',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.favorite, color: Colors.red),
                      const SizedBox(width: 6),
                      Text('${courseState.favoriteCount}'),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount =
                      constraints.maxWidth >= 900
                          ? 3
                          : constraints.maxWidth >= 600
                          ? 2
                          : 1;
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: 100,
                        ),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          final code = course['code'].toString();
                          final isFavorite =
                          courseState.isFavorite(code);
                          return CourseCard(
                            course: course,
                            isFavorite: isFavorite,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailPage(
                                    course: course,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Mata kuliah ${course['title']}'),
                                ),
                              );
                            },
                            onFavoriteChanged: () {
                              courseState.toggleFavorite(code);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
