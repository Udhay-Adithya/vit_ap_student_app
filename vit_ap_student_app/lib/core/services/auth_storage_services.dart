// core/services/auth_storage_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Keys for secure storage
  static const _regNoKey = 'registration_number';
  static const _passwordKey = 'user_password';
  static const _semesterKey = 'semester_id';

  // Save login credentials
  Future<void> saveLoginCredentials(
      {required String regNo,
      required String password,
      required String semesterId}) async {
    await _secureStorage.write(key: _regNoKey, value: regNo);
    await _secureStorage.write(key: _passwordKey, value: password);
    await _secureStorage.write(key: _semesterKey, value: semesterId);
  }

  // Retrieve credentials
  Future<Map<String, String?>> getLoginCredentials() async {
    return {
      'regNo': await _secureStorage.read(key: _regNoKey),
      'password': await _secureStorage.read(key: _passwordKey),
      'semesterId': await _secureStorage.read(key: _semesterKey)
    };
  }

  // Clear credentials (for logout)
  Future<void> clearCredentials() async {
    await _secureStorage.deleteAll();
  }

  // Check if user is logged in
  Future<bool> get isLoggedIn async {
    final regNo = await _secureStorage.read(key: _regNoKey);
    return regNo != null;
  }
}

// Provider for AuthStorageService
final authStorageServiceProvider = Provider<AuthStorageService>((ref) {
  return AuthStorageService();
});
