import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

final _releaseDateFormat = new DateFormat('yyyy-MM-dd');
DateTime _releaseDateFromJson(String date) =>
    date.isEmpty ? null : _releaseDateFormat.parse(date);
String _releaseDateToJson(DateTime date) =>
    date == null ? "" : _releaseDateFormat.format(date);

@JsonSerializable()
class MovieSearchResult extends Object with _$MovieSearchResultSerializerMixin {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  @JsonKey(name: 'poster_path')
  final String posterPath;
  @JsonKey(name: 'backdrop_path')
  final String backdropPath;
  @JsonKey(name: 'overview')
  final String overview;
  @JsonKey(
      name: 'release_date',
      nullable: true,
      toJson: _releaseDateToJson,
      fromJson: _releaseDateFromJson)
  final DateTime releaseDate;
  @JsonKey(name: 'popularity')
  final double popularity;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'adult')
  final bool adult;
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;

  MovieSearchResult(
      this.id,
      this.title,
      this.originalTitle,
      this.posterPath,
      this.backdropPath,
      this.overview,
      this.releaseDate,
      this.popularity,
      this.voteCount,
      this.voteAverage,
      this.adult,
      this.genreIds);

  factory MovieSearchResult.fromJson(Map<String, dynamic> json) =>
      _$MovieSearchResultFromJson(json);
}

@JsonSerializable()
class Movie extends Object with _$MovieSerializerMixin {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'imdb_id')
  final String imdbId;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  @JsonKey(name: 'poster_path')
  final String posterPath;
  @JsonKey(name: 'backdrop_path')
  final String backdropPath;
  @JsonKey(name: 'overview')
  final String overview;
  @JsonKey(name: 'tagline')
  final String tagline;
  @JsonKey(name: 'runtime')
  final int runtime;
  @JsonKey(name: 'revenue')
  final int revenue;
  @JsonKey(name: 'budget')
  final int budget;
  @JsonKey(name: 'video')
  final bool video;
  @JsonKey(name: 'adult')
  final bool adult;
  @JsonKey(name: 'homepage')
  final String homepage;
  @JsonKey(
      name: 'release_date',
      toJson: _releaseDateToJson,
      fromJson: _releaseDateFromJson)
  final DateTime releaseDate;
  @JsonKey(name: 'popularity')
  final double popularity;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @JsonKey(name: 'belongs_to_collection')
  final MovieCollection collection;
  @JsonKey(name: 'genres')
  final List<Genre> genres;
  @JsonKey(name: 'production_companies')
  final List<ProductionCompany> productionCompanies;
  @JsonKey(name: 'production_countries')
  final List<ProductionCountry> productionCountries;
  @JsonKey(name: 'spoken_languages')
  final List<SpokenLanguage> spokenLanguages;
  @JsonKey(name: 'credits')
  final Credits credits;
  @JsonKey(name: 'reviews')
  final ReviewCollection reviews;
  @JsonKey(name: 'images')
  final ImagesWrapper images;

  Movie(
      this.id,
      this.imdbId,
      this.title,
      this.originalTitle,
      this.posterPath,
      this.backdropPath,
      this.overview,
      this.tagline,
      this.runtime,
      this.revenue,
      this.budget,
      this.video,
      this.adult,
      this.homepage,
      this.releaseDate,
      this.popularity,
      this.voteCount,
      this.voteAverage,
      this.originalLanguage,
      this.collection,
      this.genres,
      this.productionCompanies,
      this.productionCountries,
      this.spokenLanguages,
      this.credits,
      this.reviews,
      this.images);

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}

@JsonSerializable()
class ImagesWrapper extends Object with _$ImagesWrapperSerializerMixin {
  @JsonKey(name: "backdrops")
  final List<ImageWrapper> backdrops;

  @JsonKey(name: "posters")
  final List<ImageWrapper> posters;

  ImagesWrapper(this.backdrops, this.posters);

  factory ImagesWrapper.fromJson(Map<String, dynamic> json) =>
      _$ImagesWrapperFromJson(json);
}

@JsonSerializable()
class ImageWrapper extends Object with _$ImageWrapperSerializerMixin {
  @JsonKey(name: 'aspect_ratio')
  final double aspectRatio;
  @JsonKey(name: 'file_path')
  final String filePath;
  @JsonKey(name: 'height')
  final int height;
  @JsonKey(name: 'width')
  final int width;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;

  ImageWrapper(this.aspectRatio, this.filePath, this.height, this.width,
      this.voteAverage, this.voteCount);

  factory ImageWrapper.fromJson(Map<String, dynamic> json) =>
      _$ImageWrapperFromJson(json);
}

@JsonSerializable()
class Credits extends Object with _$CreditsSerializerMixin {
  @JsonKey(name: 'cast')
  final List<Cast> cast;

  Credits(this.cast);

  factory Credits.fromJson(Map<String, dynamic> json) =>
      _$CreditsFromJson(json);
}

@JsonSerializable()
class Cast extends Object with _$CastSerializerMixin {
  @JsonKey(name: 'cast_id')
  final int castId;
  @JsonKey(name: 'gender')
  final int gender;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'order')
  final int order;
  @JsonKey(name: 'character')
  final String character;
  @JsonKey(name: 'credit_id')
  final String creditId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'profile_path')
  final String profilePath;

  Cast(this.castId, this.gender, this.id, this.order, this.character,
      this.creditId, this.name, this.profilePath);

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}

@JsonSerializable()
class Genre extends Object with _$GenreSerializerMixin {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;

  Genre(this.id, this.name);

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

@JsonSerializable()
class ProductionCompany extends Object with _$ProductionCompanySerializerMixin {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'logo_path')
  final String logoPath;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'origin_country')
  final String originCountry;

  ProductionCompany(this.id, this.logoPath, this.name, this.originCountry);

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanyFromJson(json);
}

@JsonSerializable()
class ProductionCountry extends Object with _$ProductionCountrySerializerMixin {
  @JsonKey(name: 'iso_3166_1')
  final String iso;
  @JsonKey(name: 'name')
  final String name;

  ProductionCountry(this.iso, this.name);

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountryFromJson(json);
}

@JsonSerializable()
class SpokenLanguage extends Object with _$SpokenLanguageSerializerMixin {
  @JsonKey(name: 'iso_639_1')
  final String iso;
  @JsonKey(name: 'name')
  final String name;

  SpokenLanguage(this.iso, this.name);

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) =>
      _$SpokenLanguageFromJson(json);
}

@JsonSerializable()
class MovieCollection extends Object with _$MovieCollectionSerializerMixin {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'poster_path')
  final String posterPath;
  @JsonKey(name: 'backdrop_path')
  final String backdropPath;

  MovieCollection(this.id, this.name, this.posterPath, this.backdropPath);

  factory MovieCollection.fromJson(Map<String, dynamic> json) =>
      _$MovieCollectionFromJson(json);
}

@JsonSerializable()
class MovieSearchResultCollection extends Object
    with _$MovieSearchResultCollectionSerializerMixin {
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'results')
  final List<MovieSearchResult> results;

  MovieSearchResultCollection(
      this.page, this.totalResults, this.totalPages, this.results);

  factory MovieSearchResultCollection.fromJson(Map<String, dynamic> json) =>
      _$MovieSearchResultCollectionFromJson(json);
}

@JsonSerializable()
class ReviewCollection extends Object with _$ReviewCollectionSerializerMixin {
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'results')
  final List<Review> results;

  ReviewCollection(this.page, this.totalResults, this.totalPages, this.results);

  factory ReviewCollection.fromJson(Map<String, dynamic> json) =>
      _$ReviewCollectionFromJson(json);
}

@JsonSerializable()
class Review extends Object with _$ReviewSerializerMixin {
  @JsonKey(name: 'author')
  final String author;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'url')
  final Uri url;

  Review(this.author, this.content, this.id, this.url);

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
