
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await _supabase
        .from('courses')
        .select()
        .order('id');

    return (data as List)
        .map(
          (item) => Course.fromJson(
        Map<String, dynamic>.from(item as Map),
      ),
    )
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final row = await _supabase
        .from('courses')
        .insert({
      'code': course.code,
      'title': course.title,
      'credits': course.credits,
      'status': course.status,
    })
        .select()
        .single();

    return Course.fromJson(Map<String, dynamic>.from(row));
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    await _supabase
        .from('courses')
        .update({
      'code': course.code,
      'title': course.title,
      'credits': course.credits,
      'status': course.status,
    })
        .eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    await _supabase
        .from('courses')
        .delete()
        .eq('id', id);
  }
}
