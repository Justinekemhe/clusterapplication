import 'package:clusterapplication/models/post_data.dart';
import 'package:flutter/material.dart';

class ReadPostPage extends StatefulWidget {
  Posts post;

  ReadPostPage(this.post);

  @override
  _ReadPostPageState createState() => _ReadPostPageState();
}

class _ReadPostPageState extends State<ReadPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: <Widget>[
                FittedBox(
                  child: Image.network(widget.post.thumbnail),
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.post.createdAt,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0)),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(widget.post.body,
                    style: TextStyle(
                      fontSize: 18.0,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
