import 'package:clusterapplication/home/user_features_page.dart';
import 'package:clusterapplication/home/user_info_page.dart';
import 'package:clusterapplication/models/user_data.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatefulWidget {
  Users user;
  UserDetailPage(this.user);

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  int initialIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      initialIndex = index;
    });
  }

  Widget callPages(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return UserInfoPage(widget.user);
      case 1:
        return UserFeaturePage(widget.user);
      default:
        return UserInfoPage(widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wasifu wa ${widget.user.name} "),
      ),
      body: callPages(initialIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.70),
        selectedFontSize: 16,
        unselectedFontSize: 13,
        currentIndex: initialIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.verified_user_rounded), label: "Mtumiaji"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: "Vipengele"),
        ],
      ),
    );
  }
}
