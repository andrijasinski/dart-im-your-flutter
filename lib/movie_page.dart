import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';
import 'package:star_wars_movies/custom_widgets.dart';
import 'package:star_wars_movies/models/models.dart';
import 'package:star_wars_movies/services/api.dart';
import 'package:transparent_image/transparent_image.dart';

class MoviePage extends StatelessWidget {
  final ApiClient _client = ApiClient();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return MinimalMovieInfo(
                movie: movieSearchResult, scaffoldKey: scaffoldKey);
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return FullMovieInfo(
                  movie: snapshot.data, scaffoldKey: scaffoldKey);
        }
      },
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: appBarHeight,
          pinned: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.share), onPressed: _onSharePressed)
          ],
          flexibleSpace: FlexSpaceAppBar(
              title: "",
              path: movie.backdropPath ?? movie.posterPath,
              appBarHeight: appBarHeight),
        ),
        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
          MovieSpecsView(
            title: movie.title,
            posterPath: movie.posterPath,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            key: Key(movie.title),
          ),
          TextOverviewWidget(text: movie.overview, style: textTheme.body1),
          LoadingSpinner(text: 'loading'),
        ])),
      ],
    );
  }

  void _onSharePressed() {
    Share.share("Check out ${movie.title}");
  }
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      primary: true,
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: appBarHeight,
          pinned: true,
          actions: <Widget>[
            ActionItemWidget(
                icon: Icons.share, onPressed: _onSharePressed, tooltip: "Share")
          ],
          flexibleSpace: FlexSpaceAppBar(
              title: "",
              path: movie.backdropPath ?? movie.posterPath,
              appBarHeight: appBarHeight),
        ),
        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
          MovieSpecsView(
            key: Key(movie.title),
            title: movie.title,
            posterPath: movie.posterPath,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            genres: movie.genres,
          ),
          TextOverviewWidget(text: movie.tagline, style: textTheme.body2),
          TextOverviewWidget(text: movie.overview, style: textTheme.body1),
          ReviewsWidget(reviews: movie.reviews.results),
        ])),
      ],
    );
  }

  void _onSharePressed() {
    Share.share(
        "You should check ${movie.title} you can find more info at ${movie.homepage}");
  }
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeInImage.memoryNetwork(
            key: Key(posterPath),
            placeholder: kTransparentImage,
            image: 'https://image.tmdb.org/t/p/w500/$posterPath',
            width: 130.0,
            fit: BoxFit.fitWidth,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildChildren(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren() {
    var children = <Widget>[
      MovieTitleColumn(title: title),
      RatingsRow(voteAverage: voteAverage, voteCount: voteCount)
    ];

    if (genres != null && genres.isNotEmpty) {
      children.add(GenreWidget(genres: genres));
    }
    return children;
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
