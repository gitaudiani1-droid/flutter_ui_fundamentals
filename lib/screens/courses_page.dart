
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_detail_page.dart';
import 'add_course_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.error != null) {
          return ErrorView(
            message: provider.error!,
            onRetry: provider.loadCourses,
          );
        }

        final courses = provider.courses;

        return Consumer<CourseState>(
          builder: (context, courseState, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Daftar Mata Kuliah\n'
                              '2415051010_I Gusti Ayu Agung Gita Udiani',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tambah Mata Kuliah',
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddCoursePage(),
                            ),
                          );
                        },
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text('${courseState.favoriteCount}'),
                    ],
                  ),
                ),
                Expanded(
                  child: courses.isEmpty
                      ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 48,
                        ),
                        SizedBox(height: 12),
                        Text('Belum ada mata kuliah.'),
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final Course course = courses[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: CourseCard(
                          course: {
                            'title': course.title,
                            'code': course.code,
                            'credits': course.credits,
                            'status': course.status,
                          },
                          isFavorite: courseState.isFavorite(
                            course.code,
                          ),
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
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Mata kuliah ${course.title}',
                                ),
                              ),
                            );
                          },
                          onFavoriteChanged: () {
                            courseState.toggleFavorite(
                              course.code,
                            );
                          },
                        ),
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
