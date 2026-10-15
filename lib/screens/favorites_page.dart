import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (courseProvider.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  const Text('Gagal memuat data mata kuliah.',textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: courseProvider.loadCourses,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }
        return Consumer<CourseState>(
          builder: (context, courseState, child) {
            final List<Course> favoriteCourses =
            courseProvider.courses
                .where(
                  (course) =>
                  courseState.isFavorite(course.code),
            )
                .toList();
            if (favoriteCourses.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border,size: 64,color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Belum ada mata kuliah favorit.',textAlign: TextAlign.center,style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Tambahkan mata kuliah ke favorit melalui halaman Mata Kuliah.',textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Mata Kuliah Favorit',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.favorite,color: Colors.red),
                      const SizedBox(width: 6),
                      Text('${favoriteCourses.length}'),
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
                        itemCount: favoriteCourses.length,
                        itemBuilder: (context, index) {
                          final Course course =
                          favoriteCourses[index];
                          return CourseCard(
                            course: {
                              'title': course.title,
                              'code': course.code,
                              'credits': course.credits,
                              'status': course.status,
                            },
                            isFavorite: courseState
                                .isFavorite(course.code),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CourseDetailPage(
                                        course: course,
                                      ),
                                ),
                              );
                            },
                            onLongPress: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text('Mata kuliah ${course.title}'),
                                ),
                              );
                            },
                            onFavoriteChanged: () {
                              courseState.toggleFavorite(
                                course.code,
                              );
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
