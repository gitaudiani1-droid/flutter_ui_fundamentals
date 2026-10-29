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
}
