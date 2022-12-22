import 'dart:io';

import 'package:expences/logInState.dart';
import 'package:expences/reset.dart';
import 'package:expences/signup.dart';
import 'package:expences/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogIn extends StatefulWidget {
  // const LogIn({ Key? key }) : super(key: key);
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = '';
  String password = '';
  String loggedinUser = '';
  final passwordEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  late User user;

  void getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        setState(() {
          loggedinUser = user.email.toString();
        });

        print(loggedinUser);
      }
    } catch (e) {
      print(e);
    }
  }

  void logIn() async {
    try {
      final User? user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user == null) {
      } else {
        getCurrentUser();
        Store().storeData(loggedinUser);
        Fluttertoast.showToast(msg: 'Logged in');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogInState()),
        );

        ///Next page
      }
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/unknown] Given String is empty or null") {
        Fluttertoast.showToast(msg: 'blanks are empty');
      }
      if (e.toString() ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        Fluttertoast.showToast(msg: 'Enter a correct email');
      }
      if (e.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        Fluttertoast.showToast(msg: 'No registered account');
      } else {
        Fluttertoast.showToast(msg: 'Something wents wrong');
      }

      print(e);
    }
  }

  Future<bool> _onBackpressed() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('No'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                  exit(0);
                },
                child: Text('Exit'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackpressed,
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Login",
              style: TextStyle(color: Colors.indigo, fontSize: 50),
            ),
            Column(
              children: <Widget>[
                Textfield(
                  controller: emailEditingController,
                  type: TextInputType.emailAddress,
                  label: "Email",
                  onChanged: (value) {
                    email = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Textfield(
                    controller: passwordEditingController,
                    type: TextInputType.text,
                    label: "Password",
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Reset()),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                )
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.indigo),
              ),
              onPressed: () {
                logIn();
                emailEditingController.clear();
                passwordEditingController.clear();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an Account?"),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    emailEditingController.clear();
                    passwordEditingController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}

class Textfield extends StatelessWidget {
  final String label;
  final TextInputType? type;
  final Function(String) onChanged;
  final TextEditingController? controller;
  const Textfield(
      {Key? key,
      required this.label,
      required this.onChanged,
      required this.type,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.indigo),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          focusColor: Colors.white,
          fillColor: Colors.indigo[100],
          filled: true,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w300,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
