// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  final String apiUrl = 'http://test.api.boxigo.in/sample-data/';

  Future<List<Inventory>> fetchInventory() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items']['inventory'] is List) {
          return (data['items']['inventory'] as List)
              .map((inventory) => Inventory.fromJson(inventory))
              .toList();
        } else {
          throw Exception('Invalid data structure');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
