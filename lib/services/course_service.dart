import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseService {
  static const String apiUrl =
      'https://jsonplaceholder.typicode.com/posts';
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData =
      jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((item) {
        return Course.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();
    }
    debugPrint(
      'Gagal mengambil data. Status: ${response.statusCode}',
    );
    throw Exception(
      'Gagal memuat courses: HTTP ${response.statusCode}',
    );
  }
}
