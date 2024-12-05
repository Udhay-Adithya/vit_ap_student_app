class Mark {
  String classId;
  String courseCode;
  String courseSystem;
  String courseTitle;
  String courseType;
  List<Detail> details;
  String faculty;
  String serialNumber;
  String slot;

  Mark({
    required this.classId,
    required this.courseCode,
    required this.courseSystem,
    required this.courseTitle,
    required this.courseType,
    required this.details,
    required this.faculty,
    required this.serialNumber,
    required this.slot,
  });

  Mark copyWith({
    String? classId,
    String? courseCode,
    String? courseSystem,
    String? courseTitle,
    String? courseType,
    List<Detail>? details,
    String? faculty,
    String? serialNumber,
    String? slot,
  }) =>
      Mark(
        classId: classId ?? this.classId,
        courseCode: courseCode ?? this.courseCode,
        courseSystem: courseSystem ?? this.courseSystem,
        courseTitle: courseTitle ?? this.courseTitle,
        courseType: courseType ?? this.courseType,
        details: details ?? this.details,
        faculty: faculty ?? this.faculty,
        serialNumber: serialNumber ?? this.serialNumber,
        slot: slot ?? this.slot,
      );

  factory Mark.fromJson(Map<String, dynamic> json) => Mark(
        classId: json["class_id"],
        courseCode: json["course_code"],
        courseSystem: json["course_system"],
        courseTitle: json["course_title"],
        courseType: json["course_type"],
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
        faculty: json["faculty"],
        serialNumber: json["serial_number"],
        slot: json["slot"],
      );

  Map<String, dynamic> toJson() => {
        "class_id": classId,
        "course_code": courseCode,
        "course_system": courseSystem,
        "course_title": courseTitle,
        "course_type": courseType,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "faculty": faculty,
        "serial_number": serialNumber,
        "slot": slot,
      };
}

class Detail {
  String markTitle;
  String maxMark;
  String remark;
  String scoredMark;
  String serialNumber;
  String status;
  String weightage;
  String weightageMark;

  Detail({
    required this.markTitle,
    required this.maxMark,
    required this.remark,
    required this.scoredMark,
    required this.serialNumber,
    required this.status,
    required this.weightage,
    required this.weightageMark,
  });

  Detail copyWith({
    String? markTitle,
    String? maxMark,
    String? remark,
    String? scoredMark,
    String? serialNumber,
    String? status,
    String? weightage,
    String? weightageMark,
  }) =>
      Detail(
        markTitle: markTitle ?? this.markTitle,
        maxMark: maxMark ?? this.maxMark,
        remark: remark ?? this.remark,
        scoredMark: scoredMark ?? this.scoredMark,
        serialNumber: serialNumber ?? this.serialNumber,
        status: status ?? this.status,
        weightage: weightage ?? this.weightage,
        weightageMark: weightageMark ?? this.weightageMark,
      );

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        markTitle: json["mark_title"],
        maxMark: json["max_mark"],
        remark: json["remark"],
        scoredMark: json["scored_mark"],
        serialNumber: json["serial_number"],
        status: json["status"],
        weightage: json["weightage"],
        weightageMark: json["weightage_mark"],
      );

  Map<String, dynamic> toJson() => {
        "mark_title": markTitle,
        "max_mark": maxMark,
        "remark": remark,
        "scored_mark": scoredMark,
        "serial_number": serialNumber,
        "status": status,
        "weightage": weightage,
        "weightage_mark": weightageMark,
      };
}
