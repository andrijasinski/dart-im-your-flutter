import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_wars_movies/models/models.dart';
import 'package:star_wars_movies/services/api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Star Wars Movies',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MoviesPage(
        title: 'Star Wars Movies',
      ),
    );
  }
}

class MoviePageWrapper {}

class MoviesPage extends StatefulWidget {
  final _scrollController = ScrollController();

  MoviesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MoviesPageState createState() =>
      new MoviesPageState(scrollController: _scrollController);
}

class MoviesPageState extends State<MoviesPage> {
  final _client = new ApiClient();
  final scrollController;

  MoviesPageState({@required this.scrollController});

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(_scrollListener);
  }

  Widget _movieListWidgetFuture(ApiClient client) {
    return FutureBuilder<MovieSearchResultCollection>(
      future: client.getMovieSearchResults(),
      builder: (BuildContext context,
          AsyncSnapshot<MovieSearchResultCollection> snapshot) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: _buildActions(),
      ),
      body: _movieListWidgetFuture(_client),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      // Load additional data
    }
  }

  List<Widget> _buildActions() {
    return <Widget>[];
  }
}

class MovieGridView extends StatelessWidget {
  final List<MovieSearchResult> movies;
  final DateFormat dateFormat;
  final ScrollController scrollController;

  MovieGridView({Key key, this.movies, this.dateFormat, this.scrollController});

  @override
  Widget build(BuildContext context) {
    // Build the List or GridView with a builder
  }
}

class MovieItemView extends StatelessWidget {
  final MovieSearchResult movie;

  const MovieItemView({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build an Item view
  }
}
