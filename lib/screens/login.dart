// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, duplicate_ignore, sized_box_for_whitespace, unused_local_variable, avoid_print, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/screens/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Image.asset('assets/images/loginicon.jpg'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  controller: loginEmailController,
                  decoration: InputDecoration(
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
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  controller: loginPasswordController,
                  decoration: InputDecoration(
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
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  var loginEmail = loginEmailController.text.trim();
                  var loginPassword = loginPasswordController.text.trim();

                  try {
                    final User? firebaseUser = (await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: loginEmail, password: loginPassword))
                        .user;
                    if (firebaseUser != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      print("Check Email & Password");
                    }
                  } on FirebaseAuthException catch (e) {
                    print("Error $e");
                  }
                },
                child: Text("Login"),
              ),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Don't have an account?"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
