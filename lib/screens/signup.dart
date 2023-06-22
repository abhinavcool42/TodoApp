import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

signUpUser(
  BuildContext context,
  String userName,
  String userEmail,
  String userPassword,
) async {
  User? userid = FirebaseAuth.instance.currentUser;

  try {
    await FirebaseFirestore.instance.collection("users").doc(userid!.uid).set({
      'userName': userName,
      'userEmail': userEmail,
      'createdAt': DateTime.now(),
      'userId': userid.uid,
    }).then((value) {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  } on FirebaseAuthException catch (e) {
    print("Error $e");
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Image.asset('assets/images/loginicon.jpg'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: userNameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Username',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 3,
                    color: Colors.purple,
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: userEmailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 3,
                    color: Colors.purple,
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: userPasswordController,
                decoration: const InputDecoration(
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      width: 3,
                      color: Colors.purple,
                    )),
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: Icon(
                      Icons.visibility,
                    )),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                var userName = userNameController.text.trim();
                var userEmail = userEmailController.text.trim();
                var userPassword = userPasswordController.text.trim();

                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: userEmail, password: userPassword)
                    .then((value) => {
                          signUpUser(
                            context,
                            userName,
                            userEmail,
                            userPassword,
                          ),
                        });
              },
              child: const Text("Sign Up"),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Already have an account?"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
