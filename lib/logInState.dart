import 'package:expences/logIn.dart';
import 'package:expences/mainScreen.dart';
import 'package:expences/store.dart';
import 'package:flutter/material.dart';

class LogInState extends StatefulWidget {
  const LogInState({Key? key}) : super(key: key);

  @override
  _LogInStateState createState() => _LogInStateState();
}

class _LogInStateState extends State<LogInState> {
  Store data = Store();
  Widget currentPage = LogIn();
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    String? catogary = await data.getData();

    if (catogary != null) {
      setState(() {
        currentPage = DataScreen(catogary: catogary);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return currentPage;
  }
}
