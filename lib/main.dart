import 'package:flutter/material.dart';

const APP_TITLE = 'Star Wars Movies';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MoviesPage(),
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
          'Step 1 Load movie results from API',
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }
}
