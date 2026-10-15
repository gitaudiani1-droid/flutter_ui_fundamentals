class Course {
  final String title;
  final String code;
  final int credits;
  final String status;
  const Course({
    required this.title,
    required this.code,
    required this.credits,
    required this.status,
  });
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      title: json['title']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      credits: int.tryParse(json['credits'].toString()) ?? 0,
      status: json['status']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'code': code,
      'credits': credits,
      'status': status,
    };
  }
}
