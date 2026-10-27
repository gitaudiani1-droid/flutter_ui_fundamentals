import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models/course.dart';

const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';

const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
Future<List<Course>> fetchCourses() async {
  debugPrint('Nama: $studentName');
  debugPrint('NIM: $studentId');
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final List<dynamic> jsonList =
    jsonDecode(response.body) as List<dynamic>;
    final courses = jsonList
        .map((item) => Course.fromJson(item as Map<String, dynamic>))
        .toList();
    debugPrint('Jumlah data: ${courses.length}');
    for (final course in courses.take(3)) {
      debugPrint(
        '${course.code} | ${course.title} | ${course.status}',
      );
    }
    return courses;
  }
  throw Exception('HTTP ${response.statusCode}');
}
