import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchBiometricLog(
    String username, String password, String date) async {
  try {
    Uri url = Uri.parse('https://vit-ap.fly.dev/login/biometric');
    Map<String, String> placeholder = {
      'username': username,
      'password': password,
      'date': date,
    };
    http.Response response = await http.post(
      url,
      body: placeholder,
      headers: {"API-KEY": dotenv.env['API_KEY']!},
    );
    print(response.body);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Decode the JSON response body
      Map<String, dynamic> data = jsonDecode(response.body);
      // Access the biometric_log field
      return data["biometric_log"];
    } else {
      print(response.body);
      print('Failed to load data');
      return {};
    }
  } catch (e) {
    print("Error $e");
    return {};
  }
}
