import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'student_provider.dart';

class StudentRepository {
  final StudentNotifier studentNotifier;
  final ref = ProviderContainer();

  StudentRepository()
      : studentNotifier = ProviderContainer().read(studentProvider.notifier);

  // Fetch and update timetable via API
  void updateTimetable(Map<String, dynamic> timetable) {
    studentNotifier.updateStudentTimetable(timetable);
  }

  // Update attendance after fetching from API
  void updateAttendance(Map<String, dynamic> attendance) {
    studentNotifier.updateStudentAttendance(attendance);
  }

  // Update marks after fetching from API
  void updateMarks(List<Map<String, dynamic>> marks) {
    studentNotifier.updateStudentMarks(marks);
  }

  // Update marks after fetching from API
  void updatExamSchedule(Map<String, dynamic> examSchedule) {
    studentNotifier.updateStudentExamSchedule(examSchedule);
  }

  void updatLocalStudentData(Map<String, dynamic> studentData) {
    studentNotifier.updateLocalData(studentData);
  }

  // Method to update privacy mode
  void updateIsPrivacyModeEnabled(bool isPrivacyModeEnabled) {
    studentNotifier.updateIsPrivacyModeEnabled(isPrivacyModeEnabled);
  }

  // Method to update notification preferences
  void updateIsNotificationsEnabled(bool isNotificationsEnabled) {
    studentNotifier.updateIsNotificationsEnabled(isNotificationsEnabled);
  }

  // Method to update notification delay
  void updateNotificationDelay(int notificationDelay) {
    studentNotifier.updateNotificationDelay(notificationDelay);
  }

  // Other methods like resetStudent, updateTimetable, etc.
  void resetStudent() {
    studentNotifier.resetStudent();
  }
}
