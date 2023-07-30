import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoApi {
  static Future<List<Map<String, dynamic>>> fetchToDos() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final items = json['items'] as List;
      return items.cast<Map<String, dynamic>>();
    }
    return [];
  }

  static Future<void> deleteToDo(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode != 200) {
      throw Exception('Error: Unable to delete the ToDo item.');
    }
  }

  static Future<void> addToDo(Map<String, dynamic> newToDo) async {
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(newToDo),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception("Failed to add to-do");
    }
  }

  static Future<void> updateToDo(
      String itemId, Map<String, dynamic> updatedToDo) async {
    final url = 'https://api.nstack.in/v1/todos/$itemId';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(updatedToDo),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to update to-do");
    }
  }
}
