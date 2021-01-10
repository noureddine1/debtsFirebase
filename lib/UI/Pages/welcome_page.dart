import 'dart:ui';
import 'package:debts/UI/Pages/Authentication/login_page.dart';
import 'package:debts/UI/Pages/Authentication/signup_page.dart';
import 'package:debts/UI/Pages/home_page.dart';
import 'package:debts/consts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Log in to your account",
                  style: TextStyle(fontSize: 16, color: primaryText),
                ),
                Text(
                  "Log in to your account",
                  style: TextStyle(fontSize: 30, color: primaryGreen),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/login.png',
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            fit: BoxFit.fill,
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
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  splashColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            height: 2.5,
                            fontSize: 12.0,
                            color: secondaryText,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignupPage()));
                              ;
                            }),
                    ],
                  ),
                ),
                // FlatButton(
                //   onPressed: () {},
                //   child: Text(

                //     "Terms & Conditions",

                //     style: TextStyle(fontSize: 12, color: secondaryText),
                //   ),
                // ),
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
