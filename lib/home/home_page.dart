import 'package:clusterapplication/auth/login_page.dart';
import 'package:clusterapplication/auth/profile_page.dart';
import 'package:clusterapplication/home/cluster_page.dart';
import 'package:clusterapplication/home/dashboard_page.dart';
import 'package:clusterapplication/home/features_page.dart';
import 'package:clusterapplication/home/post_page.dart';
import 'package:clusterapplication/home/report_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  int initialIndex;
  HomePage(this.initialIndex);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences preferences;
  late bool _isLogged;
  String _name = "", _email = "";
  String title = "Clustering";
  List<Widget> pages = [
    ReportPage(),
    ClusterPage(),
    FeaturesPage(),
    DashboardPage(),
    PostPage(),
  ];

  Future<String?> getUserName() async {
    preferences = await SharedPreferences.getInstance();
    var name = preferences.getString('name');
    return name;
  }

  void updateUserName(String value) {
    setState(() {
      _name = value;
    });
  }

  void updateUserEmail(String value) {
    setState(() {
      _email = value;
    });
  }

  Future<String?> getUserEmail() async {
    preferences = await SharedPreferences.getInstance();
    var email = preferences.getString('email');
    return email;
  }

  void isUserLoggedIn() async {
    preferences = await SharedPreferences.getInstance();
    _isLogged = preferences.getBool('isLoggedIn')!;

    if (!_isLogged) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    isUserLoggedIn();
    getUserEmail().then((value) => updateUserEmail(value!));
    getUserName().then((value) => updateUserName(value!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_name),
              accountEmail: Text(_email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  _name[0].toUpperCase(),
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: Text("Mwanzoni"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Text(
                'Akaunti',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              title: Text("Wasifu"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.grey,
              ),
              title: Text("Ondoka"),
              onTap: () {
                showLogoutDialog(context);
              },
            )
          ],
        ),
      ),
      body: pages[widget.initialIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.70),
        selectedFontSize: 16,
        unselectedFontSize: 13,
        currentIndex: widget.initialIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Mwanzo"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: "Kundi"),
          BottomNavigationBarItem(
              icon: Icon(Icons.border_all), label: "Vipengele"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: "Dashibodi"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode), label: "Sasisho"),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      widget.initialIndex = index;
      switch (index) {
        case 0:
          {
            title = 'Clustering';
          }
          break;
        case 1:
          {
            title = 'Kundi';
          }
          break;
        case 2:
          {
            title = 'Vipengele';
          }
          break;
        case 3:
          {
            title = 'Dashibodi';
          }
          break;
        case 4:
          {
            title = 'Sasisho';
          }
          break;
      }
    });
  }

  Future<void> signOut() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool("isLoggedIn", false);
    });
    // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login()));
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation animation, Animation secondaryAnimation) {
          return LoginPage();
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }),
        (Route route) => false);
  }

  void showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ondoka"),
        content: Text("Una uhakika kwamba, unataka kutoka nje ya aplikasheni"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              print("Ondoka");
              signOut();
            },
            child: Text("NDIYO"),
          ),
        ],
      ),
    );
  }
}
