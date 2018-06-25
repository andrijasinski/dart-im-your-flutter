import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingSpinner extends StatelessWidget {
  final String text;

  const LoadingSpinner({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: new Text(text),
          ),
        ],
      ),
    );
  }
}

class ErrorMessageWidget extends StatelessWidget {
  final String error;

  const ErrorMessageWidget({Key key, @required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.error, color: Colors.red),
        new Text('Error: $error'),
      ],
    ));
  }
}
