# Step 2
In the previous step we learned how to a list of Star Wars movies from the [themoviedb.org](https://www.themoviedb.org/).
Now we are going to use that to build the UI for the app, show a loading indicator when we are loading the movies and then show a GridView.

## What you will build
The basic setup for the main screen is already created in [main.dart](lib/main.dart). We are just missing the implementations.
In Flutter the UI is composed of a nest tree of widgets. These widgets can either be **stateless** the state injected through the constructor and widget is created.
Then there are also **stateful** widgets which can holds and redraw when the state changes, think of an infinite scrolling list you begin with 10 items and when you are close to the end 10 more items are loaded added to the initial 10 list items.

We have an **stateless** widget as the root of our application `MyApp` where we set the title and theme for the app. The body of the app is the actual UI for this page where we are going to show the GridView of movies.
The `MoviesPage` is een stateful widget and will keep the state in this case an List of `MovieSearchCollection` the only job of this widget is to keep the list state and recreate the UI when necessary. 
The class `MoviesPageState` job is to create the UI given the state it has.

The ApiClient that we implemented in [step 1](step-1.md) returns a Future where we know that are going to get `MovieSearchCollection` now we can wire this up our self if we really want to but the Flutter Framework has special widget for this call the [FutureBuilder](https://docs.flutter.io/flutter/widgets/FutureBuilder-class.html).
This which takes a Future as parameter and builder parameter which build the actual widget based on the state of the snapshot its passed. The snapshot can tell us if its waiting or done and it will hold the data the future returns or an error if an error occurred during the execution of the future.
Know this we can create a simple `switch` that handles the cases we know that can happen.

```dart
Widget _movieListWidgetFuture(ApiClient client) {
  return FutureBuilder<MovieSearchResultCollection>(
    future: client.getMovieSearchResults(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          // show a loading state
        default:
          // handle complete and error state.
      }
    },
  );
}
```

We want to show a loading spinner to the user with the text loading centered in the the view.

```dart
Center(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [new CircularProgressIndicator(), new Text('loading')],
  ),
);
```

The `Center` widget centers it child widget and a `Column` widget lays out its children vertically.
A `CircularProgressIndicator` shows the spinner and the `Text` widget renders the text you pass a argument.

Now that we show that the data is loading, we can create start with creating the widget we want to show the movies.
In the default case we have a `snapshot` that either contains the data we want or an error. So can use a simple if to handle that.

```dart
if (!snapshot.hasError) {
  return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65),
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int index) =>
            Text(snapshot.data.results[index].title),
      );
} else {
  return Center( child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.error, color: Colors.red),
          new Text('Error: ${snapshot.error}'),
        ],
      ));
}
```

If we don't have an error create a `GridView` widget with the contents of, the `gridDelegate` handles the sizing of the grid items.
The `itemCount` is the number of items this `GridView` going to have and the `itemBuilder` build the widgets that are use as the list items.
In this case we are just return a `Text` widget which has the title of the movie.


## What you'll learn
* How to create a UI.
* What Widgets are
* How to use Futures to create complex widgets
