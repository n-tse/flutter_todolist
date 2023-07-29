import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todolist/views/new_To_Do_Form.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List toDos = [];

  // like useEffect hook
  @override
  void initState() {
    super.initState();
    fetchToDos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("To Do List"),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: toDos.length,
        itemBuilder: (context, index) {
          final toDo = toDos[index] as Map;
          return ListTile(
            title: Text(toDo['title']),
            subtitle: Text(toDo['description']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddToDo,
        label: const Icon(Icons.add),
        shape: const CircleBorder(),
      ),
    );
  }

  void navigateToAddToDo() {
    final route = MaterialPageRoute(
      builder: (context) => const NewToDoForm(),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchToDos() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final items = json['items'] as List;
      setState(() {
        toDos = items;
      });
    }
  }
}
