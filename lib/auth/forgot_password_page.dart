import 'dart:convert';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late String _email;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Umesahau nywila"),
      ),
      body: isLoading
          ? LoadingPage()
          : SingleChildScrollView(
              child: Container(
                  child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Tafadhari ingiza barua pepe uliyojisajili nayo"),
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
                              _forgotPassword();
                            },
                            child: Container(
                              height: 60.0,
                              child: Center(
                                child: Text(
                                  "Tuma ",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black38),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50.0,
                              child: Text(
                                "Ingia",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
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

  Future<void> _forgotPassword() async {
    var url = Uri.parse(AppConfig.FORGOT_PASSWORD_URL);
    var response = await http.post(url, body: {
      'email': _email,
    });

    var userData = json.decode(response.body);
    print(userData);
    if (userData['success']) {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text(
          userData['message'],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        content: Text(
          userData['message'],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
