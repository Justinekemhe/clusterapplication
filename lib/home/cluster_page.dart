import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/home/cluster_detail_page.dart';
import 'package:clusterapplication/models/cluster.dart';
import 'package:clusterapplication/widgets/circular_progress_indicator.dart';
import 'package:clusterapplication/widgets/error_page.dart';
import 'package:clusterapplication/widgets/no_data_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ClusterPage extends StatefulWidget {
  @override
  _ClusterPageState createState() => _ClusterPageState();
}

class _ClusterPageState extends State<ClusterPage> {
  late List<Clusters> clusters;
  late ClusterData _clusterData;

  Future<void> getClusters() async {
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.get(Uri.parse(AppConfig.CLUSTER_URL), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _clusterData = ClusterData.fromJson(data);
      clusters = _clusterData.clusters;
    } else {
      throw Exception('Failed to load clusters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getClusters,
      child: FutureBuilder(
        future: getClusters(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.none:
              return Text("Press button to start");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircularLoadingIndicator();
            case ConnectionState.done:
              if (asyncSnapshot.hasError) {
                return ErrorPage(
                  getData: getClusters, // Retry function
                  message:
                      "An error occurred while fetching clusters. Please try again.",
                  onRetry: () async {
                    await getClusters(); // Await getClusters
                    setState(() {});
                  },
                );
              }
              return clusters.length == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: NoDataPage(
                          "Hakuna taarifa zozote, mara uchanguapo vipengele utapangwa kwenye kundi stahiki. Bonyeza neno vipengele kwenye skrini ya simu yako kupata vipengele ilikukamilisha usajili",
                          "assets/images/empty.png",
                          onRetry: () async {
                            await getClusters(); // Await getClusters
                            setState(() {});
                          },
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: clusters.length,
                      itemBuilder: (context, index) => Container(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClusterDetailPage(clusters[index]),
                                  ),
                                );
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                              leading: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                                child: Image.network(
                                  clusters[index].thumbnail,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              title: Text(
                                clusters[index].name,
                                style: GoogleFonts.ubuntu(fontSize: 16),
                              ),
                              subtitle: Text(
                                clusters[index].status,
                                style: GoogleFonts.ubuntu(fontSize: 13.0),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    );
          }
        },
      ),
    );
  }
}
