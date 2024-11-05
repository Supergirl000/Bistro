class MenuItem {
  final int id;
  String name; // Mutable for editing
  String description; // Mutable for editing
  double price;
  String category;
  String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  // Factory constructor to create a MenuItem from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] is int) ? json['price'].toDouble() : json['price'],
      category: json['category'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  // Method to convert MenuItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  // Keeping the existing fromMap method if you want to retain it
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] is int) ? map['price'].toDouble() : map['price'],
      category: map['category'],
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}
