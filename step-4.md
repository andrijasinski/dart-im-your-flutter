# Step 4
We should now have a working app showing a list of movies in a Grid. This is all fine and dandy but for user to really like our app we need to show a little bit more information about the movies then just the title and release date.
So in this step we are going to implement the movie detail page. Showing a nice header image the movie ratings the tag line and description of the movie

## What you will build
We are going to start with a new file [movie_detail_page.dart](lib/movie_detail_page.dart). The new page has the basic structure we want we just need to implement the logic and widgets we want to show onscreen.
When a user taps on a list item we want the app to open another page that shows the movie details in step 3 we already wrapped `MovieItemView` in gesture detector.
No we are going to use that navigate to a new page, we do this by calling the `Navigator` on which we want to push a new route, routes can be statically create at application start up then you can use an URI structure to go to a certain page, or you can dynamically create them by passing a by `Route` object.
We are going to us the dynamically create `Route` since we want to pass the movie to the next page. In [movie_detail_page.dart](lib/movie_detail_page.dart) we have the class `MoviePageRoute` where we need implement the `builder:` lambda to return a widget.
Once we implement that in [main.dart](lib/main.dart) in `MovieItemView` we can call the `Navigator` to push a new route an open the page.

```dart
Navigator.push(context, MoviePageRoute.of(movie));
```

Now the app should open a new page which has a `MovieSearchResult` as data which we can use to show somethings to the user. We are going to be using a `CustomScrollView` because the list item are all different types vs the GridView where are the items are the same and have the same dimensions.

First we are going to show a header image that loads the backdrop image. Most of the boiler plate is already there like `SliverAppBar` which widget that contains the appbar and has en expanded height. When you scroll up this widget will animate to the appbar.
The `FlexibleSpaceBar` is going to contain the image backdrop and a gradient so when we transition from image to the appbar the action buttons, back button and text are still visible.
The base url for the image is `https://image.tmdb.org/t/p/w780/`

Next we are going to add a `SliverList` to the `CustomScrollView` where we can add the rest of the widgets. The first widget we add is the `MovieSpecsView` which will show a poster of the movie the title rating and if available the genres of the movie.
The last widget we will add is the `TextOverviewWidget` which will show the show the movie description.

The last thing we want to add is an action button  in the toolbar so our users can share the movie with other people.

```dart
IconButton(
  icon: Icon(Icons.share),
  onPressed: _onSharePressed,
  tooltip: "Share movie",
)
```

And in `_onSharePressed` we can add `Share.share('You should check ${movie.title}')`

That's it for this step, lets move on to [step 5](step-5.md)

## What you'll learn
* Using the [Navigator](https://flutter.io/cookbook/navigation/navigation-basics/) to open new screens
* Use a [CustomScrollView](https://docs.flutter.io/flutter/widgets/CustomScrollView-class.html)
* re use things we learn in step 1, 2 and 3