import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  final Future<void> Function() getData; // Updated type
  final Future<void> Function() onRetry; // Updated type
  final String message;

  ErrorPage(
      {required this.getData, required this.onRetry, required this.message});

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  Future<void> retrieveData() async {
    await widget.getData();
  }

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              widget.message,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue),
            onPressed: () async {
              await widget.onRetry(); // Await onRetry function
              setState(() {});
            },
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
