import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/home/add_milk_page.dart';
import 'package:clusterapplication/models/milk_data.dart';
import 'package:clusterapplication/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late List<Milks> milks;
  late MilkData _milkData;

  Future<void> getMilks() async {
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.get(Uri.parse(AppConfig.MILKS_URL), headers: {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    });

    var data = json.decode(response.body);
    _milkData = MilkData.fromJson(data);
    milks = _milkData.milks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddMilkPage()));
          }),
      body: RefreshIndicator(
        onRefresh: getMilks,
        child: FutureBuilder(
          future: getMilks(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.none:
                return Text("Press button to start");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return CircularLoadingIndicator();
              case ConnectionState.done:
                if (asyncSnapshot.hasError) return errorData(asyncSnapshot);
                return milks.length == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Hakuna taafia yoyote, tafadhali bonyeza kitufe cha njano hapo chini ili uweze kuingiza kiasi cha maziwa.',
                            style: TextStyle(
                                fontSize: 19.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: milks.length,
                        itemBuilder: (context, index) => ListTile(
                              title: Text(milks[index].createdAt),
                              subtitle: Text("${milks[index].quantity} lita"),
                              leading: CircleAvatar(
                                backgroundColor: Colors.amberAccent,
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                              ),
                            ));
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
              getMilks();
              setState(() {});
            },
            child: Text('Try Again'),
          )
        ],
      ),
    );
  }
}
