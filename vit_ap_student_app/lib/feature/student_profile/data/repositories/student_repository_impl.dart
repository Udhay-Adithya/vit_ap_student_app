import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/student_remote_datasource.dart';
import '../datasources/student_local_datasource.dart';
import '../../domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;
  final StudentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  StudentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // Helper method to handle network and cache operations
  Future<Either<Failure, T>> _handleNetworkAndCache<T>(
    Future<T> Function() remoteCall,
    Future<void> Function(T)? cacheFunction,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteCall();
        if (cacheFunction != null) {
          await cacheFunction(remoteData);
        }
        return Right(remoteData);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        // Implement appropriate local data retrieval based on the data type
        // This is a placeholder and should be implemented specifically for each method
        final localData = await localDataSource.getLastStudentData();
        return Right(localData as T);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, StudentData>> fetchStudentData() {
    return _handleNetworkAndCache(
      () => remoteDataSource.fetchStudentData(),
      (data) => localDataSource.cacheStudentData(data),
    );
  }

  @override
  Future<Either<Failure, dynamic>> fetchAttendanceData() {
    return _handleNetworkAndCache(
      () => remoteDataSource.fetchAttendanceData(),
      null, // Add caching method if needed
    );
  }

  // Implement other methods similarly...
  @override
  Future<Either<Failure, dynamic>> fetchBiometricLog(String date) {
    return _handleNetworkAndCache(
      () => remoteDataSource.fetchBiometricLog(date),
      null,
    );
  }
  
  @override
  Future<Either<Failure, dynamic>> fetchExamSchedule() {
    // TODO: implement fetchExamSchedule
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, dynamic>> fetchGeneralOutingRequests() {
    // TODO: implement fetchGeneralOutingRequests
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, dynamic>> fetchMarks() {
    // TODO: implement fetchMarks
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, dynamic>> fetchPaymentDetails() {
    // TODO: implement fetchPaymentDetails
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, dynamic>> fetchTimetable() {
    // TODO: implement fetchTimetable
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, dynamic>> fetchWeekendOutingRequests() {
    // TODO: implement fetchWeekendOutingRequests
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, dynamic>> submitGeneralOuting({required String outPlace, required String purposeOfVisit, required String outingDate, required String outTime, required String inDate, required String inTime}) {
    // TODO: implement submitGeneralOuting
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, dynamic>> submitWeekendOuting({required String outPlace, required String purposeOfVisit, required String outingDate, required String outTime, required String contactNumber}) {
    // TODO: implement submitWeekendOuting
    throw UnimplementedError();
  }

  // Implement the rest of the methods following the same pattern
  // ... (fetchPaymentDetails, fetchTimetable, etc.)
}
