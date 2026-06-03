import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  static const _base = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000/api');

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse('$_base/auth/login');
    final res = await http.post(uri, body: jsonEncode({'email': email, 'password': password}), headers: {'Content-Type': 'application/json'});
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception(res.body);
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', body['access_token'] as String);
    await prefs.setString('user_id', (body['user']?['_id'] ?? '') as String);
    await prefs.setString('user_email', (body['user']?['email'] ?? email) as String);
    await prefs.setString('user_role', (body['user']?['role'] ?? 'customer') as String);
    await prefs.setString('user_name', (body['user']?['name'] ?? '') as String);
    final profileImage = body['user']?['profile_image'];
    if (profileImage != null && profileImage.toString().isNotEmpty) {
      await prefs.setString('user_avatar_bytes', profileImage as String);
    }
    return body;
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password, {String role = 'customer'}) async {
    final uri = Uri.parse('$_base/auth/register');
    final res = await http.post(uri, body: jsonEncode({'name': name, 'email': email, 'password': password, 'role': role}), headers: {'Content-Type': 'application/json'});
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception(res.body);
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', body['access_token'] as String);
    await prefs.setString('user_id', (body['user']?['_id'] ?? '') as String);
    await prefs.setString('user_email', (body['user']?['email'] ?? email) as String);
    await prefs.setString('user_role', (body['user']?['role'] ?? role) as String);
    await prefs.setString('user_name', (body['user']?['name'] ?? name) as String);
    final profileImage = body['user']?['profile_image'];
    if (profileImage != null && profileImage.toString().isNotEmpty) {
      await prefs.setString('user_avatar_bytes', profileImage as String);
    }
    return body;
  }
}
