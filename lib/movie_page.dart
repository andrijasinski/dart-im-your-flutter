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

  MoviePage(
    this.movieSearchResult, {
    Key key,
  }) : super(key: key);

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
        return MinimalMovieInfo(
          movie: movieSearchResult,
          scaffoldKey: scaffoldKey,
          loading: true,
        );
      },
    );
  }
}

class MinimalMovieInfo extends StatelessWidget {
  final double appBarHeight = 256.0;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final MovieSearchResult movie;
  final bool loading;

  const MinimalMovieInfo({
    Key key,
    @required this.movie,
    @required this.scaffoldKey,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: buildSlivers(context),
    );
  }

  List<Widget> buildSlivers(BuildContext context) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: appBarHeight,
        pinned: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _onSharePressed,
            tooltip: 'Share movie',
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: HeaderImage(
              path: movie.backdropPath ?? movie.posterPath,
              appBarHeight: appBarHeight),
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate(buildSliverWidgets(context)),
      )
    ];
  }

  List<Widget> buildSliverWidgets(BuildContext context) {
    return <Widget>[
      MovieSpecsView(
        title: movie.title,
        posterPath: movie.posterPath,
        voteAverage: movie.voteAverage,
        voteCount: movie.voteCount,
        key: Key(movie.title),
      ),
      TextOverviewWidget(movie.overview, Theme.of(context).textTheme.body1),
    ];
  }

  void _onSharePressed() => Share.share("You should check ${movie.title}");
}

class FullMovieInfo extends StatelessWidget {
  final double appBarHeight = 256.0;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Movie movie;

  const FullMovieInfo({
    Key key,
    @required this.movie,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: buildSlivers(context),
    );
  }

  List<Widget> buildSlivers(BuildContext context) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: appBarHeight,
        pinned: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _onSharePressed,
            tooltip: 'Share movie',
          ),
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
    ];
  }

  SliverChildListDelegate buildSliverChildListDelegate(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SliverChildListDelegate(<Widget>[
      // implement widgets to show additional in movie information
    ]);
  }

  void _onSharePressed() => Share.share(
      "You should check ${movie.title} you can find more info at ${movie.homepage}");
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
    this.movie, {
    WidgetBuilder builder,
  }) : super(builder: builder);

  @override
  MovieSearchResult get currentResult => movie;

  static MoviePageRoute of(MovieSearchResult movie) => MoviePageRoute(
        movie,
        builder: (BuildContext context) => MoviePage(
              movie,
            ),
      );
}
