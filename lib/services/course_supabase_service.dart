import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';
import 'package:flutter/foundation.dart';
//2415051010_I Gusti Ayu Agung Gita Udiani
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
  //2415051010_I Gusti Ayu Agung Gita Udiani

  @override
  Future<Course> createCourse(Course course) async {
    final userId = _supabase.auth.currentUser!.id;

    final row = await _supabase
        .from('courses')
        .insert({
      'code': course.code,
      'title': course.title,
      'credits': course.credits,
      'status': course.status,
      'owner_id': userId,
    })
        .select()
        .single();

    return Course.fromJson(
      Map<String, dynamic>.from(row),
    );
  }

  //2415051010_I Gusti Ayu Agung Gita Udiani

  @override
  Future<void> updateCourse(int id, Course course) async {
    final rows = await _supabase
        .from('courses')
        .update({
      'code': course.code,
      'title': course.title,
      'credits': course.credits,
      'status': course.status,
    })
        .eq('id', id)
        .select();

    if (rows.isEmpty) {
      throw Exception(
        'Update gagal: kamu tidak memiliki izin untuk mengubah mata kuliah ini.',
      );
    }
  }

  //2415051010_I Gusti Ayu Agung Gita Udiani

  @override
  Future<void> deleteCourse(int id) async {
    final rows = await _supabase
        .from('courses')
        .delete()
        .eq('id', id)
        .select();

    if (rows.isEmpty) {
      throw Exception(
        'Delete gagal: kamu tidak memiliki izin untuk menghapus mata kuliah ini.',
      );
    }
  }

  Future<void> testUpdatePermission(int courseId) async {

    try {
      final rows = await _supabase
          .from('courses')
          .update({'title': 'DIUBAH OLEH USER B'})
          .eq('id', courseId)
          .select();

      if (rows.isEmpty) {
        debugPrint('[PASS] UPDATE ditolak oleh RLS');
      } else {
        debugPrint('[FAIL] User B berhasil mengubah data User A');
      }
    } catch (e) {
      debugPrint('[PASS] UPDATE ditolak: $e');
    }
  }

  Future<void> testDeletePermission(int courseId) async {
    try {
      final rows = await _supabase
          .from('courses')
          .delete()
          .eq('id', courseId)
          .select();

      if (rows.isEmpty) {
        debugPrint('[PASS] DELETE ditolak oleh RLS');
      } else {
        debugPrint('[FAIL] User B berhasil menghapus data User A');
      }
    } catch (e) {
      debugPrint('[PASS] DELETE ditolak: $e');
    }
  }


}
