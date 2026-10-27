import 'http_get_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_constants.dart';
import 'providers/course_provider.dart';
import 'providers/course_state.dart';
import 'repositories/course_repository.dart';
import 'screens/main_page.dart';
import 'services/course_service.dart';
const String studentId = "2415051010";
const String studentName = "I Gusti Ayu Agung Gita Udiani";

void main() {
  fetchTestPost().catchError((error) {
    debugPrint('Gagal mengambil data: $error');
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CourseProvider(
            CourseRepository(CourseService()),
          )..loadCourses(),
        ),
        ChangeNotifierProvider(
          create: (_) => CourseState(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
