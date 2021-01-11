import 'dart:ui';
import 'package:debts/UI/Pages/add_new_page.dart';
import 'package:debts/UI/Pages/home_page.dart';
import 'package:debts/UI/Pages/settings_page.dart';
import 'package:debts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          color: primaryGreen,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Icon(Icons.person,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height * 0.12),
                auth.currentUser != null
                    ? Text(
                        auth.currentUser.email,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Settings()));
          },
          leading: Icon(Icons.settings, color: secondaryText),
          title: Text(
            'Settings',
            style: TextStyle(
              color: secondaryText,
              fontSize: 18,
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddNew(index: 1)));
          },
          leading: Icon(Icons.add, color: secondaryText),
          title: Text(
            'Add',
            style: TextStyle(
              color: secondaryText,
              fontSize: 18,
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage(index: 2)));
          },
          leading: Icon(Icons.stacked_bar_chart, color: secondaryText),
          title: Text(
            'Stats',
            style: TextStyle(
              color: secondaryText,
              fontSize: 18,
            ),
          ),
        ),
        ListTile(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            ;
          },
          leading: Icon(Icons.exit_to_app, color: secondaryText),
          title: Text(
            'Sign out',
            style: TextStyle(
              color: secondaryText,
              fontSize: 18,
            ),
          ),
        ),
        ListTile(
          onTap: () {
            SystemNavigator.pop();
          },
          leading: Icon(Icons.close, color: secondaryText),
          title: Text(
            'Quit',
            style: TextStyle(
              color: secondaryText,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
