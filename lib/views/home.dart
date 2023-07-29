import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todolist/views/to_do_form.dart';
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
                final id = toDo['_id'] as String;
                return ListTile(
                  // leading: CircleAvatar(child: Text((index + 1).toString())),
                  title: Text(toDo['title']),
                  subtitle: Text(toDo['description']),
                  trailing: Column(
                    // display the PopupMenuButton items vertically (default displays horizontally)
                    mainAxisSize: MainAxisSize
                        .min, // Ensure the Column takes the minimum vertical space
                    children: [
                      PopupMenuButton(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            // edit todo
                            navigateToEditToDo(toDo);
                          } else {
                            bool? confirmed =
                                await showDeleteConfirmation(context);
                            if (confirmed == true) {
                              deleteToDo(id);
                            }
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
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
      builder: (context) => ToDoForm(fetchToDos: fetchToDos),
    );
    Navigator.push(context, route);
  }

  void navigateToEditToDo(Map toDo) {
    final route = MaterialPageRoute(
      builder: (context) => ToDoForm(fetchToDos: fetchToDos, toDoItem: toDo),
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

  Future<void> deleteToDo(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = toDos.where((element) => element['_id'] != id).toList();
      setState(() {
        toDos = filtered;
      });
    } else {
      const snackBar = SnackBar(content: Text("Error: unable to delete"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool?> showDeleteConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this To Do?'),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // User canceled
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true), // User confirmed
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
  
}
