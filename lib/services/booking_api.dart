import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingApi {
  static const _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://localhost:3000/api',
  );

  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<void> createBooking(Map<String, dynamic> booking) async {
    final uri = Uri.parse('$_base/bookings');
    final headers = await _authHeaders();
    final res = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(booking),
    );
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Failed to create booking: ${res.body}');
    }
  }
}
