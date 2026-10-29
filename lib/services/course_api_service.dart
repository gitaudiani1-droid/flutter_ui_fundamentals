import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  CourseApiService({http.Client? client})
      : _client = client ?? http.Client();
  final http.Client _client;
  static const String baseUrl =
      'https://jsonplaceholder.typicode.com';
  Future<List<Course>> getCourses() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/posts'),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil course: HTTP ${response.statusCode}',
      );
    }
    final List<dynamic> data =
    jsonDecode(response.body) as List<dynamic>;
    return data.map((item) {
      return Course.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }
  Future<Course> createCourse(Course course) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return Course.fromJson(
        jsonDecode(response.body)
        as Map<String, dynamic>,
      );
    }
    throw Exception(
      'Gagal membuat course: HTTP ${response.statusCode}',
    );
  }
  Future<void> updateCourse(int id, Course course) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal memperbarui course: HTTP ${response.statusCode}',
      );
    }
  }
  Future<void> deleteCourse(int id) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/posts/$id'),
    );
    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal menghapus course: HTTP ${response.statusCode}',
      );
    }
  }  void dispose() {
    _client.close();
  }
}
