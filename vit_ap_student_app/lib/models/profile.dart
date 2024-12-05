import 'grade_history.dart';
import 'hod_dean.dart';
import 'montor.dart';

class Profile {
  String applicationNumber;
  String bloodGroup;
  String dob;
  String email;
  String gender;
  GradeHistory gradeHistory;
  HodAndDeanInfo hodAndDeanInfo;
  MentorDetails mentorDetails;
  String pfp;
  String studentName;

  Profile({
    required this.applicationNumber,
    required this.bloodGroup,
    required this.dob,
    required this.email,
    required this.gender,
    required this.gradeHistory,
    required this.hodAndDeanInfo,
    required this.mentorDetails,
    required this.pfp,
    required this.studentName,
  });

  Profile copyWith({
    String? applicationNumber,
    String? bloodGroup,
    String? dob,
    String? email,
    String? gender,
    GradeHistory? gradeHistory,
    HodAndDeanInfo? hodAndDeanInfo,
    MentorDetails? mentorDetails,
    String? pfp,
    String? studentName,
  }) =>
      Profile(
        applicationNumber: applicationNumber ?? this.applicationNumber,
        bloodGroup: bloodGroup ?? this.bloodGroup,
        dob: dob ?? this.dob,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        gradeHistory: gradeHistory ?? this.gradeHistory,
        hodAndDeanInfo: hodAndDeanInfo ?? this.hodAndDeanInfo,
        mentorDetails: mentorDetails ?? this.mentorDetails,
        pfp: pfp ?? this.pfp,
        studentName: studentName ?? this.studentName,
      );

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        applicationNumber: json["application_number"],
        bloodGroup: json["blood_group"],
        dob: json["dob"],
        email: json["email"],
        gender: json["gender"],
        gradeHistory: GradeHistory.fromJson(json["grade_history"]),
        hodAndDeanInfo: HodAndDeanInfo.fromJson(json["hod_and_dean_info"]),
        mentorDetails: MentorDetails.fromJson(json["mentor_details"]),
        pfp: json["pfp"],
        studentName: json["student_name"],
      );

  Map<String, dynamic> toJson() => {
        "application_number": applicationNumber,
        "blood_group": bloodGroup,
        "dob": dob,
        "email": email,
        "gender": gender,
        "grade_history": gradeHistory.toJson(),
        "hod_and_dean_info": hodAndDeanInfo.toJson(),
        "mentor_details": mentorDetails.toJson(),
        "pfp": pfp,
        "student_name": studentName,
      };
}
