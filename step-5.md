# Step 5
Now that we can show some movie info, the app begins to look great but the search results only contain some information about the movies
We want to show additional data like reviews and genres. We can do this by using the same technique we use in the main page with a FutureBuilder.

## What you will build
So we want to enrich the movie data we already have, we can do this by using the id in the `MovieSearchResult` making a new API request using the [ApiClient](lib/services/api.dart).
In [step 1](step-1.md) we implemented getting the `MovieSearchResultCollection` by fixing the method `_getMovieSearchResults` you also might have done that for the method `getMovie` if not we can do this now.
`_getMovie` should return a `Future` of `Movie`, and as we learned in [step 2](step-2.md) we can use a `FutureBuilder` to handle the construction of widgets based on the state of the `Future`
If we do that now the loading state can be the `MinimalMovieInfo` where is shows the basic info an if its loading show a `LoadingSpinner` at the bottom.
When the `Future` returns the additional data we can show `FullMovieInfo` widget where we also so the Genres, tag line and Reviews.

## What you'll learn
* progressively load ui from minimal to full fledged.
* reuse knowledge from previous steps.
