# Step 1
We are going to use the [TheMovieDB.org API](https://developers.themoviedb.org/3/search/search-movies) to search for all movies related to star wars.
The basic setup has already been provided. In [models.dart](lib/models/models.dart) you can find the response from the API we will be using. 
These model classes us a dependency on `json_serializable` which can be found in [pubspec.yml](pubspec.yaml) to generate the code the marshal the json to an object.

## What you will build
We will be building the first part of our application, The models are already created to speed up the process.
You need to add `json_annotation: ^0.2.8` to the `dependencies` block in the [pubspec.yml](pubspec.yaml) and `build_runner: ^0.8.10` and `json_serializable: ^0.5.7` to de `dev_dependencies` block.
Once you have done this run packets get which is in the toolbar of the file from intellij/Android Studio you can also execute `flutter packages pub get` from the terminal if you prefer that. 
The build system will start downloading the dependencies and add them to the project. 
When this is finish run `flutter packages pub run build_runner build` which will generate the implementation for the models that are specified in [models.dart](lib/models/models.dart) it should create a new file in the same directory called `models.g.dart` 

No lets start by implement the Api calls for get the movie search results and the get the movie details.
In [api.dart](lib/services/api.dart) we have an empty implementations for the methods `_getMovieSearchResults(Uri uri)` and `_getMovie(Uri uri)` These methods return a typed `Future`.
For making an HTTP request we need an HTTP client which we can get as library from pub by adding `http: ^0.11.3+16` to our [pubspec.yml](pubspec.yaml) and running get packages.
Add `import 'package:http/http.dart' as http;` to the top of the [api.dart](lib/services/api.dart) file this will give access to an http client which is aliased to `http`.
The `http` client has all the http methods `GET`, `POST`, `PUT`, `PATCH`, `HEAD`. We will be using a `get` call so add 

```dart
final response = await http.get(uri, headers: {"Accept": "application/json"});
``` 
to the method. This will give access to the response object form the http request which a body and headers and status code of the request.

The response body we want to convert that json string an `MovieSearchResultCollection` we can do this by creating a `JsonDecoder` and calling its `convert` method with the response body as input.
We get an map from the convert method back which contains all the JSON data from that map we want create our object.

```dart
final Map<String, dynamic> map = JsonDecoder().convert(response.body);

return MovieSearchResultCollection.fromJson(map);
```
                                                                                                            
Now also do the same for the other unimplemented method `_getMovie(Uri uri)`.

Now that the network calls are implemented we can try them out in the app. Go to [main.dart](lib/main.dart) and in the `MoviesPageState` class add this.

```dart
@override
void initState() {
  super.initState();
  var client = ApiClient();
  client.getMovieSearchResults().then((value) {
    for (var movie in value.results) {
      print(movie.title);
      }
  });
}
```

When the app runs it should do the api call and print the movie titles in the log.

## What you'll learn
* How to add dependencies the a flutter project.
* Generate code with `build_runner`
* Make a API requests
* Serialize JSON to object models.
* How to execute a future.