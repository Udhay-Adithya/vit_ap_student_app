class Attendance {
  String attendancePercentage;
  String attendedClasses;
  String courseCode;
  String courseName;
  String courseType;
  String totalClasses;

  Attendance({
    required this.attendancePercentage,
    required this.attendedClasses,
    required this.courseCode,
    required this.courseName,
    required this.courseType,
    required this.totalClasses,
  });

  Attendance copyWith({
    String? attendancePercentage,
    String? attendedClasses,
    String? courseCode,
    String? courseName,
    String? courseType,
    String? totalClasses,
  }) =>
      Attendance(
        attendancePercentage: attendancePercentage ?? this.attendancePercentage,
        attendedClasses: attendedClasses ?? this.attendedClasses,
        courseCode: courseCode ?? this.courseCode,
        courseName: courseName ?? this.courseName,
        courseType: courseType ?? this.courseType,
        totalClasses: totalClasses ?? this.totalClasses,
      );

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        attendancePercentage: json["attendance_percentage"],
        attendedClasses: json["attended_classes"],
        courseCode: json["course_code"],
        courseName: json["course_name"],
        courseType: json["course_type"],
        totalClasses: json["total_classes"],
      );

  Map<String, dynamic> toJson() => {
        "attendance_percentage": attendancePercentage,
        "attended_classes": attendedClasses,
        "course_code": courseCode,
        "course_name": courseName,
        "course_type": courseType,
        "total_classes": totalClasses,
      };
}
