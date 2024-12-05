import 'dart:convert';

import 'attendance.dart';
import 'exam_schedule.dart';
import 'marks.dart';
import 'profile.dart';
import 'time_table.dart';

Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  Map<String, Attendance> attendance;
  ExamSchedule examSchedule;
  List<Mark> marks;
  Profile profile;
  Timetable timetable;

  Student({
    required this.attendance,
    required this.examSchedule,
    required this.marks,
    required this.profile,
    required this.timetable,
  });

  Student copyWith({
    Map<String, Attendance>? attendance,
    ExamSchedule? examSchedule,
    List<Mark>? marks,
    Profile? profile,
    Timetable? timetable,
  }) =>
      Student(
        attendance: attendance ?? this.attendance,
        examSchedule: examSchedule ?? this.examSchedule,
        marks: marks ?? this.marks,
        profile: profile ?? this.profile,
        timetable: timetable ?? this.timetable,
      );

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        attendance: Map.from(json["attendance"]).map(
            (k, v) => MapEntry<String, Attendance>(k, Attendance.fromJson(v))),
        examSchedule: ExamSchedule.fromJson(json["exam_schedule"]),
        marks: List<Mark>.from(json["marks"].map((x) => Mark.fromJson(x))),
        profile: Profile.fromJson(json["profile"]),
        timetable: Timetable.fromJson(json["timetable"]),
      );

  Map<String, dynamic> toJson() => {
        "attendance": Map.from(attendance)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "exam_schedule": examSchedule.toJson(),
        "marks": List<dynamic>.from(marks.map((x) => x.toJson())),
        "profile": profile.toJson(),
        "timetable": timetable.toJson(),
      };
}
