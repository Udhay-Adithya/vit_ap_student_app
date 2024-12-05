// lib/features/student_profile/data/datasources/student_local_datasource.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class StudentLocalDataSource {
  /// Gets the last student data that was cached
  Future<StudentModel> getLastStudentData();

  /// Caches the student data
  Future<void> cacheStudentData(StudentModel studentData);

  /// Clears cached student data
  Future<void> clearCachedStudentData();
}

class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  final SharedPreferences sharedPreferences;

  StudentLocalDataSourceImpl({required this.sharedPreferences});

  static const String CACHED_STUDENT_DATA = 'CACHED_STUDENT_DATA';

  @override
  Future<void> cacheStudentData(StudentModel studentData) {
    return sharedPreferences.setString(
        CACHED_STUDENT_DATA, json.encode(studentData.toJson()));
  }

  @override
  Future<StudentModel> getLastStudentData() {
    final jsonString = sharedPreferences.getString(CACHED_STUDENT_DATA);
    if (jsonString != null) {
      return Future.value(StudentModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException(message: 'No cached student data found');
    }
  }

  @override
  Future<void> clearCachedStudentData() {
    return sharedPreferences.remove(CACHED_STUDENT_DATA);
  }
}
