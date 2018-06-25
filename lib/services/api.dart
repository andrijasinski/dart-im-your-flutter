import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:star_wars_movies/models/models.dart';

/// A simple API client to work with themoviedb.org api version 3
/// Enter your API at [_API_KEY]
class ApiClient {
  static const String _API_KEY = 'YOUR API KEY HERE';
  static const String _BASE_ENDPOINT = 'api.themoviedb.org';
  static const _BASE_QUERY_PARAM = {
    'api_key': _API_KEY,
    'language': 'en-US',
    'include_adult': 'false'
  };

  final JsonDecoder _decoder = const JsonDecoder();

  Future<MovieSearchResultCollection> _getMovieSearchResults(Uri uri) async {
    final response =
        await http.get(uri, headers: {"Accept": "application/json"});

    final Map<String, dynamic> collectionResponseMap =
        _decoder.convert(response.body);

    return MovieSearchResultCollection.fromJson(collectionResponseMap);
  }

  Future<MovieSearchResultCollection> getMovieSearchResults() async {
    final params = Map.of(_BASE_QUERY_PARAM);
    params.addAll({'query': 'Star Wars', 'page': '1'});

    final Uri uri = Uri.https(_BASE_ENDPOINT, '/3/search/movie', params);

    return _getMovieSearchResults(uri);
  }

  Future<MovieSearchResultCollection> getMovieSearchResultsByPage(int page) {
    final params = Map.of(_BASE_QUERY_PARAM);
    params.addAll({'query': 'Star Wars', 'page': "$page"});

    final Uri uri = Uri.https(_BASE_ENDPOINT, '/3/search/movie', params);

    return _getMovieSearchResults(uri);
  }

  Future<Movie> getMovie(int id) async {
    final params = Map.of(_BASE_QUERY_PARAM);
    params.addAll({'append_to_response': 'credits,reviews,images'});
    final Uri uri = Uri.https(_BASE_ENDPOINT, '/3/movie/$id', params);

    final response =
        await http.get(uri, headers: {"Accept": "application/json"});

    final Map<String, dynamic> responseMap = _decoder.convert(response.body);
    return Movie.fromJson(responseMap);
  }
}
