import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/home/chats/message_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _text = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  late List<Messages> messages;
  late MessageData messageData;
  String message = "";
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  Future<void> sendMessage() async {
    var url = Uri.parse(AppConfig.SEND_MESSAGE_URL);
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.post(url, headers: {
      HttpHeaders.contentTypeHeader:
          "application/x-www-form-urlencoded", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    }, body: {
      'message': message,
    });

    var responseData = json.decode(response.body);
    if (responseData['success']) {
      setState(() {
        getMessage();
      });
    } else {
      print(response.body);
    }
  }

  Future<void> getMessage() async {
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.get(Uri.parse(AppConfig.MESSAGE_URL), headers: {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    });

    var data = json.decode(response.body);
    messageData = MessageData.fromJson(data);
    messages = messageData.messages;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getMessage,
      child: FutureBuilder(
        future: getMessage(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.none:
              return Text("Press button to start");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (asyncSnapshot.hasError) return errorData(asyncSnapshot);
              return Stack(
                children: <Widget>[
                  ListView.builder(
                    itemCount: messages.length,
                    //shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 60),
                    // physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Align(
                          alignment: (messages[index].messageType == "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: (messages[index].messageType == "receiver"
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                messages[index].messageType == "receiver"
                                    ? Text(
                                        messages[index].username,
                                        style:
                                            TextStyle(color: Colors.deepOrange),
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  height: 3.0,
                                ),
                                Text(messages[index].message,
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(messages[index].createdAt,
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12.0))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        height: 60,
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Ujumbe unahitajika";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    message = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: "Andika ujumbe...",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();

                                sendMessage();
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                              backgroundColor: Colors.blue,
                              elevation: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }

  Padding errorData(AsyncSnapshot asyncSnapshot) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Error: ${asyncSnapshot.error}'),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue),
            onPressed: () {
              getMessage();
              setState(() {});
            },
            child: Text('Try Again'),
          )
        ],
      ),
    );
  }
}
