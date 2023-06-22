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
        title: const Text("Login"),
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
                controller: loginEmailController,
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
                controller: loginPasswordController,
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
                var loginEmail = loginEmailController.text.trim();
                var loginPassword = loginPasswordController.text.trim();

                try {
                  final User? firebaseUser = (await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: loginEmail, password: loginPassword))
                      .user;
                  if (firebaseUser != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  } else {
                    print("Check Email & Password");
                  }
                } on FirebaseAuthException catch (e) {
                  print("Error $e");
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(
              height: 10.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Don't have an account?"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
