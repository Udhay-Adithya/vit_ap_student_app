import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/student_model.dart';
import '../../api/apis.dart';
import '../student_notifier.dart';

class TimetableNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  TimetableNotifier() : super(const AsyncValue.loading());

  Future<void> fetchTimetable() async {
    state = const AsyncValue.loading();
    try {
      final response = await fetchTimetableApi();
      if (response.statusCode == 200) {
        final timetableData = jsonDecode(response.body);
        state = AsyncValue.data(timetableData['timetable']);
        StudentRepository().updatExamSchedule(timetableData['timetable']);
      } else {
        state = AsyncValue.error(
            'Failed to fetch timetable: ${response.statusCode}',
            StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error('An error occurred: $e', StackTrace.current);
    }
  }

  Future<void> loadLocalTimetable(Student student) async {
    if (student.timetable.isNotEmpty) {
      state = AsyncValue.data(student.timetable);
    } else {
      state = AsyncValue.error(
          'No timetable data available locally', StackTrace.current);
    }
  }
}

final timetableProvider =
    StateNotifierProvider<TimetableNotifier, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  return TimetableNotifier();
});
