import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _firestore = FirebaseFirestore.instance;

class Streambuild extends StatelessWidget {
  final String catogary;

  const Streambuild({
    Key? key,
    required this.catogary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection(
              catogary,
            )
            .snapshots(),
        builder: (context, snapshot) {
          List<Cards> messageWidget = [];
          if (snapshot.hasData) {
            final details = snapshot.data!.docs;

            for (var detail in details) {
              final id = detail.id;
              final amount = detail['amount'];
              final date = detail['time'];
              final item = detail['item'];
              final type = detail['type'];
              print(id);

              final textWidget = Cards(
                amount: amount,
                date: date.toString(),
                item: item,
                type: type,
                longPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Do you want to delete this entry?'),
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

                                _firestore
                                    .collection(catogary)
                                    .doc(id)
                                    .delete()
                                    .catchError((e) {
                                  print(e);
                                });
                                Fluttertoast.showToast(msg: 'Deleted');
                              },
                              child: Text('Yes'))
                        ],
                      );
                    },
                  );
                },
              );
              messageWidget.add(textWidget);
            }
          }
          return Expanded(child: ListView(children: messageWidget));
        });
  }
}

class Cards extends StatelessWidget {
  final VoidCallback longPress;
  final String date;
  final String type;
  final String item;
  final String amount;
  const Cards(
      {Key? key,
      required this.date,
      required this.type,
      required this.item,
      required this.amount,
      required this.longPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: longPress,
      child: Container(
          child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 5, bottom: 5.0),
              child: Center(
                  child: Text(
                date,
                style: TextStyle(fontSize: 10),
              )),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.indigo, width: 3)),
            ),
          ),
          Expanded(
            child: Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 5, bottom: 5.0),
              child: Center(child: Text(type)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.indigo, width: 3)),
            ),
          ),
          Expanded(
            child: Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 5, bottom: 5.0),
              child: Center(child: Text(amount)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.indigo, width: 3)),
            ),
          ),
          Expanded(
            child: Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 5, bottom: 5.0),
              child: Center(
                  child: Text(
                item,
              )),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.indigo, width: 3)),
            ),
          )
        ],
      )),
    );
  }
}

class TableHeading extends StatelessWidget {
  final String date;
  final String type;
  final String item;
  final String amount;
  const TableHeading(
      {Key? key,
      required this.date,
      required this.type,
      required this.item,
      required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Expanded(
          child: Container(
            height: 40.0,
            padding: EdgeInsets.only(top: 5, bottom: 5.0),
            child: Center(
                child: Text(
              date,
              style: TextStyle(fontSize: 10, color: Colors.white),
            )),
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.indigo, width: 2)),
          ),
        ),
        Expanded(
          child: Container(
            height: 40.0,
            padding: EdgeInsets.only(top: 5, bottom: 5.0),
            child: Center(
                child: Text(
              type,
              style: TextStyle(color: Colors.white),
            )),
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.indigo, width: 2)),
          ),
        ),
        Expanded(
          child: Container(
            height: 40.0,
            padding: EdgeInsets.only(top: 5, bottom: 5.0),
            child: Center(
                child: Text(amount, style: TextStyle(color: Colors.white))),
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.indigo, width: 2)),
          ),
        ),
        Expanded(
          child: Container(
            height: 40.0,
            padding: EdgeInsets.only(top: 5, bottom: 5.0),
            child: Center(
                child: Text(item, style: TextStyle(color: Colors.white))),
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.indigo, width: 2)),
          ),
        )
      ],
    ));
  }
}
