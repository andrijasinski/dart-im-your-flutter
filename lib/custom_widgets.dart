import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:star_wars_movies/models/models.dart';
import 'package:transparent_image/transparent_image.dart';

class LoadingSpinner extends StatelessWidget {
  final String text;

  const LoadingSpinner({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: new Text(text),
          ),
        ],
      ),
    );
  }
}

class ErrorMessageWidget extends StatelessWidget {
  final String error;

  const ErrorMessageWidget({Key key, @required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.error, color: Colors.red),
        new Text('Error: $error'),
      ],
    ));
  }
}

class MovieTitleColumn extends StatelessWidget {
  final String title;

  const MovieTitleColumn({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: textTheme.title,
            textAlign: TextAlign.start,
            softWrap: true,
          )
        ]);
  }
}

class RatingsRow extends StatelessWidget {
  final double voteAverage;
  final int voteCount;

  const RatingsRow(
      {Key key, @required this.voteAverage, @required this.voteCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RatingsColumn(
          value: '$voteAverage',
          label: 'Rating',
        ),
        RatingsColumn(
          value: '$voteCount',
          label: 'Votes',
        ),
      ],
    );
  }
}

class RatingsColumn extends StatelessWidget {
  final String value;
  final String label;

  const RatingsColumn({Key key, @required this.value, @required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: textTheme.caption,
            ),
            Text(
              label,
              style: textTheme.caption,
            )
          ],
        ));
  }
}

class GenreWidget extends StatelessWidget {
  final List<Genre> genres;

  const GenreWidget({Key key, @required this.genres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 16.0),
      child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          runSpacing: 6.0,
          spacing: 6.0,
          children: List.generate(
              genres.length,
              (index) => Chip(
                    label: Text(genres[index].name),
                  ))),
    );
  }

  List<Widget> genreWidgets(List<Genre> genres) => List.generate(
      genres.length,
      (index) => Chip(
            label: Text(genres[index].name),
          ));
}

class ReviewsWidget extends StatelessWidget {
  final List<Review> reviews;

  const ReviewsWidget({Key key, @required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Text(
                  'Reviews',
                  style: textTheme.headline,
                )
              ],
            ),
          ),
        ]..addAll(buildReviewsList(reviews)),
      ),
    );
  }

  List<Widget> buildReviewsList(List<Review> reviews) => List.generate(
      reviews.length, (index) => buildReviewRowWidget(reviews[index]));

  Widget buildReviewRowWidget(Review review) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(review.author),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  review.content,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 6,
                ),
              ),
            )
          ],
        ));
  }
}

class HeaderImage extends StatelessWidget {
  final String path;
  final double appBarHeight;

  const HeaderImage({Key key, @required this.path, @required this.appBarHeight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: "https://image.tmdb.org/t/p/w780/$path",
          height: appBarHeight,
          fit: BoxFit.fitHeight,
        ),
        // This gradient ensures that the toolbar icons are distinct
        // against the background image.
        const DecoratedBox(
          decoration: const BoxDecoration(
            gradient: const LinearGradient(
              begin: const FractionalOffset(0.5, 0.0),
              end: const FractionalOffset(0.5, 0.30),
              colors: const <Color>[
                const Color(0x60000000),
                const Color(0x00000000)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TextOverviewWidget extends StatelessWidget {
  const TextOverviewWidget(
    this.text,
    this.style, {
    Key key,
  }) : super(key: key);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: style,
        ));
  }
}
