// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToDoForm extends StatefulWidget {
  final void Function() fetchToDos;
  final Map? toDoItem;

  const ToDoForm({
    Key? key,
    required this.fetchToDos,
    this.toDoItem,
  }) : super(key: key);
  // const ToDoForm({super.key});

  @override
  State<ToDoForm> createState() => _ToDoFormState();
}

class _ToDoFormState extends State<ToDoForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  bool isEditMode = false;
  String id = '';

  @override
  void initState() {
    super.initState();
    final toDoItem = widget.toDoItem;
    if (toDoItem != null) {
      isEditMode = true;
      final title = toDoItem['title'];
      final description = toDoItem['description'];
      titleController.text = title;
      descriptionController.text = description;
      id = toDoItem['_id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // hides keyboard
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            isEditMode ? "Edit To Do" : "Add New To Do",
            style: const TextStyle(fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title (required)",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 8,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: isEditMode ? () => updateToDo(id) : addToDo,
              child: isLoading
                  ? const SizedBox(
                      width: 25, // Adjust the width of the progress indicator
                      height: 25, // Adjust the height of the progress indicator
                      child: CircularProgressIndicator(),
                    )
                  : Text(isEditMode ? "Update" : "Add To Do", style: const TextStyle(fontSize: 18.0),),
            )
          ],
        ),
      ),
    );
  }

  // get data from form and send to server
  Future<void> addToDo() async {
    setState(() {
      isLoading = true;
    });

    final title = titleController.text;
    final description = descriptionController.text;
    final newToDo = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(newToDo),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // final responseMap =
    //     jsonDecode(response.body); // Parse the JSON response body
    // final message = responseMap['message']; // Access the 'message' field

    if (response.statusCode == 201) {
      displayMessage("Added successfully");
      titleController.text = "";
      descriptionController.text = "";

      // update to dos list
      // 'widget' allows us to access properties/methods located within the parent widget instance
      // in this case, the parent widget is 'HomePage', and the child widget is 'ToDoForm'
      widget.fetchToDos();
    } else {
      displayMessage("Failed to add to do");
    }

    setState(() {
      isLoading = false;
    });

    // hides keyboard
    FocusScope.of(context).unfocus();
  }

  Future<void> updateToDo(String itemId) async {
    setState(() {
      isLoading = true;
    });

    final title = titleController.text;
    final description = descriptionController.text;
    final updatedToDo = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

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
      displayMessage("Updated successfully");
      widget.fetchToDos();
    } else {
      displayMessage("Failed to update to do");
    }

    setState(() {
      isLoading = false;
    });

    FocusScope.of(context).unfocus();
  }

  void displayMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
