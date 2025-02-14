import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/models/feature_data.dart';
import 'package:clusterapplication/models/user_data.dart';
import 'package:clusterapplication/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserFeaturePage extends StatefulWidget {
  Users user;
  UserFeaturePage(this.user);

  @override
  _UserFeaturePageState createState() => _UserFeaturePageState();
}

class _UserFeaturePageState extends State<UserFeaturePage> {
  late List<Features> features;
  late FeatureData _featureData;

  Future<void> getFeatures() async {
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.get(
        Uri.parse(AppConfig.USER_FEATURES_URL + "/${widget.user.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
        });

    print(response.body);

    var data = json.decode(response.body);
    _featureData = FeatureData.fromJson(data);
    features = _featureData.features;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
                      child: Text(
                          'Hakuna taafia zozote kuhusiana na mtumiaji huyu.Taarifa zake zitaoneka baada ya kukamilisha usajili.'),
                    )
                  : ListView.builder(
                      itemCount: features.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(
                              features[index].feature,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400),
                            ),
                            subtitle: Text(
                              "${features[index].choice}",
                              style: TextStyle(
                                  fontSize: 13.0, fontWeight: FontWeight.bold),
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
