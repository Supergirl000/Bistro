// lib/widgets/order_item_row.dart

import 'package:flutter/material.dart';
import '../models/order_item.dart';
import 'menu_item.dart';

class OrderItemRow extends StatefulWidget {
  final OrderItem item;
  final List<MenuItem> menuItems;
  final Function(OrderItem) onItemChanged;
  final VoidCallback onDelete;

  const OrderItemRow({
    super.key,
    required this.item,
    required this.menuItems,
    required this.onItemChanged,
    required this.onDelete,
  });

  @override
  _OrderItemRowState createState() => _OrderItemRowState();
}

class _OrderItemRowState extends State<OrderItemRow> {
  late TextEditingController _itemController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController(text: widget.item.itemName);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: GestureDetector(
            onTap: () => _showMenuItemsDropdown(),
            child: TextFormField(
              controller: _itemController,
              readOnly: true, // This makes it act as a dropdown trigger
              decoration: const InputDecoration(
                labelText: 'Select Item',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: widget.item.quantity.toString(),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onChanged: (value) {
              widget.item.quantity = int.tryParse(value) ?? 0;
              widget.onItemChanged(widget.item);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: widget.item.pricePerUnit.toStringAsFixed(2),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onChanged: (value) {
              widget.item.pricePerUnit = double.tryParse(value) ?? 0.0;
              widget.onItemChanged(widget.item);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(widget.item.amount.toStringAsFixed(2)),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: widget.onDelete,
        ),
      ],
    );
  }

  void _showMenuItemsDropdown() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: widget.menuItems.map((menuItem) {
          return ListTile(
            title: Text('${menuItem.name} (${menuItem.price.toStringAsFixed(2)})'),
            onTap: () {
              setState(() {
                widget.item.itemName = menuItem.name;
                widget.item.pricePerUnit = menuItem.price;
                _itemController.text = menuItem.name;
              });
              widget.onItemChanged(widget.item);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
