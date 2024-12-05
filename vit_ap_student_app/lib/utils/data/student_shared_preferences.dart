import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/student_model.dart';

const String studentKey = "student_data";

Future<void> saveStudentToPrefs(Student student) async {
  final prefs = await SharedPreferences.getInstance();
  final studentJson = jsonEncode(student.toJson());
  prefs.setString(studentKey, studentJson);
}

Future<Student?> loadStudentFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final studentJson = prefs.getString(studentKey);
  if (studentJson != null) {
    log("Reurned Data Frrom Local Storage");
    return Student.fromJson(jsonDecode(studentJson));
  }
  return null;
}

Future<void> clearStudentPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(studentKey);
}
