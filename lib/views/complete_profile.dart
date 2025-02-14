import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/home/home_page.dart';
import 'package:clusterapplication/models/question_data.dart';
import 'package:clusterapplication/widgets/circular_progress_indicator.dart';
import 'package:clusterapplication/widgets/error_page.dart';
import 'package:clusterapplication/widgets/no_data_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompleteProfile extends StatefulWidget {
  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  late QuestionData _questionData;
  late List<Questions> questions;
  late List<Choices> choices;
  late Choices _choice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kamilisha Usajili"),
      ),
      body: RefreshIndicator(
        onRefresh: getQuestion,
        child: FutureBuilder(
          future: getQuestion(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.none:
                return Text("Press button to start");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return CircularLoadingIndicator();
              case ConnectionState.done:
                if (asyncSnapshot.hasError) {
                  // Add `getData` and `onRetry` required parameters for ErrorPage
                  return ErrorPage(
                    getData: getQuestion,
                    onRetry: getQuestion,
                    message: '',
                  );
                }
                return questions.length == 0
                    ? Center(
                        child: NoDataPage(
                          "No data at the moment",
                          "assets/images/empty.png",
                          // Add `onRetry` for NoDataPage
                          onRetry: getQuestion,
                        ),
                      )
                    : ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) => Card(
                          color: Colors.white,
                          elevation: 0.0,
                          child: ExpansionTile(
                            title: Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    questions[index].question,
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              child: Text("${index + 1}"),
                            ),
                            children: questions[index].choices.map((m) {
                              return AnswerWidget(m);
                            }).toList(),
                          ),
                        ),
                      );
            }
          },
        ),
      ),
    );
  }

  Future<void> getQuestion() async {
    String url = AppConfig.QUESTIONS_URL;
    String? accessToken = await AppConfig.getAccessToken();
    var response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    });

    var data = json.decode(response.body);
    setState(() {
      _questionData = QuestionData.fromJson(data);
      questions = _questionData.questions;
    });
  }

  @override
  void initState() {
    super.initState();
    getQuestion(); // Ensure to load the questions when the screen is initialized
  }
}

class AnswerWidget extends StatefulWidget {
  final Choices m;

  AnswerWidget(this.m);

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  Color c = Colors.black;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        updateQuestion(widget.m.id.toString());
      },
      title: Text(
        widget.m.choice,
        textAlign: TextAlign.center,
        style: TextStyle(color: c, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  void goBackToPage() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage(2)))
        .whenComplete(() {
      setState(() {});
    });
  }

  Future<void> updateQuestion(String id) async {
    String url = AppConfig.UPDATE_CHOICE_URL + id;
    String? accessToken = await AppConfig.getAccessToken();
    var response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    });

    var responseData = json.decode(response.body);
    final snackBar = SnackBar(
      content: Text(responseData['message']),
      backgroundColor: Colors.black,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (responseData['success']) {
      goBackToPage();
    }
  }
}
