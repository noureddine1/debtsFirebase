import 'dart:ui';

import 'package:debts/Services/Database.dart';
import 'package:debts/consts.dart';
import 'package:debts/models/debts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sliding_switch/sliding_switch.dart';

class OwnedPage extends StatefulWidget {
  @override
  _OwnedPageState createState() => _OwnedPageState();
}

class _OwnedPageState extends State<OwnedPage> {
  String _toShow = 'notCompleted';
  Map<String, dynamic> newDebt = {};
  Future _debtfutur;
  List<Debt> debts;

  @override
  void initState() {
    super.initState();
    _debtfutur = getOwnedDebt();
  }

  getOwnedDebt() async {
    final _debtDatas = await DBProvider.db.getOwnedDebt();
    print(_debtDatas);
    return _debtDatas;
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
    print(_double);
    return _double;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            textOn: "Completed",
            colorOn: Colors.red,
            colorOff: primaryGreen,
            background: const Color(0xffe4e5eb),
            buttonColor: const Color(0xfff7f5f7),
            inactiveColor: const Color(0xff636f7b),
          ),
        ),
        FutureBuilder(
            future: _debtfutur,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                  break;
                case ConnectionState.waiting:
                  return Container();
                  break;
                case ConnectionState.active:
                  return Container();
                  break;
                case ConnectionState.done:
                  List<Debt> debtstoShow = List<Debt>();
                  for (int i = 0; i < snapshot.data.length; i++) {
                    if (snapshot.data[i]['status'] == _toShow) {
                      Debt _debt = Debt();
                      _debt.amount = snapshot.data[i]['amount'];
                      _debt.duedate = snapshot.data[i]['duedate'];
                      _debt.fullname = snapshot.data[i]['fullname'];
                      _debt.startdate = snapshot.data[i]['startdate'];
                      _debt.type = snapshot.data[i]['type'];
                      _debt.status = snapshot.data[i]['status'];
                      _debt.id = snapshot.data[i]['id'];
                      debtstoShow.add(_debt);
                    }
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: debtstoShow.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  topLeft: Radius.circular(5.0)),
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5.0),
                                        topLeft: Radius.circular(5.0)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ListTile(
                                        trailing: Text(
                                          debtstoShow[index].amount.toString() +
                                              ' \$',
                                          style: TextStyle(
                                              fontSize: 25, color: Colors.blue),
                                        ),
                                        title: Text('Debtor: ' +
                                            debtstoShow[index].fullname),
                                        subtitle: Text(
                                          'due in ' +
                                              debtstoShow[index]
                                                  .duedate
                                                  .toString(),
                                          style: TextStyle(
                                              color: _percentCalculator(
                                                          index, debtstoShow) ==
                                                      1
                                                  ? Colors.red
                                                  : Colors.grey),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: LinearPercentIndicator(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.95,
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
                                color: primaryGreen,
                                icon: Icons.check,
                                onTap: () => {},
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () => {
                                  print(debtstoShow[index].duedate),
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                  break;
              }
            }),
      ],
    ));
  }
}
