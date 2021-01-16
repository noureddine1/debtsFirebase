import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:debts/consts.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String currency = 'S';
  bool status;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool getStatus = prefs.getBool('notifications');
    if (getStatus == null) {
      getStatus = true;
    }
    return getStatus;
  }

  _setNotfication(bool notif) async {
    print('setting notification');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', notif);
  }

  _setCurrency(String currencySymbol) async {
    print('setting notification');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currencySymbol);
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: secondaryText,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Settings',
            style: TextStyle(
              color: secondaryText,
            )),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Notifications',
                style: TextStyle(color: secondaryText, fontSize: 25),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              FutureBuilder(
                future: _getNotification(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    status = snapshot.data;
                    return CustomSwitch(
                      activeColor: primaryGreen,
                      value: status,
                      onChanged: (value) async {
                        _setNotfication(value);
                        if (!value) {
                          await flutterLocalNotificationsPlugin.cancelAll();
                        }
                        print(snapshot.data);
                        setState(() {
                          status = value;
                        });
                      },
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Currency',
                style: TextStyle(color: secondaryText, fontSize: 25),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
              ),
              RaisedButton(
                  color: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: FutureBuilder(
                    future: _getCurrency(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        currency = snapshot.data;
                        return Text(
                          currency,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        );
                      }
                      return Container();
                    },
                  ),
                  onPressed: () => showCurrencyPicker(
                        context: context,
                        showFlag: false,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                        onSelect: (Currency currenc) {
                          print('Select currency: ${currenc.symbol}');
                          setState(() {
                            currency = currenc.symbol;
                          });
                          _setCurrency(currenc.symbol);
                        },
                      )),
            ],
          ),
        ],
      ),
    );
  }
}
