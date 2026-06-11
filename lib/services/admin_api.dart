import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../features/admin/admin_models.dart';

class AdminApi {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<void> loadAdminData() async {
    try {
      final headers = await _headers();
      
      // Fetch Artisans
      final artisanRes = await http.get(Uri.parse('$baseUrl/artisans'), headers: headers);
      if (artisanRes.statusCode == 200) {
        final List<dynamic> data = jsonDecode(artisanRes.body);
        adminArtisans = data.map((json) => AdminArtisan.fromJson(json)).toList();
      }

      // Fetch Products
      final productRes = await http.get(Uri.parse('$baseUrl/products'), headers: headers);
      if (productRes.statusCode == 200) {
        final List<dynamic> data = jsonDecode(productRes.body);
        adminProducts = data.map((json) => AdminProduct.fromJson(json)).toList();
      }

      // Fetch Orders
      final orderRes = await http.get(Uri.parse('$baseUrl/orders'), headers: headers);
      if (orderRes.statusCode == 200) {
        final List<dynamic> data = jsonDecode(orderRes.body);
        adminOrders = data.map((json) => AdminOrder.fromJson(json)).toList();
      }

      // Fetch Customers
      final userRes = await http.get(Uri.parse('$baseUrl/users'), headers: headers);
      int totalCustomers = 0;
      if (userRes.statusCode == 200) {
        final List<dynamic> data = jsonDecode(userRes.body);
        totalCustomers = data.length;
      }

      // Calculate Overview
      double totalRevenue = 0;
      for (final order in adminOrders) {
        if (order.status == AdminOrderStatus.delivered || order.status == AdminOrderStatus.shipped || order.status == AdminOrderStatus.confirmed || order.status == AdminOrderStatus.pending) {
           totalRevenue += order.total;
        }
      }

      adminOverview = AdminOverview(
        totalRevenue: totalRevenue,
        totalOrders: adminOrders.length,
        totalArtisans: adminArtisans.length,
        totalCustomers: totalCustomers,
      );

    } catch (e) {
      print('Error loading admin data: $e');
    }
  }
}
