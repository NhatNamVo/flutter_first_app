import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent(
      {super.key,
      this.title = 'Nothing here',
      this.message = 'Add a new item to get started'});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 24.0, color: Colors.black54)),
        const SizedBox(
          height: 12.0,
        ),
        Text(message, style: TextStyle(fontSize: 14.0, color: Colors.black54)),
      ],
    ));
  }
}
