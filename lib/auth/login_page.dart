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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
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
                    SizedBox(height: 20.0),
                    Text(
                      "Ingia kwenye akaunti yako",
                      style: TextStyle(fontSize: 22.0),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: "Barua pepe",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Barua pepe inahitajika";
                              }
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return "Barua pepe si sahihi";
                              }
                              return null;
                            },
                            onSaved: (value) => _email = value!,
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              labelText: "Nywila",
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: _togglePasswordView,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Nywila inahitajika";
                              }
                              return null;
                            },
                            onSaved: (value) => _password = value!,
                          ),
                          SizedBox(height: 24.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(50),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() => isLoading = true);
                                login();
                              }
                            },
                            child: Text("INGIA"),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordPage()),
                                  );
                                },
                                child: Text("Umesahau nywila?"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()),
                                  );
                                },
                                child: Text("Jisajili sasa"),
                              ),
                            ],
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

  Future<void> login() async {
    var url = Uri.parse(AppConfig.LOGIN_URL);

    try {
      final response = await http.post(url, body: {
        'email': _email,
        'password': _password
      }).timeout(Duration(seconds: 15));

      print("Login response status: ${response.statusCode}");
      print("Login response body: ${response.body}");

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);

        if (userData['success']) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt("user_id", userData['user']['id']);
          prefs.setString("name", userData['user']['name']);
          prefs.setString("access_token", userData['user']['access_token']);
          prefs.setString("phone_number", userData['user']['phone_number']);
          prefs.setString("email", userData['user']['email']);
          prefs.setBool("isLoggedIn", true);

          setState(() => isLoading = false);

          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => HomePage(0),
              transitionsBuilder: (_, animation, __, child) => SlideTransition(
                position:
                    Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
                        .animate(animation),
                child: child,
              ),
            ),
            (route) => false,
          );
        } else {
          throw Exception(userData['message']);
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
