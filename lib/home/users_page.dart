import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/home/user_detail_page.dart';
import 'package:clusterapplication/models/cluster.dart';
import 'package:clusterapplication/models/user_data.dart';
import 'package:clusterapplication/widgets/circular_progress_indicator.dart';
import 'package:clusterapplication/widgets/error_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  final Clusters cluster;
  UsersPage(this.cluster);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<Users>> usersFuture;

  Future<List<Users>> getUsers() async {
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.get(
        Uri.parse(AppConfig.GET_CLUSTER_USERS + "/${widget.cluster.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
        });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      UserData userData = UserData.fromJson(data);
      return userData.users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    usersFuture = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          usersFuture = getUsers();
        });
      },
      child: FutureBuilder<List<Users>>(
        future: usersFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("Press button to start");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircularLoadingIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return ErrorPage(
                  getData: getUsers, // Provide getUsers as a callback
                  onRetry: () async {
                    try {
                      setState(() {
                        usersFuture = getUsers();
                      });
                    } catch (e) {
                      // Handle any errors if needed
                    }
                  },
                  message:
                      'An error occurred while fetching users. Please try again.',
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('Hakuna taarifa zozote za watumiaji'),
                );
              }
              List<Users> users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailPage(users[index]),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(users[index].name),
                      subtitle: Text(users[index].phoneNumber),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
