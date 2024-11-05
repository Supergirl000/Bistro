import 'package:flutter/material.dart';
import 'package:edenresto/models/TableService.dart';
import 'package:edenresto/models/TableModel.dart';

class TableManagementScreen extends StatefulWidget {
  const TableManagementScreen({super.key});

  @override
  _TableManagementScreenState createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  final TableService _tableService = TableService();
  List<TableModel> tables = [];
  final _formKey = GlobalKey<FormState>();
  late String number;
  late int capacity;
  String status = 'available';

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    try {
      tables = await _tableService.fetchTables();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors du chargement des tables')),
      );
    }
  }

  Future<void> _saveTable() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTable = TableModel(id: 0, number: number, capacity: capacity, status: status);
      await _tableService.createTable(newTable);
      _loadTables();
    }
  }

  Future<void> _deleteTable(int id) async {
    await _tableService.deleteTable(id);
    _loadTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion des Tables")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Numéro de Table'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un numéro de table';
                      }
                      return null;
                    },
                    onSaved: (value) => number = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Capacité'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une capacité';
                      }
                      return null;
                    },
                    onSaved: (value) => capacity = int.parse(value!),
                  ),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Statut'),
                    items: const [
                      DropdownMenuItem(value: 'available', child: Text('Disponible')),
                      DropdownMenuItem(value: 'occupied', child: Text('Occupée')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        status = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveTable,
                    child: const Text('Ajouter la Table'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final table = tables[index];
                  return ListTile(
                    title: Text("Table ${table.number}"),
                    subtitle: Text("Capacité: ${table.capacity} - Statut: ${table.status}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text("Êtes-vous sûr de vouloir supprimer cette table ?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _deleteTable(table.id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Oui"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Non"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
