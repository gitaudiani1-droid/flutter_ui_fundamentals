import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  Text('Gagal memuat mata kuliah:\n${provider.error}',textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: provider.loadCourses,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }
        final courses = provider.courses;
        if (courses.isEmpty) {
          return const Center(child: Text('Belum ada mata kuliah.'));
        }
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
                          final Course course = courses[index];
                          return CourseCard(
                            course: {
                              'title': course.title,
                              'code': course.code,
                              'credits': course.credits,
                              'status': course.status,
                            },
                            isFavorite:
                            courseState.isFavorite(course.code),
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
                                  content: Text('Mata kuliah ${course.title}'),
                                ),
                              );
                            },
                            onFavoriteChanged: () {
                              courseState.toggleFavorite(course.code);
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
