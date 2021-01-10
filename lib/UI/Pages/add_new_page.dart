import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debts/Services/validators.dart';
import 'package:debts/UI/Pages/home_page.dart';
import 'package:debts/UI/widgets/date_picker.dart';
import 'package:debts/consts.dart';
import 'package:debts/models/debts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sliding_switch/sliding_switch.dart';

class AddNew extends StatefulWidget {
  final int index;

  const AddNew({Key key, @required this.index}) : super(key: key);
  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _amount = TextEditingController();
  String _dueDate, _fullNameString;
  String _amountInt;
  String _startDate;
  String _docType = "Owes";

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() {
    if (validate()) {
      Random random = new Random();
      int randomNumber = random.nextInt(10000);
      print(_amountInt);
      print(_fullNameString);
      print(_dueDate);
      print(_startDate);
      print(_docType);
      print(randomNumber);
      var newDbDebt = Debt(
          fullname: _fullNameString,
          amount: int.parse(_amountInt),
          duedate: _dueDate,
          startdate: _startDate,
          type: _docType,
          status: "notCompleted");
      addDebts(newDbDebt);
    }
  }

  Future<void> addDebts(Debt debt) {
    final User user = auth.currentUser;
    final uid = user.uid;
    print('user id :' + uid);
    CollectionReference users = FirebaseFirestore.instance.collection(uid);
    return users
        .add({
          'id': debt.id,
          'fullname': debt.fullname,
          'amount': debt.amount,
          'duedate': debt.duedate,
          'startdate': debt.startdate,
          'type': debt.type,
          'status': debt.status,
          // 42
        })
        .then((value) => navigate())
        .catchError((error) => print("Failed to add user: $error"));
  }

  navigate() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
                  index: widget.index,
                )));
  }

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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SlidingSwitch(
                      value: false,
                      width: 250,
                      onChanged: (bool value) {
                        if (value) {
                          setState(() {
                            _docType = "Owed";
                          });
                        } else {
                          setState(() {
                            _docType = "Owes";
                          });
                        }
                        print(_docType);
                      },
                      height: MediaQuery.of(context).size.height * 0.07,
                      animationDuration: const Duration(milliseconds: 400),
                      textOff: "Owes",
                      textOn: "Owed",
                      colorOn: primaryGreen,
                      colorOff: primaryGreen,
                      background: const Color(0xffe4e5eb),
                      buttonColor: const Color(0xfff7f5f7),
                      inactiveColor: const Color(0xff636f7b),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: Validator.validate,
                      onSaved: (value) => _fullNameString = value,
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
                    TextFormField(
                      validator: Validator.validate,
                      onSaved: (value) => _amountInt = value,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
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
                        submit();
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.20,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
