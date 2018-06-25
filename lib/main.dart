import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_wars_movies/custom_widgets.dart';
import 'package:star_wars_movies/models/models.dart';
import 'package:star_wars_movies/movie_page.dart';
import 'package:star_wars_movies/services/api.dart';
import 'package:transparent_image/transparent_image.dart';

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
  MoviesPage({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  MoviesPageState createState() => new MoviesPageState();
}

class MoviesPageState extends State<MoviesPage> {
  final ApiClient _client = new ApiClient();
  final DateFormat _dateFormat = new DateFormat('yyyy');

  MoviesPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _movieListWidgetFuture(ApiClient client) {
    return FutureBuilder<MovieSearchResultCollection>(
      future: client.getMovieSearchResults(),
      builder: (
        BuildContext context,
        AsyncSnapshot<MovieSearchResultCollection> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return LoadingSpinner(
              text: 'Loading',
            );
          default:
            if (snapshot.hasError) {
              return ErrorMessageWidget(
                error: snapshot.error,
              );
            } else {
              return MovieGridView(
                movies: snapshot.data.results,
                dateFormat: _dateFormat,
              );
            }
        }
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
        actions: <Widget>[],
      ),
      body: _movieListWidgetFuture(_client),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sortAscending() {
    setState(() {});
  }

  void _sortDescending() {
    setState(() {});
  }

  void _scrollListener() {}

  void _updateList(MovieSearchResultCollection data) {}
}

class MovieGridView extends StatelessWidget {
  final List<MovieSearchResult> movies;
  final DateFormat dateFormat;
  final ScrollController scrollController;

  MovieGridView({Key key, this.movies, this.dateFormat, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: _createSliverGridDelegate(context),
      itemCount: movies.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) =>
          MovieItemView(movie: movies[index], dateFormat: dateFormat),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _createSliverGridDelegate(
      BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        childAspectRatio: 0.65);
  }
}

class MovieItemView extends StatelessWidget {
  final MovieSearchResult movie;
  final DateFormat dateFormat;
  const MovieItemView({
    Key key,
    @required this.movie,
    @required this.dateFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onTapGridItem(movie, context),
        child: Card(
          elevation: 8.0,
          child: GridTile(
              child: movie.posterPath != null
                  ? FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          "https://image.tmdb.org/t/p/w154/${movie.posterPath}",
                      fit: BoxFit.fitHeight,
                    )
                  : Image.memory(
                      kTransparentImage,
                      fit: BoxFit.fitHeight,
                    ),
              footer: GridTileBar(
                title: Text(movie.title),
                subtitle: movie.releaseDate != null
                    ? Text(dateFormat.format(movie.releaseDate))
                    : Text('TBA'),
                backgroundColor: Colors.black54,
              )),
        ));
  }

  void _onTapGridItem(MovieSearchResult movie, BuildContext context) {
    Navigator.push(context, MoviePageRoute.of(movie));
  }
}
