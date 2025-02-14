import 'package:clusterapplication/models/user_data.dart';
import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  Users user;
  UserInfoPage(this.user);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text("Jina"),
          subtitle: Text(widget.user.name),
        ),
        ListTile(
          title: Text("Barua pepe"),
          subtitle: Text(widget.user.email),
        ),
        ListTile(
          title: Text("Simu"),
          subtitle: Text(widget.user.phoneNumber),
        )
      ],
    );
  }
}
