import 'dart:convert';
import 'dart:io';

import 'package:clusterapplication/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late WebViewController controller;
  late SharedPreferences preferences;
  late String userId;
  bool isLoading = true;

  Future<void> getUserInfo() async {
    String? accessToken = await AppConfig.getAccessToken();
    var response = await http.get(
      Uri.parse(AppConfig.USER_INFO_URL),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accessToken",
      },
    );

    var data = json.decode(response.body);
    if (data['success']) {
      userId = data['user']['id'].toString();
      setState(() {
        isLoading = false;
      });
      controller.loadRequest(Uri.parse(
          "https://clustering.comtech-alliance.org/api/milk/dashboard/$userId"));
    } else {
      final snackBar = SnackBar(
        content: Text(
          data['message'],
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.red),
        ),
        backgroundColor: Colors.black,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar or indicator if needed
              print("Loading: $progress%");
            },
            onPageStarted: (String url) {
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
            },
            onHttpError: (HttpResponseError error) {
              // Use the description or other available property for error handling
              print("HTTP Error: ${error.description}");
              final snackBar = SnackBar(
                content: Text(
                  "HTTP Error: ${error.description}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.red),
                ),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            onWebResourceError: (WebResourceError error) {
              print("Web Resource Error: ${error.description}");
              final snackBar = SnackBar(
                content: Text(
                  "Error: ${error.description}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.red),
                ),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url
                  .startsWith('https://clustering.comtech-alliance.org/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        );
    }
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : WebViewWidget(controller: controller),
    );
  }
}

extension on HttpResponseError {
  get description => null;
}
