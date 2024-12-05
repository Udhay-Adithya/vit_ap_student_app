import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/apis.dart';
import '../student_notifier.dart';

class StudentLoginNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  StudentLoginNotifier() : super(const AsyncValue.data({}));

  Future<void> fetchStudentData(
    String regNo,
    String password,
    String semSubID,
  ) async {
    state = const AsyncValue.loading();
    try {
      final response = await fetchLoginDataApi(regNo, password, semSubID);

      if (response.statusCode == 200) {
        // Parse the response carefully
        dynamic studentData = jsonDecode(response.body);

        // Debug print
        print('Decoded Data Type: ${studentData.runtimeType}');
        print('Decoded Data Keys: ${studentData.keys}');

        // Verify it's a Map
        if (studentData is Map<String, dynamic>) {
          state = AsyncValue.data(studentData);
          StudentRepository().updatLocalStudentData(studentData);
        } else {
          state =
              AsyncValue.error('Unexpected data format', StackTrace.current);
        }
      } else {
        state = AsyncValue.error(
            'Login Failed: ${response.statusCode} : ${response.body}',
            StackTrace.current);
      }
    } catch (e, stackTrace) {
      log("Error in login: $e", stackTrace: stackTrace);
      state = AsyncValue.error('An error occurred: $e', stackTrace);
    }
  }
}

final studentLoginProvider = StateNotifierProvider<StudentLoginNotifier,
    AsyncValue<Map<String, dynamic>>>((ref) {
  return StudentLoginNotifier();
});
