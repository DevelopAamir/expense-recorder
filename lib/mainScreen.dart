import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expences/logIn.dart';
import 'package:expences/logInState.dart';
import 'package:expences/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'dataManager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final typeEditingController = TextEditingController();
  final amountEditingController = TextEditingController();
  final itemEditingController = TextEditingController();
  late String loggedinUser;
  bool spin = false;
  String amount = '';
  String type = '';

  String now = DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());
  String item = '';
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedinUser = user.email.toString();
        print(loggedinUser);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> uploadExpenses() async {
      if (amount != '' && item != '') {
        try {
          setState(() {
            spin = true;
          });

          _firestore.collection(loggedinUser).add({
            'amount': 'Rs. $amount',
            'type': type,
            'time': now,
            'item': item
          });

          setState(() {
            spin = false;
          });
          Fluttertoast.showToast(msg: 'Data Added Successfully');

          Navigator.pop(context);
        } catch (e) {
          setState(() {
            spin = false;
          });
          print(e.toString());
          Fluttertoast.showToast(msg: e.toString());
        }
      } else {
        Fluttertoast.showToast(msg: 'Fill all the requirements');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Data'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 50.0, horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Add Data', style: TextStyle(fontSize: 40.0)),
                    ),
                    SizedBox(height: 50.0),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Textfield(
                            controller: typeEditingController,
                            label: "Type",
                            onChanged: (value) {
                              print(value);
                              type = value;
                            },
                            type: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Textfield(
                            controller: amountEditingController,
                            label: "Amount",
                            onChanged: (value) {
                              print(value);
                              amount = value;
                            },
                            type: TextInputType.number,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Textfield(
                            controller: itemEditingController,
                            label: "Item",
                            onChanged: (value) {
                              print(value);
                              item = value;
                            },
                            type: TextInputType.emailAddress,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.indigo),
                        ),
                        onPressed: () async {
                          typeEditingController.clear();
                          amountEditingController.clear();
                          itemEditingController.clear();

                          uploadExpenses();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class DataScreen extends StatelessWidget {
  final String catogary;

  const DataScreen({
    Key? key,
    required this.catogary,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    void signOut() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Do you want to Log Out?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: Text('No'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                    auth.signOut();
                    Store().logOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogInState()),
                    );
                  },
                  child: Text('Yes'))
            ],
          );
        },
      );
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

    return WillPopScope(
      onWillPop: _onBackpressed,
      child: Scaffold(
          backgroundColor: Colors.indigo,
          appBar: AppBar(
            title: Text('Expense Recorder'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
                  },
                  icon: Icon(Icons.add)),
              IconButton(onPressed: signOut, icon: Icon(Icons.logout))
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TableHeading(
                  date: 'Date', type: 'Type', item: 'Item', amount: 'Amount'),
              Streambuild(
                catogary: catogary,
              ),
            ],
          )),
    );
  }
}
