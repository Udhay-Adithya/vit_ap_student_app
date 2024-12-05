import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/student_model.dart';
import '../../api/apis.dart';
import '../student_notifier.dart';

class AttendanceNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  AttendanceNotifier() : super(const AsyncValue.loading());

  Future<void> fetchAttendance() async {
    state = const AsyncValue.loading();
    try {
      final response = await fetchAttendanceDataApi();
      if (response.statusCode == 200) {
        final attendanceData = jsonDecode(response.body);
        state = AsyncValue.data(attendanceData['attendance']);
        StudentRepository().updateAttendance(attendanceData['attendance']);
      } else {
        state = AsyncValue.error(
            'Failed to fetch attendance: ${response.statusCode}',
            StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error('An error occurred: $e', StackTrace.current);
    }
  }

  Future<void> loadLocalAttendance(Student student) async {
    if (student.attendance.isNotEmpty) {
      state = AsyncValue.data(student.attendance);
    } else {
      state = AsyncValue.error(
          'No attendance data available locally', StackTrace.current);
    }
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  return AttendanceNotifier();
});
