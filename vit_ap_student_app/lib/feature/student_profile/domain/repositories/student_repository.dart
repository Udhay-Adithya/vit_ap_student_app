import 'package:dartz/dartz.dart';
import '../../domain/entities/student_entity.dart';
import '../../../../core/error/failures.dart';

abstract class StudentRepository {
  Future<Either<Failure, StudentData>> fetchStudentData();
  Future<Either<Failure, AttendanceData>> fetchAttendanceData();
  Future<Either<Failure, dynamic>> fetchBiometricLog(String date);
  Future<Either<Failure, dynamic>> fetchPaymentDetails();
  Future<Either<Failure, dynamic>> fetchTimetable();
  Future<Either<Failure, dynamic>> fetchMarks();
  Future<Either<Failure, dynamic>> fetchExamSchedule();
  Future<Either<Failure, dynamic>> submitGeneralOuting({
    required String outPlace,
    required String purposeOfVisit,
    required String outingDate,
    required String outTime,
    required String inDate,
    required String inTime,
  });
  Future<Either<Failure, dynamic>> submitWeekendOuting({
    required String outPlace,
    required String purposeOfVisit,
    required String outingDate,
    required String outTime,
    required String contactNumber,
  });
  Future<Either<Failure, dynamic>> fetchWeekendOutingRequests();
  Future<Either<Failure, dynamic>> fetchGeneralOutingRequests();
}
