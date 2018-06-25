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
  final ScrollController _scrollController = ScrollController();
  final ApiClient _client = new ApiClient();
  final DateFormat _dateFormat = new DateFormat('yyyy');

  final List<MovieSearchResultCollection> _collections = List();
  final List<MovieSearchResult> _cache = List();

  bool _sorted;
  bool loadMore = true;

  MoviesPageState();

  page() => _collections.last.page;

  totalPages() => _collections.last.totalPages;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  Widget _movieListWidgetFuture(ApiClient client) {
    if (_cache.isEmpty) {
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
                _updateList(snapshot.data);
                return MovieGridView(
                    movies: _cache,
                    dateFormat: _dateFormat,
                    scrollController: _scrollController);
              }
          }
        },
      );
    } else {
      return MovieGridView(
          movies: _cache,
          dateFormat: _dateFormat,
          scrollController: _scrollController);
    }
  }

  @override
  Widget build(BuildContext context) {
    loadMore = true;
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: _sortAscending,
              tooltip: 'Sort ascending'),
          IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: _sortDescending,
              tooltip: 'Sort Descending'),
        ],
      ),
      body: _movieListWidgetFuture(_client),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sortAscending() {
    setState(() {
      _sorted = true;
      _cache.sort((a, b) {
        if (a.releaseDate != null) {
          if (b.releaseDate != null) {
            return a.releaseDate.compareTo(b.releaseDate);
          } else {
            return 1;
          }
        } else {
          if (b.releaseDate != null) {
            return -1;
          } else {
            return 0;
          }
        }
      });
    });
  }

  void _sortDescending() {
    setState(() {
      _sorted = false;
      _cache.sort((a, b) {
        if (b.releaseDate != null) {
          if (a.releaseDate != null) {
            return b.releaseDate.compareTo(a.releaseDate);
          } else {
            return 1;
          }
        } else {
          if (a.releaseDate != null) {
            return -1;
          } else {
            return 0;
          }
        }
      });
    });
  }

  void _scrollListener() {
    if (loadMore &&
        _scrollController.position.extentAfter < 500 &&
        page() <= totalPages()) {
      loadMore = false;
      _client.getMovieSearchResultsByPage(page() + 1).then((value) {
        setState(() {
          _updateList(value);
        });
      });
    }
  }

  void _updateList(MovieSearchResultCollection data) {
    _collections.add(data);
    _collections.sort((a, b) => a.page.compareTo(b.page));

    var movies = _collections.map((entry) => entry.results).fold(
        List<MovieSearchResult>(),
        (previous, List<MovieSearchResult> element) =>
            previous..addAll(element));

    _cache.clear();
    _cache.addAll(movies);
    if (_sorted != null) {
      if (_sorted) {
        _sortAscending();
      } else {
        _sortDescending();
      }
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
    Navigator.push(context, MoviePageRoute.of(context, movie));
  }
}
