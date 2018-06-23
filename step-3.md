# Step 3
In the [step 2](step-2.md) we created a `GridView` from the list of movies we got in [step 1](step-1.md)
No we are going to make the list more useful then just showing only the movie title.

## What you will build
Now that we are showing a List of movie titles, of course  if we want user to love our app we need make look more fancy by showing the movie poster and a release date.
So are going to create a `Card` that contains the movie poster the title and the release date of the movie.

```dart
GestureDetector(
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
```

The `Card` is wrapper in a `GestureDetector` and you would suspect by the name it detects gestures on the screen like tap long press or dragging.
The child of the `Card` widget is an `GridTile` gives us the ability to fill the list item entirely with an image in our case the movie poster.
For the we use an `FadeInImage` which is a convenience widget provide by Flutter you can give it a placeholder image an the url where the image is hosted and the widget will show the placeholder while loading the image and fade it in once its completely loaded.
We also want the poster to fit the height of this widget so it will be sized accordingly, we are also checking that the poster path is not null if so we just so an transparent image from memory.
In the `footer` of the `GridTile` we want to show the movie title and release date we make the background of the widget black with 54% transparency so the text will a good contrast and will be readable even if the movie poster has a white bottom. 

The `onTapGridItem` method we are going to use in [step 4](step-4.md) to handle the click on the list item.

## What you'll learn
* Creating more widgets
* Load images in the UI
