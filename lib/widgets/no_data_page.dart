import 'package:flutter/material.dart';

class NoDataPage extends StatelessWidget {
  final String message;
  final String imageUrl;
  final Future<void> Function() onRetry; // Added onRetry

  NoDataPage(this.message, this.imageUrl,
      {required this.onRetry}); // Updated constructor

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imageUrl),
          SizedBox(
            height: 10,
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              await onRetry(); // Await onRetry function
            },
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
