import 'dart:convert';

import 'package:clusterapplication/auth/register_page.dart';
import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/home/home_page.dart';
import 'package:clusterapplication/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool isLoading = false;
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Ingia"),
      ),
      body: isLoading
          ? LoadingPage()
          : SingleChildScrollView(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Ingia kwenye akaunti yako",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              focusColor: Colors.orangeAccent,
                              labelText: "Barua pepe",
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
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
                            style: TextStyle(fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Nywila inahitajika";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _password = value!;
                              });
                            },
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              labelText: "Nywila",
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              suffix: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  _isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.black),
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
                            style: TextStyle(fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            onPressed: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState?.save();
                              setState(() {
                                isLoading = true;
                              });
                              login();
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                            },
                            child: Container(
                              height: 60.0,
                              child: Center(
                                child: Text(
                                  "INGIA",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.black38),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordPage()));
                                },
                                child: Container(
                                  height: 50.0,
                                  child: Text(
                                    "Umesahau nywila?",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.black38),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage()));
                                },
                                child: Container(
                                  height: 50.0,
                                  child: Text(
                                    "Jisajili sasa",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
    );
  }

  Future<void> login() async {
    var url = Uri.parse(AppConfig.LOGIN_URL);
    var response =
        await http.post(url, body: {'email': _email, 'password': _password});

    var userData = json.decode(response.body);
    if (userData['success']) {
      setState(() {
        isLoading = false;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("user_id", userData['user']['id']);
      preferences.setString("name", userData['user']['name']);
      preferences.setString("access_token", userData['user']['access_token']);
      preferences.setString("phone_number", userData['user']['phone_number']);
      preferences.setString("email", userData['user']['email']);
      preferences.setBool("isLoggedIn", true);

      preferences.commit();
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context,
              Animation animation, Animation secondaryAnimation) {
            return HomePage(0);
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
    } else {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text(
          userData['message'],
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
