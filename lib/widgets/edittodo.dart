import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTodoWidget extends StatefulWidget {
  final String title;
  final String todo;
  final String docId;

  const EditTodoWidget({
    super.key,
    required this.title,
    required this.todo,
    required this.docId,
  });

  @override
  State<EditTodoWidget> createState() => _EditTodoWidgetState();
}

class _EditTodoWidgetState extends State<EditTodoWidget> {
  TextEditingController todoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edit Todo",
      ),
      content: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          height: 300,
          width: double.infinity,
          child: Column(
            children: [
              TextFormField(
                controller: titleController..text = widget.title.toString(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: todoController..text = widget.todo.toString(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance
                      .collection("todos")
                      .doc(widget.docId.toString())
                      .update(
                    {
                      'todo': todoController.text.trim(),
                      'title': titleController.text.trim(),
                    },
                  );
                },
                child: const Text("Update Todo"),
              ),
            ],
          )),
    );
  }
}
