class OrderItem {
  int? id;
  String itemName;
  int quantity;
  String unit;
  double pricePerUnit;
  double get amount => quantity * pricePerUnit;

  OrderItem({
    this.id,
    required this.itemName,
    required this.quantity,
    required this.unit,
    required this.pricePerUnit,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemName': itemName,
    'quantity': quantity,
    'unit': unit,
    'pricePerUnit': pricePerUnit,
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['id'],
    itemName: json['itemName'],
    quantity: json['quantity'],
    unit: json['unit'],
    pricePerUnit: json['pricePerUnit'].toDouble(),
  );
}