import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/utils/exceptions/CaptchaException.dart';
import 'package:vit_ap_student_app/utils/exceptions/ServerUnreachableException.dart';

class StudentRepository {
  Future<Map<String, String>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );

    final secStorage = new FlutterSecureStorage(aOptions: _getAndroidOptions());
    String password = await secStorage.read(key: 'password') ?? '';
    if (password == '') {
      log("No password found");
    }
    return {
      'username': prefs.getString('username')!,
      'password': password,
      'semSubID': prefs.getString('semSubID')!,
    };
  }

  Future<http.Response> makeApiRequest(
    String endpoint,
    Map<String, String> body,
  ) async {
    const r = RetryOptions(maxAttempts: 5);
    try {
      Uri url = Uri.parse('https://vit-ap.fly.dev/$endpoint');
      final http.Response response = await r.retry(
        () async {
          final response = await http.post(
            url,
            body: body,
            headers: {"API-KEY": dotenv.env['API_KEY']!},
          );
          if (response.statusCode == 404) {
            log('Status 404 ${response.body}');
            throw ServerUnreachableException(
                '404 Not Found', response.statusCode);
          }
          if (response.statusCode == 401 &&
              jsonDecode(response.body)["error"]["login"] ==
                  "Invalid Captcha") {
            log('Status 401 ${response.body}');
            throw InvalidCaptchaException(
                'Invalid Captcha', response.statusCode);
          }
          return response;
        },
        retryIf: (e) =>
            e is ServerUnreachableException || e is InvalidCaptchaException,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        log("Login response in not 200 error : ${response.body}");
        return response;
      }
    } catch (e) {
      log("Came to try catch Error $e");
      return http.Response('{error : $e}', 500);
    }
  }

  Future<http.Response> makeLoginRequest(
    String endpoint,
    Map<String, String> body,
  ) async {
    const r = RetryOptions(maxAttempts: 5);
    debugPrint('Came to API ${dotenv.env['API_KEY']!}');
    try {
      Uri url = Uri.parse('https://vit-ap.fly.dev/$endpoint');
      final http.Response response = await r.retry(
        () async {
          final response = await http.post(
            url,
            body: body,
            headers: {"API-KEY": dotenv.env['API_KEY']!},
          );
          if (response.statusCode == 404) {
            throw ServerUnreachableException(
                '404 Not Found', response.statusCode);
          }
          if (response.statusCode == 401 &&
              jsonDecode(response.body)["error"]["login"] ==
                  "Invalid Captcha") {
            throw InvalidCaptchaException(
                'Invalid Captcha', response.statusCode);
          }

          return response;
        },
        retryIf: (e) =>
            e is ServerUnreachableException || e is InvalidCaptchaException,
      );

      if (response.statusCode == 200) {
        print(response.body);
        return response;
      } else {
        print(response.body);
      }

      return response;
    } catch (e) {
      print("Error $e");
      return http.Response('{}', 500); // Return a default error response
    }
  }

// Attendance API

  Future<http.Response> fetchAttendanceDataApi() async {
    Map<String, String> credentials = await getCredentials();

    return await makeApiRequest('login/attendance', credentials);
  }

// Biometric API
  Future<http.Response> fetchBiometricLogApi(String date) async {
    Map<String, String> credentials = await getCredentials();
    credentials['date'] = date;
    return await makeApiRequest('login/biometric', credentials);
  }

// Login API
  Future fetchLoginDataApi(
      String regNo, String password, String semSubID) async {
    Map<String, String> credentials = {
      'username': regNo,
      'password': password,
      'semSubID': semSubID,
    };

    // Add detailed logging
    log('Attempting login with credentials: $credentials');

    final response = await makeLoginRequest('login/getalldata', credentials);

    // Log full response details
    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');
    log('Response Body Type: ${response.body.runtimeType}');

    return response;
  }

// Payments API
  Future<http.Response> fetchPaymentDetailsApi() async {
    Map<String, String> credentials = await getCredentials();
    final prefs = await SharedPreferences.getInstance();
    credentials['applno'] =
        jsonDecode(prefs.getString('profile')!)['application_number'];

    return await makeApiRequest('login/payments', credentials);
  }

// Timetable API
  Future<http.Response> fetchTimetableApi() async {
    Map<String, String> credentials = await getCredentials();
    return await makeApiRequest('login/timetable', credentials);
  }

// General Outing API
  Future<http.Response> postGeneralOutingFormApi(
      String outPlace,
      String purposeOfVisit,
      String outingDate,
      String outTime,
      String inDate,
      String inTime) async {
    Map<String, String> credentials = await getCredentials();
    credentials['outPlace'] = outPlace;
    credentials['purposeOfVisit'] = purposeOfVisit;
    credentials['outingDate'] = outingDate;
    credentials['outTime'] = outTime;
    credentials['inDate'] = inDate;
    credentials['inTime'] = inTime;

    return await makeApiRequest('login/generaloutingform', credentials);
  }

// Weekend Outing API
  Future<http.Response> postWeekendOutingFormApi(
      String outPlace,
      String purposeOfVisit,
      String outingDate,
      String outTime,
      String contactNumber) async {
    Map<String, String> credentials = await getCredentials();
    credentials['outPlace'] = outPlace;
    credentials['purposeOfVisit'] = purposeOfVisit;
    credentials['outingDate'] = outingDate;
    credentials['outTime'] = outTime;
    credentials['contactNumber'] = contactNumber;

    return await makeApiRequest('login/weekendoutingform', credentials);
  }

//Fetch Weekend outing requests history
  Future<http.Response> fetchWeekendOutingRequestsApi() async {
    Map<String, String> credentials = await getCredentials();
    return await makeApiRequest('login/weekendoutingrequests', credentials);
  }

//Fetch General outing requests history
  Future<http.Response> fetchGeneralOutingRequestsApi() async {
    Map<String, String> credentials = await getCredentials();
    return await makeApiRequest('login/generaloutingrequests', credentials);
  }

//Fetch marks
  Future<http.Response> fetchMarksApi() async {
    Map<String, String> credentials = await getCredentials();
    return await makeApiRequest('login/marks', credentials);
  }

//Fetch exam schedule
  Future<http.Response> fetchExamScheduleApi() async {
    Map<String, String> credentials = await getCredentials();
    return await makeApiRequest('login/examschedule', credentials);
  }
}
