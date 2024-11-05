import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class BillingScreenManagement extends StatefulWidget {
  const BillingScreenManagement({super.key});

  @override
  _BillingScreenManagementState createState() =>
      _BillingScreenManagementState();
}

class _BillingScreenManagementState extends State<BillingScreenManagement> {
  final List<BillingItem> _billingItems = [
    BillingItem("Coffee", 3.50),
    BillingItem("Sandwich", 5.00),
    BillingItem("Cake", 4.00),
  ];
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://api.example.com"));

  Future<void> _addItem(String name, double price) async {
    try {
      final response = await _dio.post('/billing', data: {
        "name": name,
        "price": price,
      });

      if (response.statusCode == 201) {
        setState(() {
          _billingItems.add(BillingItem(name, price));
        });
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to add item');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error adding item")),
      );
    }
  }

  void _showAddItemDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Item Price"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final price = double.tryParse(priceController.text) ?? 0;
              if (name.isNotEmpty && price > 0) {
                _addItem(name, price);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter valid details")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Billing Management"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _billingItems.length,
        itemBuilder: (context, index) {
          final item = _billingItems[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text("Price: \$${item.price.toStringAsFixed(2)}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editItem(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editItem(BillingItem item) {
    final TextEditingController nameController =
        TextEditingController(text: item.name);
    final TextEditingController priceController =
        TextEditingController(text: item.price.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Item Price"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                item.name = nameController.text;
                item.price = double.tryParse(priceController.text) ?? 0;
              });
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _billingItems.removeAt(index);
    });
  }
}

class BillingItem {
  String name;
  double price;

  BillingItem(this.name, this.price);
}
