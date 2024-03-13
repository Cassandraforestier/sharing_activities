import 'dart:convert';
import 'package:sharing_ativities/src/features/authentication/models/authentication_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController {
  static Future<AuthenticationModel?> login(
      String name, String password) async {
    String? url = dotenv.env['BACKEND_URL'];
    try {
      final response = await http.post(
        Uri.parse("$url/api/login"),
        body: {'name': name, 'password': password},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String? userId = responseData['user']['_id'];

        if (userId != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', userId);
          prefs.setString('username', name);
          return AuthenticationModel(userId: userId, username: name);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
