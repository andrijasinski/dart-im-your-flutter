import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:star_wars_movies/models/models.dart';
import 'package:star_wars_movies/services/api.dart';

class MoviePage extends StatelessWidget {
  final ApiClient _client = ApiClient();

  final MovieSearchResult movieSearchResult;

  MoviePage({Key key, @required this.movieSearchResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _movieListWidgetFuture(movieSearchResult),
    );
  }

  FutureBuilder<Movie> _movieListWidgetFuture(MovieSearchResult searchResult) {
    return FutureBuilder<Movie>(
      future: _client.getMovie(searchResult.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // return which depending on state and data.
      },
    );
  }
}

class MinimalMovieInfo extends StatelessWidget {
  final MovieSearchResult movie;

  const MinimalMovieInfo({
    Key key,
    @required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // build widget showing movie data.
  }

  void _onSharePressed() {}
}

class FullMovieInfo extends StatelessWidget {
  final double appBarHeight = 256.0;
  final Movie movie;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const FullMovieInfo({
    Key key,
    @required this.movie,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // build widget showing movie data.
  }

  void _onSharePressed() {}
}

class MovieSpecsView extends StatelessWidget {
  final String title;
  final String posterPath;
  final double voteAverage;
  final int voteCount;
  final List<Genre> genres;

  const MovieSpecsView(
      {Key key,
      @required this.title,
      @required this.posterPath,
      @required this.voteAverage,
      @required this.voteCount,
      this.genres})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build widget to show the title, poster, ratings and genres.
  }
}

class MoviePageRoute extends MaterialPageRoute<MovieSearchResult> {
  final MovieSearchResult movie;

  MoviePageRoute(
      {WidgetBuilder builder,
      RouteSettings settings: const RouteSettings(),
      @required this.movie})
      : super(builder: builder, settings: settings);

  @override
  MovieSearchResult get currentResult => movie;

  static MoviePageRoute of(BuildContext context, MovieSearchResult movie) =>
      MoviePageRoute(
          movie: movie,
          builder: (BuildContext context) {
            return MoviePage(
              movieSearchResult: movie,
            );
          });
}
