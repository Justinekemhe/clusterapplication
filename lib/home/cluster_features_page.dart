import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/models/cluster.dart';
import 'package:clusterapplication/models/cluster_feature_data.dart';
import 'package:clusterapplication/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClusterFeaturesPage extends StatefulWidget {
  Clusters cluster;
  ClusterFeaturesPage(this.cluster);

  @override
  _ClusterFeaturesPageState createState() => _ClusterFeaturesPageState();
}

class _ClusterFeaturesPageState extends State<ClusterFeaturesPage> {
  late List<ClusterFeatures> features;
  late ClusterFeature _clusterFeature;

  Future<void> getClusterFeatures() async {
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.get(
        Uri.parse(AppConfig.CLUSTER_URL + "/${widget.cluster.id}"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json", // or whatever
          HttpHeaders.authorizationHeader: "Bearer $accessToken",
        });

    print(response.body);

    var data = json.decode(response.body);
    _clusterFeature = ClusterFeature.fromJson(data);
    features = _clusterFeature.clusterFeatures;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getClusterFeatures,
      child: FutureBuilder(
        future: getClusterFeatures(),
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
                          'Hakuna taarifa zozote, tafadhali bonyeza kitufe  cha njano hapo chini ili uweze kuchangua vipengele.Kisha chagua kipenegele kulingana na utendaji wako , Rudia hizi hatua kwa maswali yote.'),
                    )
                  : ListView.builder(
                      itemCount: features.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(
                              features[index].name,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400),
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
              getClusterFeatures();
              setState(() {});
            },
            child: Text('Try Again'),
          )
        ],
      ),
    );
  }
}
