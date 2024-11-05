import 'package:flutter/material.dart';
import 'package:edenresto/Widgets/menu_item.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MenuItemWidget({required this.item, required this.onEdit, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: item.imageUrl.isNotEmpty
            ? Image.network(
                item.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : Container(width: 50, height: 50, color: Colors.grey), // Placeholder if no image URL
        title: Text(item.name),
        subtitle: Text(item.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
