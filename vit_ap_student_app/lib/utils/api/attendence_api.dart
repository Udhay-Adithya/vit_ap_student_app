import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/utils/exceptions/ServerUnreachableException.dart';

class AttendanceService {
  Future<Map<String, dynamic>> fetchAndStoreAttendanceData(
      String username, String password, String semSubID) async {
    const r = RetryOptions(maxAttempts: 5);
    try {
      Uri url = Uri.parse('https://vit-ap.fly.dev/login/attendance');
      Map<String, String> placeholder = {
        'username': username,
        'password': password,
        'semSubID': semSubID,
      };
      final http.Response response = await r.retry(
        () async {
          final response = await http.post(
            url,
            body: placeholder,
            headers: {"API-KEY": dotenv.env['API_KEY']!},
          );
          print(response.body);
          if (response.statusCode == 404) {
            throw ServerUnreachableException(
                '404 Not Found', response.statusCode);
          }

          return response;
        },
        retryIf: (e) => e is ServerUnreachableException && e.statusCode == 404,
      );

      if (response.statusCode == 200) {
        dynamic data = jsonDecode(response.body)['attendance'];
        print('Fetched Data: $data');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('attendance', jsonEncode(data));

        return data;
      } else {
        print(response.body);
        return {};
      }
    } catch (e) {
      print("Error $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> getStoredAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('attendance');

    if (jsonData != null) {
      return json.decode(jsonData);
    } else {
      throw Exception('No data found');
    }
  }
}

final attendanceServiceProvider = Provider((ref) => AttendanceService());
