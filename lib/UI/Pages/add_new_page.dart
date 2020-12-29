import 'dart:math';

import 'package:debts/Services/Database.dart';
import 'package:debts/UI/widgets/date_picker.dart';
import 'package:debts/consts.dart';
import 'package:debts/models/debts.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_switch/sliding_switch.dart';

class AddNew extends StatefulWidget {
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  TextEditingController _fullName = TextEditingController();
  TextEditingController _amount = TextEditingController();
  String _dueDate;
  String _startDate;
  String _docType = "Owned";

  @override
  void initState() {
    _startDate = DateFormat.yMMMd().format(DateTime.now());
    _dueDate = DateFormat.yMMMd().format(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: secondaryText,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SlidingSwitch(
                    value: false,
                    width: 250,
                    onChanged: (bool value) {
                      if (value) {
                        setState(() {
                          _docType = "Owned";
                        });
                      } else {
                        setState(() {
                          _docType = "Ownes";
                        });
                      }
                      print(_docType);
                    },
                    height: MediaQuery.of(context).size.height * 0.07,
                    animationDuration: const Duration(milliseconds: 400),
                    textOff: "Ownes",
                    textOn: "Owned",
                    colorOn: primaryGreen,
                    colorOff: primaryGreen,
                    background: const Color(0xffe4e5eb),
                    buttonColor: const Color(0xfff7f5f7),
                    inactiveColor: const Color(0xff636f7b),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _fullName,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: secondaryText),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _amount,
                    cursorColor: secondaryText,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: secondaryText),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryGreen, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextFieldDatePicker(
                    labelText: "Date",
                    prefixIcon: Icon(Icons.date_range),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    lastDate: DateTime.now().add(Duration(days: 366)),
                    firstDate: DateTime.now(),
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    onDateChanged: (selectedDate) {
                      setState(() {
                        _dueDate = DateFormat.yMMMd().format(selectedDate);
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color: primaryGreen,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.3,
                          vertical: 15.0),
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    splashColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    onPressed: () {
                      Random random = new Random();
                      int randomNumber = random.nextInt(10000);
                      var newDbDebt = Debt(
                          id: randomNumber,
                          fullname: _fullName.text,
                          amount: int.parse(_amount.text),
                          duedate: _dueDate,
                          startdate: _startDate,
                          type: _docType,
                          status: "notCompleted");
                      DBProvider.db.newDebt(newDbDebt);
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
