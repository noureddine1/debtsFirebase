import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debts/consts.dart';
import 'package:debts/models/debts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';

class OwnedPage extends StatefulWidget {
  @override
  _OwnedPageState createState() => _OwnedPageState();
}

class _OwnedPageState extends State<OwnedPage> {
  String _toShow = 'notCompleted';
  CollectionReference debts;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    debts = FirebaseFirestore.instance.collection(uid);
  }

  _updateDebt(Debt _debt) async {
    debts
        .doc(_debt.id)
        .set({
          'id': _debt.id,
          'fullname': _debt.fullname,
          'amount': _debt.amount,
          'duedate': _debt.duedate,
          'startdate': _debt.startdate,
          'type': _debt.type,
          'status': _debt.status,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  _deleteDebt(String id) async {
    debts
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  double _percentCalculator(int index, List<Debt> list) {
    DateTime dueDate;
    DateTime startDate;
    DateTime todayDate;
    double _double;
    dueDate = DateFormat.yMMMd().parse(list[index].duedate);
    startDate = DateFormat.yMMMd().parse(list[index].startdate);
    print('due date ');
    print(dueDate);
    todayDate = DateTime.now();
    print('difference today date and due ');
    print(todayDate.difference(dueDate).inDays);
    if (todayDate.difference(dueDate).inDays >= 0) {
      _double = 1;
    } else {
      _double = todayDate.difference(startDate).inDays /
          dueDate.difference(startDate).inDays;
    }
    print(_double);
    return _double;
  }

  Future<String> _getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getcurrency = prefs.getString('currency');
    if (getcurrency == null) {
      getcurrency = '\$';
    }
    return getcurrency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SlidingSwitch(
              value: false,
              width: 250,
              onChanged: (bool value) {
                if (value) {
                  setState(() {
                    _toShow = 'Completed';
                  });
                } else if (!value) {
                  setState(() {
                    _toShow = 'notCompleted';
                  });
                }
                print(_toShow);
              },
              height: MediaQuery.of(context).size.height * 0.07,
              animationDuration: const Duration(milliseconds: 400),
              textOff: "On Going",
              textOn: "Paid",
              colorOn: Colors.red,
              colorOff: primaryGreen,
              buttonColor: const Color(0xfff7f5f7),
              inactiveColor: const Color(0xff636f7b),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: debts.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<Debt> debtstoShow = List<Debt>();
              snapshot.data.docs.forEach((value) {
                String id = value.id;
                print(id);
                if (value.data()['type'] == 'Owed') {
                  if (value.data()['status'] == _toShow) {
                    Debt _debt = Debt();
                    _debt.amount = value.data()['amount'];
                    _debt.duedate = value.data()['duedate'];
                    _debt.fullname = value.data()['fullname'];
                    _debt.startdate = value.data()['startdate'];
                    _debt.type = value.data()['type'];
                    _debt.status = value.data()['status'];
                    _debt.id = value.id;
                    debtstoShow.add(_debt);
                  }
                }
              });
              return Expanded(
                child: ListView.builder(
                  itemCount: debtstoShow.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Card(
                          child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListTile(
                                    trailing: FutureBuilder(
                                      future: _getCurrency(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          String currency = snapshot.data;
                                          return Text(
                                            debtstoShow[index]
                                                    .amount
                                                    .toString() +
                                                ' ' +
                                                currency,
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.blue,
                                            ),
                                          );
                                        }
                                        return Container(
                                          height: 1,
                                          width: 1,
                                        );
                                      },
                                    ),
                                    title: Text('Debtor: ' +
                                        debtstoShow[index].fullname),
                                    subtitle: Text(
                                      'due in ' +
                                          debtstoShow[index].duedate.toString(),
                                      style: TextStyle(
                                          color: _percentCalculator(
                                                      index, debtstoShow) ==
                                                  1
                                              ? Colors.red
                                              : Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.93,
                                        lineHeight: 7.0,
                                        percent: _percentCalculator(
                                            index, debtstoShow),
                                        clipLinearGradient: true,
                                        linearGradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              primaryGreen,
                                              Colors.red
                                            ])),
                                  ),
                                ],
                              )),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Completed',
                            color: Colors.white,
                            iconWidget: Icon(Icons.check),
                            onTap: () {
                              debtstoShow[index].status = 'Completed';
                              _updateDebt(debtstoShow[index]);
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.white,
                            iconWidget: Icon(Icons.delete),
                            onTap: () {
                              _deleteDebt(debtstoShow[index].id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
