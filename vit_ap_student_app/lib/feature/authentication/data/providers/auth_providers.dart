import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_storage_services.dart';

// Data class to hold login credentials
class LoginCredentials {
  final String regNo;
  final String password;
  final String semesterId;

  LoginCredentials(
      {required this.regNo, required this.password, required this.semesterId});
}
class AuthStateNotifier extends StateNotifier<LoginCredentials?> {
  final AuthStorageService _authStorageService;
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authStorageService, this._authRepository)
      : super(null);

  // Existing login and logout methods...

  // Method to update password
  Future<bool> updatePassword(
      {required String currentPassword,
      required String newPassword,
      required String confirmNewPassword}) async {
    // Validate current credentials
    final currentCredentials = state;
    if (currentCredentials == null) {
      throw Exception('User not logged in');
    }

    // Validate new password
    if (newPassword != confirmNewPassword) {
      throw Exception('New passwords do not match');
    }

    try {
      // Call repository method to update password
      final isUpdated = await _authRepository.updatePassword(
          regNo: currentCredentials.regNo,
          currentPassword: currentPassword,
          newPassword: newPassword,
          semesterId: currentCredentials.semesterId);

      if (isUpdated) {
        // Update stored credentials with new password
        await _authStorageService.saveLoginCredentials(
            regNo: currentCredentials.regNo,
            password: newPassword,
            semesterId: currentCredentials.semesterId);

        // Update state with new credentials
        state = LoginCredentials(
            regNo: currentCredentials.regNo,
            password: newPassword,
            semesterId: currentCredentials.semesterId);

        return true;
      }

      return false;
    } catch (e) {
      // Handle update password errors
      rethrow;
    }
  }

  // Method to update semester
  Future<bool> updateSemester(
      {required String newSemesterId, required String password}) async {
    // Validate current credentials
    final currentCredentials = state;
    if (currentCredentials == null) {
      throw Exception('User not logged in');
    }

    try {
      // Call repository method to update semester
      final isUpdated = await _authRepository.updateSemester(
          regNo: currentCredentials.regNo,
          password: password,
          newSemesterId: newSemesterId);

      if (isUpdated) {
        // Update stored credentials with new semester
        await _authStorageService.saveLoginCredentials(
            regNo: currentCredentials.regNo,
            password: currentCredentials.password,
            semesterId: newSemesterId);

        // Update state with new credentials
        state = LoginCredentials(
            regNo: currentCredentials.regNo,
            password: currentCredentials.password,
            semesterId: newSemesterId);

        return true;
      }

      return false;
    } catch (e) {
      // Handle update semester errors
      rethrow;
    }
  }
}

// Update the AuthRepository interface and implementation
abstract class AuthRepository {
  // Existing methods...

  Future<bool> updatePassword(
      {required String regNo,
      required String currentPassword,
      required String newPassword,
      required String semesterId});

  Future<bool> updateSemester(
      {required String regNo,
      required String password,
      required String newSemesterId});
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  // Existing methods...

  @override
  Future<bool> updatePassword(
      {required String regNo,
      required String currentPassword,
      required String newPassword,
      required String semesterId}) async {
    try {
      final response = await _dio.post('/update-password', data: {
        'regNo': regNo,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'semesterId': semesterId
      });

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      // Handle specific error scenarios
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw Exception('Current password is incorrect');
        }
        // Handle other specific error codes
      }
      rethrow;
    }
  }

  @override
  Future<bool> updateSemester(
      {required String regNo,
      required String password,
      required String newSemesterId}) async {
    try {
      final response = await _dio.post('/update-semester', data: {
        'regNo': regNo,
        'password': password,
        'newSemesterId': newSemesterId
      });

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      // Handle specific error scenarios
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw Exception('Invalid credentials');
        }
        // Handle other specific error codes
      }
      rethrow;
    }
  }
}