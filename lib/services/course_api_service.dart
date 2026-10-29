//2415051010_I Gusti Ayu Agung Gita Udiani
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
  void dispose() {
    _client.close();
  }
}
