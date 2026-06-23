import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/home_mock_data.dart';
import '../features/artisan/widgets/artisan_product_model.dart';

class ProductApi {
  static const _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://localhost:3000/api',
  );

  static String get baseUrl => _base;

  /// Fetches products, optionally filtered by an artisan ID and category ID.
  static Future<List<GiftItem>> getProducts({String? artisanId, String? categoryId}) async {
    var url = '$_base/products';
    final queryParams = <String>[];
    if (artisanId != null) {
      queryParams.add('artisan_id=$artisanId');
    }
    if (categoryId != null) {
      queryParams.add('category_id=$categoryId');
    }
    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }
    final uri = Uri.parse(url);
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

  static Future<GiftItem> getProduct(String id) async {
    final uri = Uri.parse('$_base/products/$id');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load product details: ${res.body}');
    }

    final Map<String, dynamic> body = jsonDecode(res.body);
    return GiftItem.fromJson(body);
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

  static Future<List<ArtisanProductModel>> getArtisanProducts(
    String artisanId,
  ) async {
    final uri = Uri.parse('$_base/products?artisan_id=$artisanId');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load products: ${res.body}');
    }

    final List<dynamic> body = jsonDecode(res.body);
    return body.map((json) {
      final category = json['category_id'] is Map
          ? (json['category_id']['category_name'] ?? 'Other')
          : 'Other';
      return ArtisanProductModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        title: json['name']?.toString() ?? 'Unnamed Product',
        description: json['description']?.toString() ?? '',
        price: json['price']?.toString() ?? '0.00',
        category: category,
        imagePath: json['image']?.toString() ?? '',
        culturalBackground: json['cultural_background']?.toString() ?? '',
        materialInfo: json['material_info']?.toString() ?? '',
        story: json['story']?.toString() ?? '',
        stock: json['stock'] is int
            ? json['stock']
            : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
        discount: json['discount'] is int
            ? json['discount']
            : int.tryParse(json['discount']?.toString() ?? '0') ?? 0,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null,
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
      'price': double.tryParse(price) ?? 0.0,
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
    if (price != null) payload['price'] = double.tryParse(price) ?? 0.0;
    if (category != null) payload['category'] = category;
    if (culturalBackground != null)
      payload['cultural_background'] = culturalBackground;
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final res = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to delete product: ${res.body}');
    }
  }
  static Future<List<MakerItem>> getMakers() async {
    final uri = Uri.parse('$_base/artisans');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
    
    if (res.statusCode != 200) {
      throw Exception('Failed to load makers: ${res.body}');
    }

    final List<dynamic> body = jsonDecode(res.body);
    return body.map((json) {
      final name = json['shop_name']?.toString() ?? 'Unknown Artisan';
      final craftType = json['craft_type']?.toString() ?? 'Craftsman';
      final region = json['region']?.toString() ?? 'Cambodia';
      final role = '$craftType · $region';
      final quote = json['story']?.toString() ?? 'Dedicated to the craft.';
      final userId = json['user_id'];
      String avatarUrl = '';
      if (userId is Map && userId['profile_image'] != null && userId['profile_image'].toString().isNotEmpty) {
        avatarUrl = userId['profile_image'].toString();
      } else {
        avatarUrl = json['cover_image']?.toString() ?? 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&q=80';
      }
      
      final productsJson = json['products'] as List<dynamic>? ?? [];
      final products = productsJson.map((p) {
        return ArtisanProduct(
          title: p['name']?.toString() ?? '',
          price: '\$${p['price']?.toString() ?? ''}',
          imagePath: p['image']?.toString() ?? '',
        );
      }).toList();
      
      return MakerItem(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: name,
        role: role,
        quote: quote,
        avatarUrl: avatarUrl,
        followerCount: 150,
        products: products,
      );
    }).toList();
  }

  static Future<MakerItem> getMakerDetails(String id) async {
    final uri = Uri.parse('$_base/artisans/$id');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
    
    if (res.statusCode != 200) {
      throw Exception('Failed to load maker details: ${res.body}');
    }

    final json = jsonDecode(res.body);
    final name = json['shop_name']?.toString() ?? 'Unknown Artisan';
    final craftType = json['craft_type']?.toString() ?? 'Craftsman';
    final region = json['region']?.toString() ?? 'Cambodia';
    final role = '$craftType · $region';
    final quote = json['story']?.toString() ?? 'Dedicated to the craft.';
    final userId = json['user_id'];
    String avatarUrl = '';
    if (userId is Map && userId['profile_image'] != null && userId['profile_image'].toString().isNotEmpty) {
      avatarUrl = userId['profile_image'].toString();
    } else {
      avatarUrl = json['cover_image']?.toString() ?? 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&q=80';
    }
    
    final productsJson = json['products'] as List<dynamic>? ?? [];
    final products = productsJson.map((p) {
      return ArtisanProduct(
        title: p['name']?.toString() ?? '',
        price: '\$${p['price']?.toString() ?? ''}',
        imagePath: p['image']?.toString() ?? '',
      );
    }).toList();
    
    return MakerItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? id,
      name: name,
      role: role,
      quote: quote,
      avatarUrl: avatarUrl,
      followerCount: 150,
      products: products,
    );
  }

  /// Fetch all collections from backend.
  static Future<List<CollectionItem>> getCollections() async {
    final uri = Uri.parse('$_base/collections');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (res.statusCode != 200) {
      throw Exception('Failed to load collections: ${res.body}');
    }

    final List<dynamic> body = jsonDecode(res.body);
    return body
        .map((json) => CollectionItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch a single collection with its products.
  static Future<List<GiftItem>> getCollectionProducts(String collectionId) async {
    final uri = Uri.parse('$_base/collections/$collectionId');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (res.statusCode != 200) {
      throw Exception('Failed to load collection products: ${res.body}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final productsList = json['products'] as List<dynamic>? ?? [];
    return productsList
        .map((p) => GiftItem.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  /// Fetch active coupons from backend.
  static Future<List<PromoItem>> getCoupons() async {
    final uri = Uri.parse('$_base/coupons/active');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (res.statusCode != 200) {
      throw Exception('Failed to load coupons: ${res.body}');
    }

    final List<dynamic> body = jsonDecode(res.body);
    return body
        .map((json) => PromoItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch products that have a discount > 0.
  static Future<List<GiftItem>> getDiscountProducts() async {
    final products = await getProducts();
    return products.where((p) => p.discount > 0).toList();
  }

  /// Fetch orders for a specific artisan.
  static Future<List<Map<String, dynamic>>> getArtisanOrders(String artisanId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final uri = Uri.parse('$_base/orders?artisan_id=$artisanId');
    final res = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load artisan orders: ${res.body}');
    }

    final List<dynamic> data = jsonDecode(res.body);
    return data.map((json) => json as Map<String, dynamic>).toList();
  }

  /// Create an order.
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final uri = Uri.parse('$_base/orders');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Failed to create order: ${res.body}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Fetch orders for a specific customer.
  static Future<List<Map<String, dynamic>>> getCustomerOrders(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final uri = Uri.parse('$_base/orders/my');
    final res = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load customer orders: ${res.body}');
    }

    final List<dynamic> data = jsonDecode(res.body);
    return data.map((json) => json as Map<String, dynamic>).toList();
  }
}
