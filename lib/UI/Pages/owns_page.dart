import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debts/consts.dart';
import 'package:debts/models/debts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';

class OwnsPage extends StatefulWidget {
  @override
  _OwnsPageState createState() => _OwnsPageState();
}

class _OwnsPageState extends State<OwnsPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String _toShow = 'notCompleted';
  CollectionReference debts;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool shouldNotify;

  @override
  void initState() {
    super.initState();
    final User user = auth.currentUser;
    final uid = user.uid;
    debts = FirebaseFirestore.instance.collection(uid);
  }

  Future<bool> _getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool getStatus = prefs.getBool('notifications');
    return getStatus;
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
    todayDate = DateTime.now();
    if (dueDate.difference(startDate).inDays == 0) {
      print(dueDate.difference(startDate).inDays);
      _double = 1;
    } else {
      _double = todayDate.difference(startDate).inDays /
          dueDate.difference(startDate).inDays;
    }
    print('double');
    print(_double);
    return _double;
  }

  Future<String> _getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String getcurrency = prefs.getString('currency');
    return getcurrency;
  }

  Future showNotfication(int index, String dueDateString, String debtor) async {
    DateTime dueDate;
    DateTime addeddueDate;
    DateTime now;
    now = DateTime.now();
    dueDate = DateFormat.yMMMd().parse(dueDateString);
    print('duedate');
    print(dueDate);
    print('now');
    print(now);
    print('difference');
    print(dueDate.difference(now).inHours);

    if (dueDate.difference(now).inHours > 15) {
      addeddueDate = dueDate.subtract(Duration(hours: 15));
      var androidDetails = AndroidNotificationDetails(
        'channel Id',
        'Local Notfication',
        'the channel description',
        importance: Importance.high,
      );
      var notificationDetails = NotificationDetails(android: androidDetails);
      await flutterLocalNotificationsPlugin.schedule(index, debtor,
          'due in ' + dueDateString, addeddueDate, notificationDetails);
    }
  }

  Future cancelNotification(int index) async {
    await flutterLocalNotificationsPlugin.cancel(index);
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
                if (value.data()['type'] == 'Owes') {
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
                    _notify() async {
                      shouldNotify = await _getNotification();
                      print(shouldNotify);
                      if (shouldNotify) {
                        if (debtstoShow[index].status == 'notCompleted') {
                          showNotfication(index, debtstoShow[index].duedate,
                              debtstoShow[index].fullname);
                        }
                      }
                    }

                    _notify();

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
                                        return Container();
                                      },
                                    ),
                                    // trailing: Text(
                                    //   debtstoShow[index].amount.toString() +
                                    //       ' \$',
                                    //   style: TextStyle(
                                    //       fontSize: 25, color: Colors.blue),
                                    // ),
                                    title: Text('Creditor: ' +
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
                            caption: 'Paid',
                            color: Colors.white,
                            foregroundColor: secondaryText,
                            iconWidget: Icon(Icons.check, color: secondaryText),
                            onTap: () {
                              cancelNotification(index);
                              debtstoShow[index].status = 'Completed';
                              _updateDebt(debtstoShow[index]);
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.white,
                            foregroundColor: secondaryText,
                            iconWidget: Icon(
                              Icons.delete,
                              color: secondaryText,
                            ),
                            onTap: () {
                              cancelNotification(index);
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
