import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:clusterapplication/home/read_post_pape.dart';
import 'package:clusterapplication/models/post_data.dart';
import 'package:clusterapplication/widgets/circular_progress_indicator.dart';
import 'package:clusterapplication/widgets/no_data_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late List<Posts> _posts;
  late PostData _postData;

  Future<void> getPosts() async {
    String? accessToken = await AppConfig.getAccessToken();

    var response = await http.get(Uri.parse(AppConfig.POST_URL), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _postData = PostData.fromJson(data);
      _posts = _postData.posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getPosts,
      child: FutureBuilder(
        future: getPosts(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          switch (asyncSnapshot.connectionState) {
            case ConnectionState.none:
              return Text("Press button to start");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircularLoadingIndicator();
            case ConnectionState.done:
              if (asyncSnapshot.hasError) return errorData(asyncSnapshot);
              return _posts.isEmpty
                  ? Center(
                      child: NoDataPage(
                        "Hakuna sasisho lolote, Utaziona hapa mara ziwekwapo.",
                        "assets/images/empty.png",
                        onRetry: () async {
                          await getPosts(); // Await getPosts
                          setState(() {});
                        },
                      ),
                    )
                  : ListView.builder(
                      itemCount: _posts.length,
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
                                                ReadPostPage(_posts[index])));
                                  },
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.network(
                                      _posts[index].thumbnail,
                                      height: 200.0,
                                    ),
                                  ),
                                  title: Text(
                                    _posts[index].title,
                                    style: GoogleFonts.ubuntu(fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    _posts[index].createdAt,
                                    style: GoogleFonts.ubuntu(fontSize: 13.0),
                                  ),
                                ),
                                Divider()
                              ],
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
            onPressed: () async {
              await getPosts(); // Await getPosts
              setState(() {});
            },
            child: Text('Try Again'),
          )
        ],
      ),
    );
  }
}
