import 'package:dio/dio.dart';
import 'employee.dart'; // Import the Employee model

class EmployeeService {
  final Dio _dio = Dio();

  // Add a new employee
  Future<void> addEmployee(Employee employee) async {
    try {
      await _dio.post('http://your-api-url/employees', data: employee.toJson());
    } catch (e) {
      print('Error adding employee: $e');
    }
  }

  // Fetch the list of employees
  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await _dio.get('http://your-api-url/employees');
      return (response.data as List)
          .map((emp) => Employee(
                id: emp['id'], // Ensure id is included
                name: emp['name'],
                position: emp['position'],
                hireDate: DateTime.parse(emp['hireDate']),
                performanceRating: emp['performanceRating'],
              ))
          .toList();
    } catch (e) {
      print('Error fetching employees: $e');
      return [];
    }
  }

  // Update an existing employee
  Future<void> updateEmployee(String id, Employee employee) async {
    try {
      await _dio.put('http://your-api-url/employees/$id', data: employee.toJson());
    } catch (e) {
      print('Error updating employee: $e');
    }
  }

  // Delete an employee
  Future<void> deleteEmployee(String id) async {
    try {
      await _dio.delete('http://your-api-url/employees/$id');
    } catch (e) {
      print('Error deleting employee: $e');
    }
  }
}
