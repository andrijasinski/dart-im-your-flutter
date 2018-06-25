import 'package:flutter/material.dart';
import 'package:star_wars_movies/models/models.dart';
import 'package:star_wars_movies/services/api.dart';

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
  MoviesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MoviesPageState createState() => new MoviesPageState();
}

class MoviesPageState extends State<MoviesPage> {
  final ApiClient _client = new ApiClient();

  MoviesPageState();

  Widget _movieListWidgetFuture(ApiClient client) {
    return FutureBuilder<MovieSearchResultCollection>(
      future: client.getMovieSearchResults(),
      builder: (BuildContext context,
          AsyncSnapshot<MovieSearchResultCollection> snapshot) {
        return Center(child: Text('Step 2 Create a GridView with the result'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: _movieListWidgetFuture(_client),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MovieGridView extends StatelessWidget {
  final List<MovieSearchResult> movies;

  MovieGridView({Key key, @required this.movies});

  @override
  Widget build(BuildContext context) {
    // Build the List or GridView with a builder
  }
}
