import 'dart:ui';
import 'package:debts/UI/Pages/Authentication/forgot_password_page.dart';

import 'package:debts/UI/Pages/Authentication/signup_page.dart';
import 'package:debts/UI/Pages/home_page.dart';
import 'package:debts/consts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _isLogin = false;

  _setIsLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLogin', true);
    bool isLogin = (sharedPreferences.get('isLogin') ?? false);
    setState(() {
      _isLogin = isLogin;
    });
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
                  "Welcome Back!",
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
                  controller: emailController,
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
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  cursorColor: secondaryText,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      width: 2,
                    )),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: primaryGreen,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()));
                                }),
                        ],
                      ),
                    )
                  ],
                )
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
                      'LOGIN',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  splashColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  onPressed: () {
                    _setIsLogin();
                    if (_isLogin) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  },
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'New user? ',
                        style: TextStyle(
                          height: 2.5,
                          fontSize: 12.0,
                          color: secondaryText,
                        ),
                      ),
                      TextSpan(
                          text: 'Signup',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: primaryGreen,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignupPage()));
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
