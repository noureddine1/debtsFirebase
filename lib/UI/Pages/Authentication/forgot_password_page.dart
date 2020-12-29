import 'dart:ui';

import 'package:debts/consts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: secondaryText,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your email to reset the password",
                  style: TextStyle(fontSize: 30, color: primaryText),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  cursorColor: secondaryText,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  height: 10,
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                RaisedButton(
                  color: primaryGreen,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.3,
                        vertical: 15.0),
                    child: Text(
                      'SEND',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  splashColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  onPressed: () {},
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Back to login',
                          style: TextStyle(
                            height: 2.5,
                            fontSize: 12.0,
                            color: secondaryText,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Privacy Policy"');
                            }),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          )
        ],
      )),
    );
  }
}
