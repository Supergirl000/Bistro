import 'order_item.dart';

class Order {
  int? id;
  DateTime orderTime;
  String status;
  String server;
  List<OrderItem> items;

  double get totalAmount => items.fold(0, (sum, item) => sum + item.amount);

  Order({
    this.id,
    required this.orderTime,
    required this.status,
    required this.server,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderTime': orderTime.toIso8601String(),
    'status': status,
    'server': server,
    'items': items.map((item) => item.toJson()).toList(),
  };
  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    orderTime: DateTime.parse(json['orderTime']),
    status: json['status'],
    server: json['server'],
    items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
  );
}