import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/student_model.dart';
import '../data/student_shared_preferences.dart';
import 'student/attendance_notifier.dart';
import 'student/exam_schedule_notifier.dart';
import 'student/marks_notifier.dart';

// Main Notifier for managing the full Student state
class StudentNotifier extends StateNotifier<Student> {
  StudentNotifier()
      : super(Student(
          regNo: '',
          password: '',
          semSubId: '',
          profileImagePath: '',
          timetable: {},
          examSchedule: {},
          attendance: {},
          marks: [],
          isNotificationsEnabled: false,
          isPrivacyModeEnabled: false,
          notificationDelay: 0,
          profile: {},
        ));

  // Initialization to load student data
  Future<void> init(WidgetRef ref) async {
    await loadStudent();
    await ref.read(attendanceProvider.notifier).loadLocalAttendance(state);
    await ref.read(marksProvider.notifier).loadLocalMarks(state);
    await ref.read(examScheduleProvider.notifier).loadLocalExamSchedule(state);
    log("Initialized student data");
  }

  // Method to load student data from preferences
  Future<void> loadStudent() async {
    final savedStudent = await loadStudentFromPrefs();
    if (savedStudent != null) {
      state = savedStudent;
      log("Loaded Student: ${state.toString()}");
    }
  }

  // Method to update timetable
  void updateStudentTimetable(Map<String, dynamic> timetable) {
    state = state.copyWith(timetable: timetable);
    saveStudentToPrefs(state);
  }

  // Method to update attendance
  void updateStudentAttendance(Map<String, dynamic> attendance) {
    state = state.copyWith(attendance: attendance);
    saveStudentToPrefs(state);
  }

  // Method to update attendance
  void updateStudentMarks(List<Map<String, dynamic>> marks) {
    state = state.copyWith(marks: marks);
    saveStudentToPrefs(state);
  }

  // Method to update attendance
  void updateStudentExamSchedule(Map<String, dynamic> examSchedule) {
    state = state.copyWith(examSchedule: examSchedule);
    saveStudentToPrefs(state);
  }

  // Method to update notification settings
  void updateIsNotificationsEnabled(bool isNotificationsEnabled) {
    state = state.copyWith(isNotificationsEnabled: isNotificationsEnabled);
    saveStudentToPrefs(state);
  }

  // Method to update privacy mode
  void updateIsPrivacyModeEnabled(bool isPrivacyModeEnabled) {
    state = state.copyWith(isPrivacyModeEnabled: isPrivacyModeEnabled);
    saveStudentToPrefs(state);
  }

  // Method to update notification delay
  void updateNotificationDelay(int notificationDelay) {
    state = state.copyWith(notificationDelay: notificationDelay);
    saveStudentToPrefs(state);
  }

  // Update the entire Student state locally
  void updateLocalData(Map<String, dynamic> studentData) {
    state = state.copyWith(
      timetable: studentData['timetable'],
      attendance: studentData['attendance'],
      profile: studentData['profile'],
      marks: studentData['marks'],
      examSchedule: studentData['exam_schedule'],
    );
    saveStudentToPrefs(state);
  }

  // Reset student state to default
  void resetStudent() {
    state = Student(
      password: '',
      regNo: '',
      semSubId: '',
      profileImagePath: '',
      timetable: {},
      examSchedule: {},
      attendance: {},
      marks: [],
      isNotificationsEnabled: false,
      isPrivacyModeEnabled: false,
      notificationDelay: 0,
      profile: {},
    );
    saveStudentToPrefs(state);
  }
}

final studentProvider = StateNotifierProvider<StudentNotifier, Student>((ref) {
  return StudentNotifier();
});
