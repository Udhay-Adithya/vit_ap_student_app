import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/apis.dart';

class BiometricNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  BiometricNotifier() : super(const AsyncValue.loading());

  Future<void> fetchBiometricLog(String date) async {
    state = const AsyncValue.loading();
    try {
      final response = await fetchBiometricLogApi(date);
      if (response.statusCode == 200) {
        final biometricData = jsonDecode(response.body);
        state = AsyncValue.data(Map<String, dynamic>.from(biometricData));
      } else {
        state = AsyncValue.error(
            'Failed to fetch biometrics: ${response.statusCode}',
            StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error('An error occurred: $e', StackTrace.current);
    }
  }
}

final biometricProvider =
    StateNotifierProvider<BiometricNotifier, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  return BiometricNotifier();
});
