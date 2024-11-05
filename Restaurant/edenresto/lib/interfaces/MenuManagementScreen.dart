import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:edenresto/Widgets/menu_item.dart';
import 'package:edenresto/Widgets/MenuItemWidget.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  _MenuManagementScreenState createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://your-api-url.com'));
  List<MenuItem> _menuItems = [];
  final Map<String, List<MenuItem>> _categorizedMenuItems = {}; // Declaration of categorized items

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      final response = await _dio.get('/menu-items');
      final data = response.data as List<dynamic>;
      setState(() {
        _menuItems = data.map((item) => MenuItem.fromMap(item)).toList();
        // Populate the categorized menu items map
        _categorizedMenuItems.clear(); // Clear previous categories
        for (var item in _menuItems) {
          if (!_categorizedMenuItems.containsKey(item.category)) {
            _categorizedMenuItems[item.category] = [];
          }
          _categorizedMenuItems[item.category]!.add(item);
        }
      });
    } catch (e) {
      print('Error fetching menu items: $e');
    }
  }

  Future<void> addItem(MenuItem item) async {
    try {
      final response = await _dio.post('/menu-items', data: item.toMap());
      if (response.statusCode == 201) {
        setState(() {
          _menuItems.add(MenuItem.fromMap(response.data));
          
          // Add the new category to the map if it doesn't exist
          if (!_categorizedMenuItems.containsKey(item.category)) {
            _categorizedMenuItems[item.category] = [];
          }
          _categorizedMenuItems[item.category]!.add(MenuItem.fromMap(response.data));
        });
      }
    } catch (e) {
      print('Error adding menu item: $e');
    }
  }

  void showAddDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final imageUrlController = TextEditingController();
    String? selectedCategory;
    final newCategoryController = TextEditingController(); // For new category input

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Price'),
              ),
              // Dropdown for selecting existing categories
              DropdownButton<String>(
                value: selectedCategory,
                hint: const Text('Select Category'),
                isExpanded: true,
                items: _categorizedMenuItems.keys.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
              // Text field to create a new category
              TextField(
                controller: newCategoryController,
                decoration: const InputDecoration(hintText: 'Or create a new category'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(hintText: 'Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newItem = MenuItem(
                id: _menuItems.length + 1, // Simple ID generation
                name: nameController.text,
                description: descriptionController.text,
                price: double.parse(priceController.text),
                category: selectedCategory ?? newCategoryController.text, // Use selected or new category
                imageUrl: imageUrlController.text, // Use image URL directly
              );
              addItem(newItem);
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void showEditDialog(MenuItem item) {
    final nameController = TextEditingController(text: item.name);
    final descriptionController = TextEditingController(text: item.description);
    final priceController = TextEditingController(text: item.price.toString());
    final categoryController = TextEditingController(text: item.category);
    final imageUrlController = TextEditingController(text: item.imageUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Menu Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Price'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(hintText: 'Category'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(hintText: 'Image URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                item.name = nameController.text;
                item.description = descriptionController.text;
                item.price = double.parse(priceController.text);
                item.category = categoryController.text;
                item.imageUrl = imageUrlController.text; // Update image URL
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _menuItems.remove(item);
                // Remove item from categorized list
                _categorizedMenuItems[item.category]?.remove(item);
                if (_categorizedMenuItems[item.category]?.isEmpty ?? false) {
                  _categorizedMenuItems.remove(item.category);
                }
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
      ),
      body: ListView.builder(
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return MenuItemWidget(
            item: item,
            onEdit: () => showEditDialog(item),
            onDelete: () => showDeleteDialog(item),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
