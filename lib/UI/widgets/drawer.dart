import 'dart:ui';
import 'package:debts/UI/Pages/home_page.dart';
import 'package:debts/UI/Pages/welcome_page.dart';
import 'package:debts/consts.dart';
import 'package:flutter/material.dart';

class myDrawer extends StatefulWidget {
  @override
  _myDrawerState createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.2,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ListTile(
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
