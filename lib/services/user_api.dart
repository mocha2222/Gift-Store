import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  static const _base = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000/api');

  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Update the authenticated user's profile image (base64 string).
  static Future<void> updateProfileImage(String base64Image) async {
    final uri = Uri.parse('$_base/users/me');
    final headers = await _authHeaders();
    final res = await http.patch(
      uri,
      body: jsonEncode({'profile_image': base64Image}),
      headers: headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update profile image: ${res.body}');
    }

    // Also update local cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_avatar_bytes', base64Image);
  }

  /// Fetch the current user's profile from the backend and sync locally.
  static Future<Map<String, dynamic>> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '';
    if (userId.isEmpty) throw Exception('No user ID stored');

    final uri = Uri.parse('$_base/users/$userId');
    final headers = await _authHeaders();
    final res = await http.get(uri, headers: headers);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch user: ${res.body}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
