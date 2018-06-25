import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:star_wars_movies/custom_widgets.dart';
import 'package:star_wars_movies/models/models.dart';

class MoviePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final MovieSearchResult movieSearchResult;

  MoviePage({Key key, @required this.movieSearchResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          MinimalMovieInfo(movie: movieSearchResult, scaffoldKey: scaffoldKey),
    );
  }
}

class MinimalMovieInfo extends StatelessWidget {
  final double appBarHeight = 256.0;
  final MovieSearchResult movie;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MinimalMovieInfo({
    Key key,
    @required this.movie,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: appBarHeight,
          pinned: true,
          actions: <Widget>[
            // add action button to share the image
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: HeaderImage(
                path: movie.backdropPath ?? movie.posterPath,
                appBarHeight: appBarHeight),
          ),
        ),
        SliverList(
          delegate: buildSliverChildListDelegate(context),
        )
      ],
    );
  }

  SliverChildListDelegate buildSliverChildListDelegate(BuildContext context) {
    return SliverChildListDelegate(<Widget>[
      MovieSpecsView(
        title: movie.title,
        posterPath: movie.posterPath,
        voteAverage: movie.voteAverage,
        voteCount: movie.voteCount,
        key: Key(movie.title),
      ),
      TextOverviewWidget(movie.overview, Theme.of(context).textTheme.body1),
    ]);
  }

  void _onSharePressed() => print('Share movie with other people');
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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('show movie poster, title and rating.'),
    );
  }
}

class MoviePageRoute extends MaterialPageRoute<MovieSearchResult> {
  final MovieSearchResult movie;

  MoviePageRoute(
    this.movie, {
    WidgetBuilder builder,
  }) : super(builder: builder);

  @override
  MovieSearchResult get currentResult => movie;

  static MoviePageRoute of(MovieSearchResult movie) => MoviePageRoute(
        movie,
        builder: (BuildContext context) {
          // return the widget of the new screen here.
        },
      );
}
