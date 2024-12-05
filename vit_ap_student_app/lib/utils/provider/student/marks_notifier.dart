import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/student_model.dart';
import '../../api/apis.dart';
import '../student_notifier.dart';

class MarksNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  MarksNotifier() : super(const AsyncValue.loading());

  Future<void> fetchMarks() async {
    state = const AsyncValue.loading();
    try {
      final response = await fetchMarksApi();
      if (response.statusCode == 200) {
        final marksData = jsonDecode(response.body);
        state = AsyncValue.data(
            List<Map<String, dynamic>>.from(marksData['marks']));
        StudentRepository().updatExamSchedule(marksData['marks']);
      } else {
        state = AsyncValue.error(
            'Failed to fetch marks: ${response.statusCode}',
            StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error('An error occurred: $e', StackTrace.current);
    }
  }

  Future<void> loadLocalMarks(Student student) async {
    if (student.marks.isNotEmpty) {
      state = AsyncValue.data(student.marks);
    } else {
      state = AsyncValue.error(
          'No marks data available locally', StackTrace.current);
    }
  }
}

final marksProvider = StateNotifierProvider<MarksNotifier,
    AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return MarksNotifier();
});
