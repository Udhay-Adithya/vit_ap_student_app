class ExamSchedule {
  Map<String, Cat1> cat1;
  Map<String, Cat1> cat2;
  Map<String, Cat1> fat;

  ExamSchedule({
    required this.cat1,
    required this.cat2,
    required this.fat,
  });

  ExamSchedule copyWith({
    Map<String, Cat1>? cat1,
    Map<String, Cat1>? cat2,
    Map<String, Cat1>? fat,
  }) =>
      ExamSchedule(
        cat1: cat1 ?? this.cat1,
        cat2: cat2 ?? this.cat2,
        fat: fat ?? this.fat,
      );

  factory ExamSchedule.fromJson(Map<String, dynamic> json) => ExamSchedule(
        cat1: Map.from(json["cat_1"])
            .map((k, v) => MapEntry<String, Cat1>(k, Cat1.fromJson(v))),
        cat2: Map.from(json["cat_2"])
            .map((k, v) => MapEntry<String, Cat1>(k, Cat1.fromJson(v))),
        fat: Map.from(json["fat"])
            .map((k, v) => MapEntry<String, Cat1>(k, Cat1.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "cat_1": Map.from(cat1)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "cat_2": Map.from(cat2)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "fat": Map.from(fat)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class Cat1 {
  String courseCode;
  String courseTitle;
  String date;
  String examTime;
  String registrationNumber;
  String reportingTime;
  String seatLocation;
  String seatNumber;
  String session;
  String slot;
  String type;
  String venue;

  Cat1({
    required this.courseCode,
    required this.courseTitle,
    required this.date,
    required this.examTime,
    required this.registrationNumber,
    required this.reportingTime,
    required this.seatLocation,
    required this.seatNumber,
    required this.session,
    required this.slot,
    required this.type,
    required this.venue,
  });

  Cat1 copyWith({
    String? courseCode,
    String? courseTitle,
    String? date,
    String? examTime,
    String? registrationNumber,
    String? reportingTime,
    String? seatLocation,
    String? seatNumber,
    String? session,
    String? slot,
    String? type,
    String? venue,
  }) =>
      Cat1(
        courseCode: courseCode ?? this.courseCode,
        courseTitle: courseTitle ?? this.courseTitle,
        date: date ?? this.date,
        examTime: examTime ?? this.examTime,
        registrationNumber: registrationNumber ?? this.registrationNumber,
        reportingTime: reportingTime ?? this.reportingTime,
        seatLocation: seatLocation ?? this.seatLocation,
        seatNumber: seatNumber ?? this.seatNumber,
        session: session ?? this.session,
        slot: slot ?? this.slot,
        type: type ?? this.type,
        venue: venue ?? this.venue,
      );

  factory Cat1.fromJson(Map<String, dynamic> json) => Cat1(
        courseCode: json["course_code"],
        courseTitle: json["course_title"],
        date: json["date"],
        examTime: json["exam_time"],
        registrationNumber: json["registration_number"],
        reportingTime: json["reporting_time"],
        seatLocation: json["seat_location"],
        seatNumber: json["seat_number"],
        session: json["session"],
        slot: json["slot"],
        type: json["type"],
        venue: json["venue"],
      );

  Map<String, dynamic> toJson() => {
        "course_code": courseCode,
        "course_title": courseTitle,
        "date": date,
        "exam_time": examTime,
        "registration_number": registrationNumber,
        "reporting_time": reportingTime,
        "seat_location": seatLocation,
        "seat_number": seatNumber,
        "session": session,
        "slot": slot,
        "type": type,
        "venue": venue,
      };
}
