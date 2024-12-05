class MentorDetails {
  String cabin;
  String facultyDepartment;
  String facultyDesignation;
  String facultyEmail;
  String facultyId;
  String facultyIntercom;
  String facultyMobileNumber;
  String facultyName;
  String school;

  MentorDetails({
    required this.cabin,
    required this.facultyDepartment,
    required this.facultyDesignation,
    required this.facultyEmail,
    required this.facultyId,
    required this.facultyIntercom,
    required this.facultyMobileNumber,
    required this.facultyName,
    required this.school,
  });

  MentorDetails copyWith({
    String? cabin,
    String? facultyDepartment,
    String? facultyDesignation,
    String? facultyEmail,
    String? facultyId,
    String? facultyIntercom,
    String? facultyMobileNumber,
    String? facultyName,
    String? school,
  }) =>
      MentorDetails(
        cabin: cabin ?? this.cabin,
        facultyDepartment: facultyDepartment ?? this.facultyDepartment,
        facultyDesignation: facultyDesignation ?? this.facultyDesignation,
        facultyEmail: facultyEmail ?? this.facultyEmail,
        facultyId: facultyId ?? this.facultyId,
        facultyIntercom: facultyIntercom ?? this.facultyIntercom,
        facultyMobileNumber: facultyMobileNumber ?? this.facultyMobileNumber,
        facultyName: facultyName ?? this.facultyName,
        school: school ?? this.school,
      );

  factory MentorDetails.fromJson(Map<String, dynamic> json) => MentorDetails(
        cabin: json["cabin"],
        facultyDepartment: json["faculty_department"],
        facultyDesignation: json["faculty_designation"],
        facultyEmail: json["faculty_email"],
        facultyId: json["faculty_id"],
        facultyIntercom: json["faculty_intercom"],
        facultyMobileNumber: json["faculty_mobile_number"],
        facultyName: json["faculty_name"],
        school: json["school"],
      );

  Map<String, dynamic> toJson() => {
        "cabin": cabin,
        "faculty_department": facultyDepartment,
        "faculty_designation": facultyDesignation,
        "faculty_email": facultyEmail,
        "faculty_id": facultyId,
        "faculty_intercom": facultyIntercom,
        "faculty_mobile_number": facultyMobileNumber,
        "faculty_name": facultyName,
        "school": school,
      };
}
