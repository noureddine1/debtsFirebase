import 'dart:ui';

import 'package:debts/UI/Pages/add_new_page.dart';
import 'package:debts/UI/Pages/owns_page.dart';
import 'package:debts/UI/Pages/stats_page.dart';
import 'package:debts/UI/widgets/drawer.dart';
import 'package:debts/consts.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'owned_page.dart';

class HomePage extends StatefulWidget {
  final int index;

  const HomePage({Key key, @required this.index}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd _bannerAd;
  BannerAd _bannerAdbuild() {
    return BannerAd(
        adUnitId: "ca-app-pub-9445708218348599/2752337998",
        size: AdSize.fullBanner,
        listener: (MobileAdEvent event) {
          _bannerAd..show();
        });
  }

  int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-9445708218348599~6691583008");
    _bannerAd = _bannerAdbuild()..load();
  }

  List listOfPages = [
    OwnedPage(),
    OwnsPage(),
    StatsPage(),
  ];

  Widget _title() {
    if (currentIndex == 1)
      return Text('Borrowed',
          style: TextStyle(
            color: secondaryText,
          ));
    else if (currentIndex == 0)
      return Text('Lend',
          style: TextStyle(
            color: secondaryText,
          ));
    else if (currentIndex == 2)
      return Text('Statistics',
          style: TextStyle(
            color: secondaryText,
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: secondaryText,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: _title(),
        ),
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: MyDrawer(),
        ),
        body: listOfPages[currentIndex],
        bottomNavigationBar: BottomNavyBar(
            selectedIndex: currentIndex,
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                icon: Icon(Icons.account_balance_wallet),
                title: Text('Lend'),
                activeColor: primaryGreen,
                inactiveColor: primaryGreen,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.monetization_on),
                title: Text('Borrowed'),
                activeColor: primaryGreen,
                inactiveColor: primaryGreen,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.insert_chart),
                title: Text('Stats'),
                activeColor: primaryGreen,
                inactiveColor: primaryGreen,
              ),
            ],
            onItemSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryGreen,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNew(index: currentIndex)));
          },
        ),
      ),
    );
  }
}
