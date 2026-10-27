//2415051010_I Gusti Ayu Agung Gita Udiani
class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });
  factory Course.fromJson(Map<String, dynamic> json) {
    final int? courseId = json['id'] as int?;
    return Course(
      id: courseId,
      code: json['code'] as String? ??
          'API${courseId ?? 0}',
      title: json['title'] as String? ?? 'Untitled Course',
      credits: json['credits'] as int? ?? 2,
      status: json['status'] as String? ?? 'planned',
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };
}
