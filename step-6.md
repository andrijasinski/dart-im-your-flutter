# Step 6
The app is almost finished now.The only thing we need to do make sure we show all the movies the API can return to us.
We are currently only showing 1 page of the API and we want to show more pages as the user scroll the list.
Also we want to make the list more useful to the user so we are going to sort it by release date ascending and descending.

## What you will build
The methods that we need to use are already there, they just need to be implemented. Lets start with the `ScrollController` we need to create a new instance of that in the `MoviesPageState` class.
```dart
final ScrollController _scrollController = ScrollController();
```
Now that we have an instance of the `ScrollController` we can pass that to `MovieGridView` via the constructor. Once that is done we can set the `ScrollController` on the `GridView.builder(controller: _scrollController,)`.
So the `ScrollController` has been added to the `GridView` now we need to make sure we list to the scroll events. We do this by adding a listener to `_scrollController` in `initState` and remove it again in `dispose` the.
This is a simple void closure that is called every time the `GridView` is scrolled so in `_scrollListener` we need to ask the `_scrollController` how pixels are currently not drawn on the screen.
We can do this like so
```dart
void _scrollListener() {
  if (_scrollController.position.extentAfter < 500 ) {
    // here we can ask for more Movies.
  }
}
```
No we can start asking for more movies but If i'm not mistaken we are currently not keep the list of movies yet. So we need to create 2 fields 1 for the movies and on for the pages.
```dart
final List<MovieSearchResultCollection> _collections = List();
final List<MovieSearchResult> _cache = List();
```
The `MovieSearchResultCollection` all have a list of movies but we want to store that in a separate field so we don't have to loop through multiple lists every time we need a list of movies.
We also need to be able to get the last current page we got from the API and the total pages for this collection.

```dart
page() => _collections.last.page;

totalPages() => _collections.last.totalPages;
```
So now we can do this so we limit our api requests
```dart
void _scrollListener() {
  if (_scrollController.position.extentAfter < 500 &&
              page() <= totalPages()) {
    // here we can ask for more Movies.
  }
}
```
No was you might remember from [step 1](step-1.md) we can execute method on a `Future`. So me might want to do something like his.
```dart
_client.getMovieSearchResultsByPage(page() + 1)
  .then((value) {
    setState(() {
      _updateList(value);
    });
  });
```

When we receive the new page we call `setState` because we change the state and want the widget to re-render it self with the new state.
In `updateList()` we should implement this
```dart
_collections.add(data);
_collections.sort((a, b) => a.page.compareTo(b.page));

var movies = _collections.map((entry) => entry.results).fold(
    List<MovieSearchResult>(),
    (previous, List<MovieSearchResult> element) =>
        previous..addAll(element));

_cache.clear();
_cache.addAll(movies);
```
So we add he last received page and sort the pages once the pages are sorted we create a new temporary list of movies that is sorted based on the pages.
Then we clear the old list and the newly created temporary list. Another side effect of keeping a cache list of movies is that we can check if have movies if so immediately so the list and don't have to load it again from the network.
We do this by adding an if to `_movieListWidgetFuture` and check if `_cache` is empty if not empty just return `MovieGridView` immediately.

Now we can also sort the list for the user based on the release data.
So we implement both `_sortAscending` and `_sortDescending`

```dart
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
```

This also happens inside setState so that the widget knows the state has changed, and can re-render the list.

## What you'll learn
* changing the state of an stateful widget.
* learn how to use [ScrollController](https://docs.flutter.io/flutter/widgets/ScrollController-class.html)
