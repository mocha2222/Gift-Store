import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/home_mock_data.dart';

class ProductApi {
  static const _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://localhost:3000/api',
  );

  static Future<List<GiftItem>> getProducts() async {
    final uri = Uri.parse('$_base/products');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load products: ${res.body}');
    }

    final List<dynamic> body = jsonDecode(res.body);
    return body
        .map((json) => GiftItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Submit a product review. Images should be sent as base64 strings.
  static Future<void> submitReview({
    required String productId,
    required int rating,
    String? title,
    String? body,
    List<String>? imagesBase64,
  }) async {
    final uri = Uri.parse('$_base/products/$productId/reviews');

    final payload = {
      'rating': rating,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (imagesBase64 != null && imagesBase64.isNotEmpty)
        'images': imagesBase64,
    };

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Failed to submit review: ${res.body}');
    }
  }
}
