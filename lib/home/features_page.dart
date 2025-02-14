import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/models/feature_data.dart';
import 'package:clusterapplication/views/complete_profile.dart';
import 'package:clusterapplication/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeaturesPage extends StatefulWidget {
  @override
  _FeaturesPageState createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  late List<Features> features;
  late FeatureData _featureData;

  Future<void> getFeatures() async {
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.get(Uri.parse(AppConfig.FEATURES_URL), headers: {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    });

    var data = json.decode(response.body);
    _featureData = FeatureData.fromJson(data);
    features = _featureData.features;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.update_outlined),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CompleteProfile()));
          }),
      body: RefreshIndicator(
        onRefresh: getFeatures,
        child: FutureBuilder(
          future: getFeatures(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            switch (asyncSnapshot.connectionState) {
              case ConnectionState.none:
                return Text("Press button to start");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return CircularLoadingIndicator();
              case ConnectionState.done:
                if (asyncSnapshot.hasError) return errorData(asyncSnapshot);
                return features.length == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Bonyeza kitufe cha njano kuchagua vipengele kwa kukamilisha usajili,Jibu maswali yote 10.',
                            style: TextStyle(
                                fontSize: 19.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: features.length,
                        itemBuilder: (context, index) => ListTile(
                              title: Text(
                                features[index].feature,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(
                                "${features[index].choice}",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
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
              getFeatures();
              setState(() {});
            },
            child: Text('Try Again'),
          )
        ],
      ),
    );
  }
}
