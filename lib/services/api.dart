import 'dart:async';

import 'package:star_wars_movies/models/models.dart';

/// A simple API client to work with themoviedb.org api version 3
/// Enter your API at [_API_KEY]
class ApiClient {
  static const String _API_KEY = '#############################';
  static const String _BASE_ENDPOINT = 'api.themoviedb.org';
  static const _BASE_QUERY_PARAM = {
    'api_key': _API_KEY,
    'language': 'en-US',
    'include_adult': 'false'
  };

  Future<MovieSearchResultCollection> _getMovieSearchResults(Uri uri) async {
//    return MovieSearchResultCollection.fromJson();
  }

  Future<MovieSearchResultCollection> getMovieSearchResults() async {
    final params = Map.of(_BASE_QUERY_PARAM);
    params.addAll({'query': 'Star Wars', 'page': '1'});

    final Uri uri = Uri.https(_BASE_ENDPOINT, '/3/search/movie', params);

    return _getMovieSearchResults(uri);
  }

  Future<MovieSearchResultCollection> getMovieSearchResultsByPage(
      int page) async {
    final params = Map.of(_BASE_QUERY_PARAM);
    params.addAll({'query': 'Star Wars', 'page': "$page"});

    final Uri uri = Uri.https(_BASE_ENDPOINT, '/3/search/movie', params);

    return _getMovieSearchResults(uri);
  }

  Future<Movie> getMovie(int id) async {
    final params = Map.of(_BASE_QUERY_PARAM);
    params.addAll({'append_to_response': 'credits,reviews,images'});
    final Uri uri = Uri.https(_BASE_ENDPOINT, '/3/movie/$id', params);

    return _getMovie(uri);
  }

  Future<Movie> _getMovie(Uri uri) async {
//    return Movie.fromJson();
  }
}
