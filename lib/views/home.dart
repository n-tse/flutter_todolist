import 'package:flutter/material.dart';
import 'package:todolist/views/new_To_Do_Form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: const Center(child: Text("To Do List Content")),
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
}
