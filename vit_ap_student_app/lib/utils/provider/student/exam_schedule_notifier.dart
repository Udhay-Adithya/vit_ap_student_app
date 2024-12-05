import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/student_model.dart';
import '../../api/apis.dart';
import '../student_notifier.dart';

class ExamScheduleNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  ExamScheduleNotifier() : super(const AsyncValue.loading());

  Future<void> fetchExamSchedule() async {
    state = const AsyncValue.loading();
    try {
      final response = await fetchExamScheduleApi();
      if (response.statusCode == 200) {
        final examData = jsonDecode(response.body);
        state = AsyncValue.data(examData['exam_schedule']);
        StudentRepository().updatExamSchedule(examData['exam_schedule']);
      } else {
        state = AsyncValue.error(
            'Failed to exam schedule: ${response.statusCode}',
            StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error('An error occurred: $e', StackTrace.current);
    }
  }

  Future<void> loadLocalExamSchedule(Student student) async {
    if (student.examSchedule.isNotEmpty) {
      state = AsyncValue.data(student.examSchedule);
    } else {
      state = AsyncValue.error(
          'No exams schedule data available locally', StackTrace.current);
    }
  }
}

final examScheduleProvider = StateNotifierProvider<ExamScheduleNotifier,
    AsyncValue<Map<String, dynamic>>>((ref) {
  return ExamScheduleNotifier();
});
