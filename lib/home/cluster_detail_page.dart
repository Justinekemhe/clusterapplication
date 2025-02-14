import 'package:clusterapplication/home/cluster_features_page.dart';
import 'package:clusterapplication/home/users_page.dart';
import 'package:clusterapplication/models/cluster.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ClusterDetailPage extends StatefulWidget {
  Clusters cluster;

  ClusterDetailPage(this.cluster);

  @override
  _ClusterDetailPageState createState() => _ClusterDetailPageState();
}

class _ClusterDetailPageState extends State<ClusterDetailPage> {
  int initialIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      initialIndex = index;
    });
  }

  Widget callPages(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return UsersPage(widget.cluster);
      case 1:
        return ClusterFeaturesPage(widget.cluster);
      case 2:
        return ChatPage();
      default:
        return UsersPage(widget.cluster);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taarifa zaidi za ${widget.cluster.name}"),
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
              icon: Icon(Icons.home_outlined), label: "Watumiaji"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: "Vipengele"),
          BottomNavigationBarItem(icon: Icon(Icons.border_all), label: "Chati"),
        ],
      ),
    );
  }
}
