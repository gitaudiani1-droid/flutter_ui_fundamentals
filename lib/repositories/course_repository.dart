import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  final CourseApiService service;
  CourseRepository(this.service);
  Future<List<Course>> getCourses() async {
    return service.getCourses();
  }
  Future<Course> createCourse(Course course) async {
    return service.createCourse(course);
  }
  Future<void> updateCourse(int id, Course course) async {
    await service.updateCourse(id, course);
  }
  Future<void> deleteCourse(int id) async {
    await service.deleteCourse(id);
  }
}
