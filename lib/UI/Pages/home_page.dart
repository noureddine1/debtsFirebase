import 'package:debts/UI/Pages/add_new_page.dart';
import 'package:debts/UI/Pages/owns_page.dart';
import 'package:debts/UI/Pages/stats_page.dart';
import 'package:debts/UI/widgets/drawer.dart';
import 'package:debts/consts.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'owned_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1;

  List listOfPages = [
    OwnedPage(),
    OwnsPage(),
    StatsPage(),
  ];
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
      drawer: Drawer(
        child: myDrawer(),
      ),
      body: listOfPages[currentIndex],
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: currentIndex,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Icons.account_balance_wallet),
              title: Text('Owned'),
              activeColor: primaryGreen,
              inactiveColor: primaryGreen,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.monetization_on),
              title: Text('Owns'),
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNew()));
        },
      ),
    );
  }
}
