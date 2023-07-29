// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NewToDoForm extends StatefulWidget {
  const NewToDoForm({super.key});

  @override
  State<NewToDoForm> createState() => _NewToDoFormState();
}

class _NewToDoFormState extends State<NewToDoForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const TextField(
            decoration: InputDecoration(
              hintText: "Title",
            ),
          ),
          const SizedBox(height: 20,),
          const TextField(
            decoration: InputDecoration(
              hintText: "Description",
            ),
            keyboardType: TextInputType.multiline,
            minLines: 4,
            maxLines: 8,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: addToDo,
            child: const Text("Add To Do"),
          )
        ],
      ),
    );
  }

  void addToDo () {

  }
}
