import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import 'package:edenresto/Widgets/menu_item.dart';
import 'package:edenresto/models/order_service.dart';
import 'package:edenresto/Widgets/OrderItemRow.dart';

class PurchaseOrderScreen extends StatefulWidget {
  final Order? order;

  const PurchaseOrderScreen({super.key, this.order});

  @override
  _PurchaseOrderScreenState createState() => _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState extends State<PurchaseOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serverController;
  late List<OrderItem> _items;
  String _selectedStatus = 'pending'; // Statut sélectionné
  final _orderService = OrderService();
  List<MenuItem> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _initializeOrder();
    _loadMenuItems();
  }

  void _initializeOrder() {
    _serverController = TextEditingController(text: widget.order?.server ?? '');
    _items = widget.order?.items ?? [
      OrderItem(itemName: '', quantity: 1, unit: 'PCS', pricePerUnit: 0.0),
    ];
    _selectedStatus = widget.order?.status ?? 'pending';
  }

  Future<void> _loadMenuItems() async {
    try {
      _menuItems = await _orderService.fetchMenuItems(); // Récupérer les items de menu
      setState(() {});
    } catch (e) {
      // Gérer l'erreur, par exemple, afficher un snackbar
      print('Error loading menu items: $e');
    }
  }

  void _addItem() {
    setState(() {
      _items.add(OrderItem(itemName: '', quantity: 1, unit: 'PCS', pricePerUnit: 0.0));
    });
  }

  void _removeItem(OrderItem item) {
    setState(() {
      _items.remove(item);
    });
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (var item in _items) {
      total += item.pricePerUnit * item.quantity;
    }
    return total;
  }

  void _saveOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Créer un objet Order
      final order = Order(
        server: _serverController.text,
        orderTime: DateTime.now(),
        status: _selectedStatus,
        items: _items,
      );

      // Appeler OrderService pour sauvegarder la commande
      try {
        await _orderService.createOrder(order);
        Navigator.pop(context);
      } catch (e) {
        // Gérer l'erreur, par exemple, afficher un snackbar
        print('Error saving order: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveOrder,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _serverController,
                decoration: const InputDecoration(labelText: 'Nom du Serveur'),
                validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer un nom de serveur' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Statut'),
                items: ['pending', 'completed'].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Order Items', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._items.map((orderItem) {
                return OrderItemRow(
                  item: orderItem,
                  menuItems: _menuItems,
                  onItemChanged: (updatedItem) {
                    setState(() {
                      // Mettre à jour l'item de commande si nécessaire
                    });
                  },
                  onDelete: () => _removeItem(orderItem),
                );
              }),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: false, // Le champ est en lecture seule
                decoration: const InputDecoration(
                  labelText: 'Montant Total',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: _calculateTotalAmount().toStringAsFixed(2)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveOrder,
                child: const Text('Save Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
