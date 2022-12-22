import 'package:expences/mainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'logIn.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Signup extends StatefulWidget {
  // const LogIn({ Key? key }) : super(key: key);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  final toastMessageEditingController = TextEditingController();
  late String loggedinUser;
  var password = '';
  String email = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
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

    void register() async {
      if (email != '' && password != '' && confirmPassword != '') {
        if (password == confirmPassword) {
          try {
            final User? user = (await auth.createUserWithEmailAndPassword(
                    email: email, password: password))
                .user;

            if (user == null) {
            } else {
              Fluttertoast.showToast(msg: 'Account Created');
              getCurrentUser();

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DataScreen(
                          catogary: loggedinUser,
                        )),
              );
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
                "[firebase_auth/weak-password] password should be at least 6 characters") {
              Fluttertoast.showToast(
                  msg: 'password must be at least6 6 characters');
            } else {
              Fluttertoast.showToast(msg: 'Something wents wrong');
            }

            print(e);
          }
        } else {
          Fluttertoast.showToast(
              msg: 'fill both password ande confirm password with same value');
        }
      } else {
        Fluttertoast.showToast(msg: 'fill out the blanks');
      }
    }

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
      child: ListView(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.indigo, fontSize: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Textfield(
                      controller: emailEditingController,
                      label: "Enter Email",
                      onChanged: (value) {
                        print(value);
                        email = value;
                      },
                      type: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Textfield(
                        controller: passwordEditingController,
                        type: TextInputType.visiblePassword,
                        onChanged: (value) {
                          password = value;
                        },
                        label: "Enter Password",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Textfield(
                        controller: confirmPasswordEditingController,
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                        label: "Confirm Password",
                        type: TextInputType.visiblePassword,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                ),
                onPressed: () async {
                  emailEditingController.clear();
                  passwordEditingController.clear();
                  confirmPasswordEditingController.clear();

                  register();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have account?"),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Login",
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            )
          ],
        ),
      ]),
    ));
  }
}
