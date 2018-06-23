import 'package:flutter/material.dart';

const APP_TITLE = 'Star Wars Movies';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: APP_TITLE,
      theme: new ThemeData(
        primaryColor: Colors.black,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.white,
        accentColor: Colors.yellow,
        primaryTextTheme: TextTheme(title: TextStyle(color: Colors.yellow)),
      ),
      home: new MoviesPage(
        title: APP_TITLE,
      ),
    );
  }
}

class MoviesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoviesPageState();
}

class MoviesPageState extends State<MoviesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(APP_TITLE),
      ),
      body: Center(
        child: Text(
          'Step 1 Load movie results from API see step-1.md for more info',
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }
}
