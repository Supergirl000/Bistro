import 'package:flutter/material.dart';
import 'package:edenresto/models/employee.dart';
import 'package:edenresto/models/employee_service.dart';
import 'tring_extensions.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  _EmployeeManagementScreenState createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedPosition = 'waiter';
  DateTime? _hireDate;
  double _performanceRating = 0.0;

  final EmployeeService _employeeService = EmployeeService();
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  void _fetchEmployees() async {
    final employees = await _employeeService.fetchEmployees();
    setState(() {
      _employees = employees;
    });
  }

  void _addEmployee() {
    if (_formKey.currentState!.validate()) {
      final newEmployee = Employee(
       id: 'unique_employee_id',
        name: _nameController.text,
        position: _selectedPosition,
        hireDate: _hireDate!,
        performanceRating: _performanceRating,
      );
      _employeeService.addEmployee(newEmployee).then((_) {
        _fetchEmployees(); // Refresh employee list
        _clearForm();
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    setState(() {
      _selectedPosition = 'waiter';
      _hireDate = null;
      _performanceRating = 0.0;
    });
  }

  void _deleteEmployee(String id) {
    _employeeService.deleteEmployee(id).then((_) {
      _fetchEmployees(); // Refresh employee list after deletion
    });
  }

  void _selectHireDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _hireDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _hireDate) {
      setState(() {
        _hireDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedPosition,
                    items: ['waiter', 'chef', 'manager']
                        .map((position) => DropdownMenuItem(
                              value: position,
                              child: Text(position.capitalize()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPosition = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Position'),
                  ),
                  TextButton(
                    onPressed: () => _selectHireDate(context),
                    child: Text(_hireDate == null
                        ? 'Select Hire Date'
                        : 'Hire Date: ${_hireDate!.toLocal()}'.split(' ')[0]),
                  ),
                  Slider(
                    value: _performanceRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: _performanceRating.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _performanceRating = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  ElevatedButton(
                    onPressed: _addEmployee,
                    child: const Text('Add Employee'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return ListTile(
                    title: Text(employee.name),
                    subtitle: Text('Position: ${employee.position}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteEmployee(employee.id), // Make sure to have an id in your Employee model
                      color: Colors.red,
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
