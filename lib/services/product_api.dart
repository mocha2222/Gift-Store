import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/home_mock_data.dart';
import '../features/artisan/widgets/artisan_product_model.dart';

class ProductApi {
  static const _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://localhost:3000/api',
  );

  static Future<List<GiftItem>> getProducts({String? artisanId}) async {
    var url = '$_base/products';
    if (artisanId != null) {
      url += '?artisan_id=$artisanId';
    }
    final uri = Uri.parse(url);
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
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

  static Future<List<ArtisanProductModel>> getArtisanProducts(String artisanId) async {
    final uri = Uri.parse('$_base/products?artisan_id=$artisanId');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
    
    if (res.statusCode != 200) {
      throw Exception('Failed to load products: ${res.body}');
    }
    
    final List<dynamic> body = jsonDecode(res.body);
    return body.map((json) {
      final category = json['category_id'] is Map ? (json['category_id']['category_name'] ?? 'Other') : 'Other';
      return ArtisanProductModel(
        id: json['_id']?.toString() ?? '',
        title: json['name']?.toString() ?? 'Unnamed Product',
        description: json['description']?.toString() ?? '',
        price: json['price']?.toString() ?? '0.00',
        category: category,
        imagePath: json['image']?.toString() ?? '',
        culturalBackground: json['cultural_background']?.toString() ?? '',
        materialInfo: json['material_info']?.toString() ?? '',
        story: json['story']?.toString() ?? '',
        stock: json['stock'] is int ? json['stock'] : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
        discount: json['discount'] is int ? json['discount'] : int.tryParse(json['discount']?.toString() ?? '0') ?? 0,
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      );
    }).toList();
  }

  static Future<void> createProduct({
    required String artisanId,
    required String categoryId,
    required String name,
    required String description,
    required String price,
    required String category,
    required String culturalBackground,
    required String materialInfo,
    required String story,
    int? stock,
    int? discount,
    String? imageBase64,
  }) async {
    final uri = Uri.parse('$_base/products');
    
    final payload = {
      'artisan_id': artisanId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'cultural_background': culturalBackground,
      'material_info': materialInfo,
      'story': story,
      if (stock != null) 'stock': stock,
      if (discount != null) 'discount': discount,
      if (imageBase64 != null) 'image': imageBase64,
    };

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Failed to create product: ${res.body}');
    }
  }

  static Future<void> updateProduct({
    required String id,
    String? categoryId,
    String? name,
    String? description,
    String? price,
    String? category,
    String? culturalBackground,
    String? materialInfo,
    String? story,
    int? stock,
    int? discount,
    String? imageBase64,
  }) async {
    final uri = Uri.parse('$_base/products/$id');
    
    final payload = <String, dynamic>{};
    if (categoryId != null) payload['category_id'] = categoryId;
    if (name != null) payload['name'] = name;
    if (description != null) payload['description'] = description;
    if (price != null) payload['price'] = price;
    if (category != null) payload['category'] = category;
    if (culturalBackground != null) payload['cultural_background'] = culturalBackground;
    if (materialInfo != null) payload['material_info'] = materialInfo;
    if (story != null) payload['story'] = story;
    if (stock != null) payload['stock'] = stock;
    if (discount != null) payload['discount'] = discount;
    if (imageBase64 != null) payload['image'] = imageBase64;

    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update product: ${res.body}');
    }
  }

  static Future<void> deleteProduct(String id) async {
    final uri = Uri.parse('$_base/products/$id');
    final res = await http.delete(uri, headers: {'Content-Type': 'application/json'});
    if (res.statusCode != 200) {
      throw Exception('Failed to delete product: ${res.body}');
    }
  }
}
