import 'dart:convert';

import '../../../../models/attendance.dart';
import '../../../../models/exam_schedule.dart';
import '../../../../models/marks.dart';
import '../../../../models/profile.dart';
import '../../../../models/time_table.dart';

StudentModel StudentModelFromJson(String str) => StudentModel.fromJson(json.decode(str));

String StudentModelToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
  Map<String, Attendance> attendance;
  ExamSchedule examSchedule;
  List<Mark> marks;
  Profile profile;
  Timetable timetable;

  StudentModel({
    required this.attendance,
    required this.examSchedule,
    required this.marks,
    required this.profile,
    required this.timetable,
  });

  StudentModel copyWith({
    Map<String, Attendance>? attendance,
    ExamSchedule? examSchedule,
    List<Mark>? marks,
    Profile? profile,
    Timetable? timetable,
  }) =>
      StudentModel(
        attendance: attendance ?? this.attendance,
        examSchedule: examSchedule ?? this.examSchedule,
        marks: marks ?? this.marks,
        profile: profile ?? this.profile,
        timetable: timetable ?? this.timetable,
      );

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
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
