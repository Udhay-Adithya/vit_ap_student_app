import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../authentication/data/providers/auth_providers.dart';
import '../models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<StudentModel> fetchStudentData();
  Future<dynamic> fetchAttendanceData();
  Future<dynamic> fetchBiometricLog(String date);
  Future<dynamic> fetchPaymentDetails();
  Future<dynamic> fetchTimetable();
  Future<dynamic> fetchMarks();
  Future<dynamic> fetchExamSchedule();
  Future<dynamic> submitGeneralOuting({
    required String outPlace,
    required String purposeOfVisit,
    required String outingDate,
    required String outTime,
    required String inDate,
    required String inTime,
  });
  Future<dynamic> submitWeekendOuting({
    required String outPlace,
    required String purposeOfVisit,
    required String outingDate,
    required String outTime,
    required String contactNumber,
  });
  Future<dynamic> fetchWeekendOutingRequests();
  Future<dynamic> fetchGeneralOutingRequests();
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final DioClient dioClient;
  final AuthStateNotifier authStateNotifier;

  StudentRemoteDataSourceImpl({
    required this.dioClient,
    required this.authStateNotifier,
  });

  // Helper method to get credentials
  Map<String, dynamic> _getCredentials() {
    final credentials = authStateNotifier.state;
    if (credentials == null) {
      throw ServerException(message: 'Not logged in');
    }
    return {
      'regNo': credentials.regNo,
      'semesterId': credentials.semesterId,
    };
  }

  @override
  Future<StudentModel> fetchStudentData() async {
    try {
      final credentials = _getCredentials();
      final response = await dioClient.dio.get(
        '/login/getalldata',
        queryParameters: credentials,
      );
      return StudentModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> fetchAttendanceData() async {
    try {
      final credentials = _getCredentials();
      final response = await dioClient.dio.get(
        '/login/attendance',
        queryParameters: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> fetchBiometricLog(String date) async {
    try {
      final credentials = _getCredentials();
      credentials['date'] = date;
      final response = await dioClient.dio.get(
        '/login/biometric',
        queryParameters: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> fetchPaymentDetails() async {
    try {
      final credentials = _getCredentials();
      final response = await dioClient.dio.get(
        '/login/payments',
        queryParameters: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> fetchTimetable() async {
    try {
      final credentials = _getCredentials();
      final response = await dioClient.dio.get(
        '/login/timetable',
        queryParameters: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> submitGeneralOuting({
    required String outPlace,
    required String purposeOfVisit,
    required String outingDate,
    required String outTime,
    required String inDate,
    required String inTime,
  }) async {
    try {
      final credentials = _getCredentials();
      credentials.addAll({
        'outPlace': outPlace,
        'purposeOfVisit': purposeOfVisit,
        'outingDate': outingDate,
        'outTime': outTime,
        'inDate': inDate,
        'inTime': inTime,
      });

      final response = await dioClient.dio.post(
        '/login/generaloutingform',
        data: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> submitWeekendOuting({
    required String outPlace,
    required String purposeOfVisit,
    required String outingDate,
    required String outTime,
    required String contactNumber,
  }) async {
    try {
      final credentials = _getCredentials();
      credentials.addAll({
        'outPlace': outPlace,
        'purposeOfVisit': purposeOfVisit,
        'outingDate': outingDate,
        'outTime': outTime,
        'contactNumber': contactNumber,
      });

      final response = await dioClient.dio.post(
        '/login/weekendoutingform',
        data: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> fetchWeekendOutingRequests() async {
    try {
      final credentials = _getCredentials();
      final response = await dioClient.dio.get(
        '/login/weekendoutingrequests',
        queryParameters: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> fetchGeneralOutingRequests() async {
    try {
      final credentials = _getCredentials();
      final response = await dioClient.dio.get(
        '/login/generaloutingrequests',
        queryParameters: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> fetchMarks() async {
    try {
      final credentials = _getCredentials();
      final response = await dioClient.dio.get(
        '/login/marks',
        queryParameters: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }

  @override
  Future<dynamic> fetchExamSchedule() async {
    try {
      final credentials = _getCredentials();
      final response = await dioClient.dio.get(
        '/login/examschedule',
        queryParameters: credentials,
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }
}
