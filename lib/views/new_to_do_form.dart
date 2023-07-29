// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewToDoForm extends StatefulWidget {
  const NewToDoForm({super.key});

  @override
  State<NewToDoForm> createState() => _NewToDoFormState();
}

class _NewToDoFormState extends State<NewToDoForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
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
          title: const Text("Add New To Do"),
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
              onPressed: addToDo,
              child: const Text("Add To Do"),
            )
          ],
        ),
      ),
    );
  }

  // get data from for and send to server
  Future<void> addToDo() async {
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
    } else {
      displayMessage("Failed to add to do");
    }

    // hides keyboard
    FocusScope.of(context).unfocus();
  }

  void displayMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
