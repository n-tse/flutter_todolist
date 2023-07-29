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
  bool initialLoad = true;

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
      // if visible = true, display child. Otherwise, display replacement
      body: Visibility(
        visible: initialLoad,
        replacement: RefreshIndicator(
          onRefresh: fetchToDos,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              itemCount: toDos.length,
              itemBuilder: (context, index) {
                final toDo = toDos[index] as Map;
                return ListTile(
                  // leading: CircleAvatar(child: Text((index + 1).toString())),
                  title: Text(toDo['title']),
                  subtitle: Text(toDo['description']),
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
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
    setState(() {
      initialLoad = false;
    });
  }
}
