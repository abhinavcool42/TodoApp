import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:todo_app/widgets/createtodo.dart';
import 'package:todo_app/widgets/edittodo.dart';
import 'package:todo_app/screens/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? userId = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("todos")
            .where("userId", isEqualTo: userId?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong XP");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                  radius: 40.0, color: Colors.purple),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Todos Found :-("),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var todo = snapshot.data!.docs[index]['todo'];
                var docId = snapshot.data!.docs[index].id;
                var title = snapshot.data!.docs[index]['title'];
                Timestamp date = snapshot.data!.docs[index]['createdAt'];
                var finalDate = DateTime.parse(date.toDate().toString());

                return Card(
                  child: ListTile(
                    isThreeLine: true,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.check,
                          color: Colors.purple,
                          size: 40,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(title,
                              style: const TextStyle(
                                fontSize: 35,
                                color: Colors.purple,
                              )),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          GetTimeAgo.parse(
                            finalDate,
                          ),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditTodoWidget(
                                  title: title,
                                  todo: todo,
                                  docId: docId,
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection("todos")
                                .doc(docId)
                                .delete();
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const CreateTodoWidget();
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
