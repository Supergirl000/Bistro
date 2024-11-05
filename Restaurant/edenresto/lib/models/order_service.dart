import 'package:dio/dio.dart';
import 'order.dart';

import 'package:edenresto/Widgets/menu_item.dart';

class OrderService {
  final Dio _dio = Dio();
  final String baseUrl = 'YOUR_API_BASE_URL';

  Future<Order> createOrder(Order order) async {
    try {
      final response = await _dio.post('$baseUrl/orders', data: order.toJson());
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la création de la commande: $e');
    }
  }

  Future<Order> updateOrder(int id, Order order) async {
    try {
      final response = await _dio.put('$baseUrl/orders/$id', data: order.toJson());
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la commande: $e');
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      await _dio.delete('$baseUrl/orders/$id');
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la commande: $e');
    }
  }

  Future<Order> getOrder(int id) async {
    try {
      final response = await _dio.get('$baseUrl/orders/$id');
      return Order.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la commande: $e');
    }
  }

  // New method to fetch MenuItems
  Future<List<MenuItem>> fetchMenuItems() async {
    try {
      final response = await _dio.get('$baseUrl/menuItems');
      return (response.data as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des éléments du menu: $e');
    }
  }
}
