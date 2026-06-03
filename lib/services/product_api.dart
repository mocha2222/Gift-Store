import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/home_mock_data.dart';

class ProductApi {
  static const _base = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000/api');

  static Future<List<GiftItem>> getProducts() async {
    final uri = Uri.parse('$_base/products');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
    
    if (res.statusCode != 200) {
      throw Exception('Failed to load products: ${res.body}');
    }
    
    final List<dynamic> body = jsonDecode(res.body);
    return body.map((json) => GiftItem.fromJson(json as Map<String, dynamic>)).toList();
  }
}
