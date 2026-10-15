import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;
  CourseProvider(this.repository);
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;
  List<Course> get courses => List.unmodifiable(_courses);
  bool get isLoading => _isLoading;
  String? get error => _error;
  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
