class GradeHistory {
  String cgpa;
  String creditsEarned;
  String creditsRegistered;

  GradeHistory({
    required this.cgpa,
    required this.creditsEarned,
    required this.creditsRegistered,
  });

  GradeHistory copyWith({
    String? cgpa,
    String? creditsEarned,
    String? creditsRegistered,
  }) =>
      GradeHistory(
        cgpa: cgpa ?? this.cgpa,
        creditsEarned: creditsEarned ?? this.creditsEarned,
        creditsRegistered: creditsRegistered ?? this.creditsRegistered,
      );

  factory GradeHistory.fromJson(Map<String, dynamic> json) => GradeHistory(
        cgpa: json["cgpa"],
        creditsEarned: json["credits_earned"],
        creditsRegistered: json["credits_registered"],
      );

  Map<String, dynamic> toJson() => {
        "cgpa": cgpa,
        "credits_earned": creditsEarned,
        "credits_registered": creditsRegistered,
      };
}
