import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/home/home_page.dart';
import 'package:clusterapplication/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMilkPage extends StatefulWidget {
  @override
  _AddMilkPageState createState() => _AddMilkPageState();
}

class _AddMilkPageState extends State<AddMilkPage> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late String quantity;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Ingiza kiasi cha maziwa"),
      ),
      body: isLoading
          ? LoadingPage()
          : SingleChildScrollView(
              child: Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Jaza kiasi cha maziwa ulichozalisha kwa siku nzima.(Taarifa hii itajazwa mara moja kwa siku)",
                      style: TextStyle(
                          fontSize: 19.0, fontWeight: FontWeight.bold),
                    ),
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
                                return "Kiasi kinahitajika";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                quantity = value!;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.confirmation_number),
                              focusColor: Colors.orangeAccent,
                              labelText: "Kiasi cha maziwa (lita)",
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
                              _formKey.currentState!.save();
                              setState(() {
                                isLoading = true;
                              });
                              addQuantity();
                            },
                            child: Container(
                              height: 60.0,
                              child: Center(
                                child: Text(
                                  "TUNZA",
                                ),
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

  Future<void> addQuantity() async {
    var url = Uri.parse(AppConfig.ADD_MILK);
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.post(url, headers: {
      HttpHeaders.contentTypeHeader:
          "application/x-www-form-urlencoded", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    }, body: {
      'quantity': quantity,
    });

    var userData = json.decode(response.body);
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
      goBackToPage();
    } else {
      setState(() {
        isLoading = false;
      });
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          userData['message'],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void goBackToPage() async {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => HomePage(0)))
        .whenComplete(() {
      setState(() {});
    });
  }
}
