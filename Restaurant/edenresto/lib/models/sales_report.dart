class SalesReport {
  final DateTime date;
  final double totalSales;
  final List<SoldItem> itemsSold;

  SalesReport({
    required this.date,
    required this.totalSales,
    required this.itemsSold,
  });

  factory SalesReport.fromJson(Map<String, dynamic> json) {
    var itemsList = json['itemsSold'] as List;
    List<SoldItem> soldItems = itemsList.map((item) => SoldItem.fromJson(item)).toList();

    return SalesReport(
      date: DateTime.parse(json['date']),
      totalSales: json['totalSales'].toDouble(),
      itemsSold: soldItems,
    );
  }
}

class SoldItem {
  final String item; // This should be an ID or reference to the MenuItem model
  final int quantity;

  SoldItem({
    required this.item,
    required this.quantity,
  });

  factory SoldItem.fromJson(Map<String, dynamic> json) {
    return SoldItem(
      item: json['item'],
      quantity: json['quantity'],
    );
  }
}
