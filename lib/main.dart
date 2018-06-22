import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:star_wars_movies/custom_widgets.dart';
import 'package:star_wars_movies/models/models.dart';
import 'package:star_wars_movies/movie_page.dart';
import 'package:star_wars_movies/services/api.dart';
import 'package:transparent_image/transparent_image.dart';

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

class MoviePageWrapper {
  final List<MovieSearchResultCollection> _collections = List();
  final List<MovieSearchResult> _cache = List();
  bool _sortAscending;

  int page() => _collections.last.page;

  int totalPages() => _collections.last.totalPages;

  List<MovieSearchResult> update(MovieSearchResultCollection add) {
    _collections.add(add);
    _collections.sort((a, b) => a.page.compareTo(b.page));

    return _movies();
  }

  List<MovieSearchResult> movies() {
    if (_cache.isEmpty && _collections.isNotEmpty) {
      return _movies();
    }
    return _cache;
  }

  void sortAscending() {
    _sortAscending = true;
    _cache.sort((a, b) =>
        a.releaseDate?.compareTo(b.releaseDate) ?? b != null ? -1 : 0);
  }

  void sortDescending() {
    _sortAscending = false;
    _cache.sort(
        (a, b) => b.releaseDate?.compareTo(a.releaseDate) ?? a != null ? 1 : 0);
  }

  List<MovieSearchResult> _movies() {
    var movies = _collections.map((entry) => entry.results).fold(
        List<MovieSearchResult>(),
        (previous, List<MovieSearchResult> element) =>
            previous..addAll(element));
    _cache.clear();
    _cache.addAll(movies);

    if (_sortAscending != null) {
      if (_sortAscending) {
        sortAscending();
      } else {
        sortDescending();
      }
    }
    return _cache;
  }
}

class MoviesPage extends StatefulWidget {
  MoviesPage({Key key, this.title}) : super(key: key);

  final String title;

  final DateFormat _dateFormat = new DateFormat('yyyy');

  final MoviePageWrapper _wrapper = MoviePageWrapper();

  final ScrollController _scrollController = ScrollController();

  @override
  MoviesPageState createState() =>
      new MoviesPageState(scrollController: _scrollController);

  void sortAscending() => _wrapper.sortAscending();

  void sortDescending() => _wrapper.sortDescending();

  List<MovieSearchResult> updateData(MovieSearchResultCollection data) =>
      _wrapper.update(data);

  List<MovieSearchResult> movies() => _wrapper.movies();

  int page() => _wrapper.page();

  int totalPages() => _wrapper.totalPages();
}

class MoviesPageState extends State<MoviesPage> {
  final ApiClient _client = new ApiClient();
  final ScrollController scrollController;

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
    if (widget.movies().isEmpty) {
      return FutureBuilder<MovieSearchResultCollection>(
        future: client.getMovieSearchResults(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return LoadingSpinner(text: 'Loading');
            default:
              if (snapshot.hasError) {
                return ErrorMessageWidget(error: snapshot.error);
              } else {
                return MovieGridView(
                    movies: widget.updateData(snapshot.data),
                    dateFormat: widget._dateFormat,
                    scrollController: scrollController);
              }
          }
        },
      );
    } else {
      return MovieGridView(
          movies: widget.movies(),
          dateFormat: widget._dateFormat,
          scrollController: scrollController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: <Widget>[
          ActionItemWidget(
              icon: Icons.arrow_upward,
              onPressed: _sortAscending,
              tooltip: 'Sort ascending'),
          ActionItemWidget(
              icon: Icons.arrow_downward,
              onPressed: _sortDescending,
              tooltip: 'Sort Descending'),
        ],
      ),
      body: _movieListWidgetFuture(_client),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sortAscending() {
    widget.sortAscending();
    setState(() {
      widget._wrapper._cache.sort((a, b) =>
          a?.releaseDate?.compareTo(b.releaseDate) ?? b != null ? -1 : 0);
    });
  }

  void _sortDescending() {
    setState(() {
      widget._wrapper._cache.sort((a, b) =>
          b?.releaseDate?.compareTo(a.releaseDate) ?? a != null ? 1 : 0);
    });
  }

  void _scrollListener() {
    print(scrollController.position.extentAfter);
    if (scrollController.position.extentAfter < 500 &&
        widget.page() <= widget.totalPages()) {
      print('load more data data data');
      _client
          .getMovieSearchResultsByPage(widget.page() + 1)
          .then((value) => widget.updateData(value))
          .whenComplete(() => setState(() {
                print('reload screen');
              }));
    }
  }
}

class MovieGridView extends StatelessWidget {
  final List<MovieSearchResult> movies;
  final DateFormat dateFormat;
  final ScrollController scrollController;

  MovieGridView({Key key, this.movies, this.dateFormat, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: _createSliverGridDelegate(),
      itemCount: movies.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) =>
          MovieCardView(movie: movies[index], dateFormat: dateFormat),
    );
  }

  SliverGridDelegateWithFixedCrossAxisCount _createSliverGridDelegate() {
    return SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, childAspectRatio: 0.65);
  }
}

class MovieCardView extends StatelessWidget {
  final MovieSearchResult movie;
  final DateFormat dateFormat;

  const MovieCardView(
      {Key key, @required this.movie, @required this.dateFormat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          _onTapGridItem(movie, context);
        },
        child: Card(
          elevation: 6.0,
          child: GridTile(
              child: FadeInImage.memoryNetwork(
                key: Key(movie.posterPath),
                placeholder: kTransparentImage,
                image: "https://image.tmdb.org/t/p/w154/${movie.posterPath}",
                fit: BoxFit.fitHeight,
              ),
              footer: GridTileBar(
                title: Text(movie.title),
                subtitle: movie.releaseDate != null
                    ? Text(dateFormat.format(movie.releaseDate))
                    : "TBA",
                backgroundColor: Colors.black45,
              )),
        ));
  }

  void _onTapGridItem(MovieSearchResult movie, BuildContext context) {
    Navigator.push(context, MoviePageRoute.of(context, movie));
  }
}
