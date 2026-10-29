import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'providers/course_state.dart';
import 'repositories/course_repository.dart';
import 'screens/main_page.dart';
import 'services/course_api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
const String studentId = "2415051010";
const String studentName = "I Gusti Ayu Agung Gita Udiani";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    publishableKey: SupabaseConfig.supabasePublishableKey,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CourseProvider(
            CourseRepository(CourseApiService()),
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
