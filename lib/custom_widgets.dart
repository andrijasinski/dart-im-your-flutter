import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingSpinner extends StatelessWidget {
  final String text;

  const LoadingSpinner({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [new CircularProgressIndicator(), new Text(text)],
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

class ActionItemWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const ActionItemWidget({Key key, this.icon, this.onPressed, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: new Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
