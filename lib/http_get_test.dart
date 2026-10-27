import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';

const String apiUrl = 'https://jsonplaceholder.typicode.com/posts/1';
Future<Map<String, dynamic>> fetchTestPost() async {
  debugPrint('Nama: $studentName');
  debugPrint('NIM: $studentId');
  debugPrint('Memulai request GET ke: $apiUrl');
  final response = await http.get(Uri.parse(apiUrl));
  debugPrint('HTTP Status Code: ${response.statusCode}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint('Data berhasil diterima.');
    debugPrint('ID post: ${data['id']}');
    debugPrint('Judul post: ${data['title']}');
    return data;
  }
  throw Exception('HTTP ${response.statusCode}');
}
