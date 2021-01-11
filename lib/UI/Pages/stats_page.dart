import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debts/consts.dart';
import 'package:debts/models/debts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  CollectionReference debts;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    final User user = auth.currentUser;
    final uid = user.uid;
    debts = FirebaseFirestore.instance.collection(uid);
    super.initState();
  }

  Future<String> _getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getcurrency = prefs.getString('currency');
    return getcurrency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
          stream: debts.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            int _totalOwed = 0;
            int _totalOwes = 0;
            int _owesPayed = 0;
            int _owesOngoing = 0;
            int _owedPayed = 0;
            int _owedOngoing = 0;
            int _balance = 0;
            snapshot.data.docs.forEach((value) {
              if (value.data()['type'] == 'Owed') {
                _totalOwed = _totalOwed + value.data()['amount'];
                if (value.data()['status'] == 'Completed') {
                  _owedPayed = _owedPayed + value.data()['amount'];
                } else if (value.data()['status'] == 'notCompleted') {
                  _owedOngoing = _owedOngoing + value.data()['amount'];
                }
              } else if (value.data()['type'] == 'Owes') {
                _totalOwes = _totalOwes + value.data()['amount'];
                if (value.data()['status'] == 'Completed') {
                  _owesPayed = _owesPayed + value.data()['amount'];
                } else if (value.data()['status'] == 'notCompleted') {
                  _owesOngoing = _owesOngoing + value.data()['amount'];
                }
              }
            });
            _balance = _totalOwed - _totalOwes;
            print('total owes');
            print(_totalOwes);
            print('owes payed');
            print(_owesPayed);
            print('owes ongoing');
            print(_owesOngoing);
            print('total owed');
            print(_totalOwed);
            print('owed payed');
            print(_owedPayed);
            print('owed ongoing');
            print(_owedOngoing);
            print('balance');
            print(_balance);
            return FutureBuilder(
              future: _getCurrency(),
              builder: (BuildContext context, AsyncSnapshot futuresnapshot) {
                if (futuresnapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Card(
                        elevation: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 5.0),
                          child: Center(
                            child: Text(
                              'Balance: ' +
                                  _balance.toString() +
                                  ' ' +
                                  futuresnapshot.data,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _balance > 0 ? primaryGreen : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Total owed by me',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _totalOwes.toString() +
                                        ' ' +
                                        futuresnapshot.data,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Payed: ' +
                                        _owesPayed.toString() +
                                        ' ' +
                                        futuresnapshot.data,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: primaryGreen,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'On Going: ' +
                                        _owesOngoing.toString() +
                                        ' ' +
                                        futuresnapshot.data,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Total owed to me',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    _totalOwed.toString() +
                                        ' ' +
                                        futuresnapshot.data,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Payed: ' +
                                        _owedPayed.toString() +
                                        ' ' +
                                        futuresnapshot.data,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: primaryGreen,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'On Going: ' +
                                        _owedOngoing.toString() +
                                        ' ' +
                                        futuresnapshot.data,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ));
  }
}
