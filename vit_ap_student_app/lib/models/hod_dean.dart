class HodAndDeanInfo {
  String cabinNumber;
  String designation;
  String emailId;
  String imageBase64;
  String title;

  HodAndDeanInfo({
    required this.cabinNumber,
    required this.designation,
    required this.emailId,
    required this.imageBase64,
    required this.title,
  });

  HodAndDeanInfo copyWith({
    String? cabinNumber,
    String? designation,
    String? emailId,
    String? imageBase64,
    String? title,
  }) =>
      HodAndDeanInfo(
        cabinNumber: cabinNumber ?? this.cabinNumber,
        designation: designation ?? this.designation,
        emailId: emailId ?? this.emailId,
        imageBase64: imageBase64 ?? this.imageBase64,
        title: title ?? this.title,
      );

  factory HodAndDeanInfo.fromJson(Map<String, dynamic> json) => HodAndDeanInfo(
        cabinNumber: json["Cabin Number"],
        designation: json["Designation"],
        emailId: json["Email ID"],
        imageBase64: json["image_base64"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "Cabin Number": cabinNumber,
        "Designation": designation,
        "Email ID": emailId,
        "image_base64": imageBase64,
        "title": title,
      };
}
