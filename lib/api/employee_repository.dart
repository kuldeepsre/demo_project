// employee_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/employee_model.dart';

class EmployeeRepository {
  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse('https://dummy.restapiexample.com/api/v1/employees'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check the status in the JSON response
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];

          final List<Employee> employees = data.map((e) => Employee.fromJson(e)).toList();
          return employees;
        } else {
          // Handle error or return an empty list
          throw Exception('Failed to fetch employees: ${jsonResponse['message']}');
        }
      } else {
        // Handle HTTP error
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle general error
      throw Exception('Failed to fetch employees: $e');
    }
  }
}

