import 'dart:ui';

import 'package:debts/Services/Database.dart';
import 'package:debts/consts.dart';
import 'package:debts/models/debts.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Future _debtfutur;
  @override
  void initState() {
    super.initState();
    _debtfutur = getDebts();
  }

  getDebts() async {
    final _debtDatas = await DBProvider.db.getDebt();
    print(_debtDatas);
    return _debtDatas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _debtfutur,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Container();
                break;
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.done:
                if (snapshot.data != null) {
                  int _totalOwed = 0;
                  int _totalOwes = 0;
                  int _owesPayed = 0;
                  int _owesOngoing = 0;
                  int _owedPayed = 0;
                  int _owedOngoing = 0;
                  int _balance = 0;
                  for (int i = 0; i < snapshot.data.length; i++) {
                    if (snapshot.data[i]['type'] == 'Owned') {
                      _totalOwed = _totalOwed + snapshot.data[i]['amount'];
                      if (snapshot.data[i]['status'] == 'Completed') {
                        _owedPayed = _owedPayed + snapshot.data[i]['amount'];
                      } else if (snapshot.data[i]['status'] == 'notCompleted') {
                        _owedOngoing =
                            _owedOngoing + snapshot.data[i]['amount'];
                      }
                    } else if (snapshot.data[i]['type'] == 'Ownes') {
                      _totalOwes = _totalOwes + snapshot.data[i]['amount'];

                      if (snapshot.data[i]['status'] == 'Completed') {
                        _owesPayed = _owesPayed + snapshot.data[i]['amount'];
                      } else if (snapshot.data[i]['status'] == 'notCompleted') {
                        _owesOngoing =
                            _owesOngoing + snapshot.data[i]['amount'];
                      }
                    }
                  }
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
                              'Balance: ' + _balance.toString() + ' \$',
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
                                    _totalOwed.toString() + ' \$',
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
                                    'Payed: ' + _owesPayed.toString() + ' \$',
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
                                        ' \$',
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
                                    _totalOwed.toString() + ' \$',
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
                                    'Payed: ' + _owedPayed.toString() + ' \$',
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
                                        ' \$',
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
                } else if (snapshot.data == null) {
                  return Container();
                }
                break;
            }
          }),
    );
  }
}
