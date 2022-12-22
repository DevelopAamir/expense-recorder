import 'dart:io';

import 'package:expences/logInState.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget currentScreen = Splash();

  @override
  void initState() {
    change();
    super.initState();
  }

  change() async {
    await Future.delayed(Duration(seconds: 3), () {});

    setState(() {
      currentScreen = LogInState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentScreen;
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Expense Recorder',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Image(
              image: AssetImage('images/R.png'),
            ),
          ],
        ),
      ),
    );
  }
}
