import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "";
  String _email = "";
  String _phoneNumber = "";
  bool isLoading = false;
  String _oldPassword = "", _newPassword = "";

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUserInfo(); // Ensure data is loaded initially
  }

  Future<void> getUserInfo() async {
    setState(() {
      isLoading = true;
    });
    try {
      String? accessToken = await AppConfig.getAccessToken();
      var response = await http.get(
        Uri.parse(AppConfig.USER_INFO_URL),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
        },
      );

      var data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          _name = data['user']['name'];
          _email = data['user']['email'];
          _phoneNumber = data['user']['phone_number'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showSnackBar(data['message'], Colors.red);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar("An error occurred. Please try again.", Colors.red);
    }
  }

  Future<void> updateUserProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      String url = AppConfig.UPDATE_PROFILE_URL;
      String? accessToken = await AppConfig.getAccessToken();
      var response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
        },
        body: {
          'name': _name,
          'email': _email,
          'phone_number': _phoneNumber,
        },
      );

      var userData = json.decode(response.body);
      if (userData['success']) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("name", userData['user']['name']);
        preferences.setInt("user_id", userData['user']['id']);
        preferences.setString("access_token", userData['user']['access_token']);
        preferences.setString("phone_number", userData['user']['phone_number']);
        preferences.setString("email", userData['user']['email']);

        _showSnackBar(userData['message'], Colors.green);
        setState(() {
          isLoading = false;
        });
      } else {
        _showSnackBar(userData['message'], Colors.red);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar("An error occurred. Please try again.", Colors.red);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> changePassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      String url = AppConfig.CHANGE_PASSWORD_URL;
      String? accessToken = await AppConfig.getAccessToken();
      var response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
        },
        body: {
          'old_password': _oldPassword,
          'new_password': _newPassword,
        },
      );

      var userData = json.decode(response.body);
      if (userData['success']) {
        _showSnackBar(userData['message'], Colors.green);
        setState(() {
          isLoading = false;
        });
      } else {
        _showSnackBar(userData['message'], Colors.red);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar("An error occurred. Please try again.", Colors.red);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
      ),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Wasifu"),
      ),
      body: isLoading
          ? LoadingPage()
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 30.0),
                          Text("Taarifa binafsi",
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 10.0),
                          TextFormField(
                            initialValue: _name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Jina linahitajika";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _name = value!;
                              });
                            },
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_box),
                              hintText: "Jina",
                              labelText: "Jina",
                              hintStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            initialValue: _email,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Barua pepe inahitajika";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _email = value!;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: "Barua pepe",
                              labelText: "Barua pepe",
                              hintStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            initialValue: _phoneNumber,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Nambari ya simu inahitajika";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _phoneNumber = value!;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              hintText: "Nambari ya simu",
                              labelText: "Nambari ya simu",
                              hintStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                updateUserProfile();
                              }
                            },
                            child: Text("Sasisha taarifa"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Text("Badilisha nenosiri", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10.0),
                    Form(
                      key: _passwordKey,
                      child: Column(
                        children: [
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Nenosiri la zamani linahitajika";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _oldPassword = value!;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Nenosiri la zamani",
                              labelText: "Nenosiri la zamani",
                              hintStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Nenosiri jipya linahitajika";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _newPassword = value!;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Nenosiri jipya",
                              labelText: "Nenosiri jipya",
                              hintStyle: TextStyle(fontSize: 18.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_passwordKey.currentState!.validate()) {
                                _passwordKey.currentState!.save();
                                changePassword();
                              }
                            },
                            child: Text("Badilisha nenosiri"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
