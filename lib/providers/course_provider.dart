import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

//2415051010_I Gusti Ayu Agung Gita Udiani
class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;
  CourseProvider(this.repository);
  List<Course> _courses = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;
  List<Course> get courses => List.unmodifiable(_courses);
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
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
  Future<Course?> createCourse(Course course) async {
    if (_isSaving) return null;
    _isSaving = true;
    notifyListeners();
    try {
      final createdCourse =
      await repository.createCourse(course);
      _courses = [
        createdCourse,
        ..._courses,
      ];
      return createdCourse;
    } catch (e) {
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  Future<bool> updateCourse(int id, Course course) async {
    if (_isSaving) return false;
    _isSaving = true;
    notifyListeners();
    try {
      await repository.updateCourse(id, course);
      final index = _courses.indexWhere(
            (item) => item.id == id,
      );
      if (index != -1) {
        final updatedCourses = List<Course>.from(_courses);
        updatedCourses[index] = course;
        _courses = updatedCourses;
      }
      return true;
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  Future<bool> deleteCourse(int id) async {
    if (_isSaving) return false;
    _isSaving = true;
    notifyListeners();
    try {
      await repository.deleteCourse(id);
      _courses = _courses
          .where((course) => course.id != id)
          .toList();
      return true;
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
