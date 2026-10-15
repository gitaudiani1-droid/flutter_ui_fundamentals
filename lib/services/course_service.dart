import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course.dart';

class CourseService {
  Future<List<Course>> fetchCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );
    final decodedData = jsonDecode(jsonString);
    final List<dynamic> courseData = decodedData['courses'];
    return courseData
        .map((item) => Course.fromJson(
      Map<String, dynamic>.from(item as Map),
    ))
        .toList();
  }
}
