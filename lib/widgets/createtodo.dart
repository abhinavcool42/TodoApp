import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateTodoWidget extends StatefulWidget {
  const CreateTodoWidget({super.key});

  @override
  State<CreateTodoWidget> createState() => _CreateTodoWidgetState();
}

class _CreateTodoWidgetState extends State<CreateTodoWidget> {
  TextEditingController todoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  User? userId = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.checklist),
          SizedBox(
            width: 10.0,
          ),
          Text("Create Todo"),
        ],
      ),
      content: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        height: 300,
        width: double.infinity,
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Add Title",
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: todoController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Add Todo",
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                var title = titleController.text.trim();
                var todo = todoController.text.trim();
                if (todo != "") {
                  try {
                    await FirebaseFirestore.instance
                        .collection("todos")
                        .doc()
                        .set({
                      "createdAt": DateTime.now(),
                      "title": title,
                      "todo": todo,
                      "userId": userId?.uid,
                    });
                  } catch (e) {
                    print("Error $e");
                  }
                }
              },
              child: const Text("Add Todo"),
            )
          ],
        ),
      ),
    );
  }
}
