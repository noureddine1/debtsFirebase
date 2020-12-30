import 'package:debts/UI/Pages/home_page.dart';
import 'package:debts/UI/Pages/Authentication/login_page.dart';
import 'package:debts/UI/Pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _isLogin = false;
  _checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin = (sharedPreferences.get('isLogin') ?? false);
    setState(() {
      _isLogin = isLogin;
    });
  }

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLogin) {
      return HomePage(
        index: 1,
      );
    } else {
      return WelcomePage();
    }
  }
}
