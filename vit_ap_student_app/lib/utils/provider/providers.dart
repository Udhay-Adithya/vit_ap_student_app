import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/widgets/custom/my_snackbar.dart';
import 'package:vit_ap_student_app/utils/state/login_state.dart';
import 'package:vit_ap_student_app/pages/features/bottom_navigation_bar.dart';
import '../api/apis.dart';

// Login Notifier
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState());

  Future<void> login(String username, String password, String semSubID,
      BuildContext context) async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );

    final secStorage = new FlutterSecureStorage(aOptions: _getAndroidOptions());

    final prefs = await SharedPreferences.getInstance();
    log('Accessed Provider');
    state = state.copyWith(status: LoginStatus.loading);
    try {
      final response = await fetchLoginDataApi(username, password, semSubID);
      log('Got response');
      log('$response.');
      if (response.statusCode == 200) {
        log('Status Code: ${response.statusCode}');
        Map<String, dynamic> data = jsonDecode(response.body);
        await prefs.setString('username', username);
        await secStorage.write(key: 'password', value: password);
        await prefs.setString('semSubID', semSubID);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('timetable', jsonEncode(data['timetable']));
        await prefs.setString('attendance', jsonEncode(data['attendance']));
        await prefs.setString('profile', jsonEncode(data['profile']));
        await prefs.setString(
            'exam_schedule', jsonEncode(data['exam_schedule']));
        log('Exam Data : ${data['exam_schedule']}');

        state = state.copyWith(status: LoginStatus.success);
        final snackBar = MySnackBar(
          title: 'Success!',
          message: 'Logged in successfully',
          contentType: ContentType.success,
        ).build(context);

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar as SnackBar);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyBNB()),
          (Route<dynamic> route) => false,
        );
      } else if (response.statusCode == 401) {
        Navigator.pop(context);
        state = state.copyWith(status: LoginStatus.failure);
        final snackBar = MySnackBar(
          title: 'Oops!',
          message:
              'Login failed : ${jsonDecode(response.body)["error"]["login"]}',
          contentType: ContentType.failure,
        ).build(context);

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar as SnackBar);
      } else {
        Navigator.pop(context);
        state = state.copyWith(status: LoginStatus.failure);
        log("Login failed : ${response.body}");
        final snackBar = MySnackBar(
          title: 'Oops!',
          message: 'Login failed : ${response.body}',
          contentType: ContentType.failure,
        ).build(context);

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar as SnackBar);
      }
    } catch (e) {
      state = state.copyWith(status: LoginStatus.failure);
      log('An error occurred: $e');
      final snackBar = MySnackBar(
        title: 'Error!',
        message: 'An error occurred: $e',
        contentType: ContentType.failure,
      ).build(context);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar as SnackBar);
    }
  }
}

// Login Provider
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

// Timetable Provider
final timetableProvider =
    StateNotifierProvider<TimetableNotifier, Map<String, dynamic>>((ref) {
  return TimetableNotifier();
});

class TimetableNotifier extends StateNotifier<Map<String, dynamic>> {
  TimetableNotifier() : super({}) {
    loadTimetable();
  }

  Future<void> loadTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timetableString = prefs.getString('timetable');
    if (timetableString != null) {
      Map<String, dynamic> timetableMap = json.decode(timetableString);
      state = timetableMap;
    } else {
      state = {};
    }
  }

  Future<void> updateTimetable(Map<String, dynamic> newTimetable) async {
    state = newTimetable;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String timetableString = json.encode(newTimetable);
    await prefs.setString('timetable', timetableString);
  }
}

// Payment Provider
final paymentProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  await fetchPaymentDetailsApi();
  final prefs = await SharedPreferences.getInstance();
  final paymentString = prefs.getString('payments') ?? '';
  if (paymentString.isNotEmpty) {
    return json.decode(paymentString);
  }
  return {};
});

//Privacy Mode Provider
class PrivacyModeNotifier extends StateNotifier<bool> {
  PrivacyModeNotifier() : super(false) {
    _togglePrivacyModeState();
  }

  Future<void> _togglePrivacyModeState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isPrivacyModeEnabled') ?? true; // Default to true
  }

  void togglePrivacyMode(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPrivacyModeEnabled', value);
  }
}

final privacyModeProvider = StateNotifierProvider<PrivacyModeNotifier, bool>(
    (ref) => PrivacyModeNotifier());

// General Outing Provider
final generalOutingProvider = Provider.autoDispose<
    void Function(
        BuildContext, String, String, String, String, String, String)>(
  (ref) {
    return (context, placeOfVisit, purposeOfVisit, outingDate, outTime, inDate,
        inTime) async {
      try {
        dynamic res = await postGeneralOutingFormApi(
            placeOfVisit, purposeOfVisit, outingDate, outTime, inDate, inTime);

        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message: '$res',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      } catch (e) {
        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Failed to submit outing form: $e',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    };
  },
);

// Weekend Outing Provider
final weekendOutingProvider = Provider.autoDispose<
    void Function(BuildContext, String, String, String, String, String)>(
  (ref) {
    return (
      context,
      placeOfVisit,
      purposeOfVisit,
      outingDate,
      outTime,
      contactNumber,
    ) async {
      try {
        dynamic res = await postWeekendOutingFormApi(
            placeOfVisit, purposeOfVisit, outingDate, outTime, contactNumber);

        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message: '$res',
            contentType: ContentType.success,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      } catch (e) {
        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: 'Failed to submit outing form: $e',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    };
  },
);

// Weekend outing requests history provider
final weekendOutingRequestsProvider = FutureProvider<dynamic>((ref) async {
  return fetchWeekendOutingRequestsApi();
});

// General outing requests history provider
final generalOutingRequestsProvider = FutureProvider<dynamic>((ref) async {
  return fetchGeneralOutingRequestsApi();
});
