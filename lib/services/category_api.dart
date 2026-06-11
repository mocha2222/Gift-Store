import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryModel {
  final String id;
  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // NestJS returns 'id' (virtual); raw Mongo returns '_id'
    final rawId = json['id'] ?? json['_id'] ?? '';
    return CategoryModel(
      id: rawId.toString(),
      name: json['category_name'] ?? 'Unknown',
    );
  }
}

class CategoryApi {
  static const _base = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000/api');

  static Future<List<CategoryModel>> getCategories() async {
    try {
      final uri = Uri.parse('$_base/categories');
      final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);
        return body.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Fallback to ensure we have at least one category to assign if DB is empty
  static Future<CategoryModel> ensureCategoryExists(String name) async {
    try {
      final uri = Uri.parse('$_base/categories');
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'category_name': name}),
      );
      if (res.statusCode == 201) {
        final body = jsonDecode(res.body);
        return CategoryModel.fromJson(body);
      }
      throw Exception('Failed to create category');
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }
}
