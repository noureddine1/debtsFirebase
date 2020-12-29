import 'package:debts/consts.dart';

import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';

class OwnsPage extends StatefulWidget {
  @override
  _OwnsPageState createState() => _OwnsPageState();
}

class _OwnsPageState extends State<OwnsPage> {
  String _uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
        ),
        SlidingSwitch(
          value: false,
          width: 250,
          onChanged: (bool value) {
            print(value);
          },
          height: MediaQuery.of(context).size.height * 0.07,
          animationDuration: const Duration(milliseconds: 400),
          textOff: "On Going",
          textOn: "Completed",
          colorOn: Colors.red,
          colorOff: primaryGreen,
          background: const Color(0xffe4e5eb),
          buttonColor: const Color(0xfff7f5f7),
          inactiveColor: const Color(0xff636f7b),
        ),
      ],
    );
  }
}
