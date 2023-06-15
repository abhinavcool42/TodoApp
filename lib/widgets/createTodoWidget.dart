// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, avoid_print
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
      title: Text("Create Todo"),
      content: Container(
        margin: EdgeInsets.symmetric(horizontal: 1.0),
        height: 300,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              child: TextFormField(
                controller: titleController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Add Title",
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: TextFormField(
                controller: todoController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Add Todo",
                ),
              ),
            ),
            SizedBox(
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
              child: Text("Add Todo"),
            )
          ],
        ),
      ),
    );
  }
}
