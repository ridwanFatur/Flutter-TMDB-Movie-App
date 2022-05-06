import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/database_helper.dart';
import 'package:tmdb_movie_app/core/utils/local_database_config.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:sembast/sembast.dart';

class FavoriteMovieProvider extends ChangeNotifier {
  List<Movie> listMovie;
  FavoriteMovieProvider({this.listMovie = const []}) {
    initListMovie();
  }

  void initListMovie() async {
    Database db = await LocalDatabase.instance.database;
    var store = intMapStoreFactory.store(SembastConfig.kFavoriteMovieKey);
    List response = await store.find(db);
    List<Movie> listMovie = [];
    for (var snapshot in response) {
      listMovie.add(
        Movie.fromMap(
          snapshot.value,
        ),
      );
    }
    this.listMovie = listMovie;
    notifyListeners();
  }

  bool isFavoriteById(int id) {
    bool found = false;
    for (var movie in listMovie) {
      if (movie.id == id) {
        found = true;
        break;
      }
    }
    return found;
  }

  void addToLocalDatabase(Movie movie) async {
    Database db = await LocalDatabase.instance.database;
    var store = intMapStoreFactory.store(SembastConfig.kFavoriteMovieKey);
    await store.add(db, movie.toMap());
  }

  void removeFromLocalDatabase(Movie movie) async {
    Database db = await LocalDatabase.instance.database;
    var store = intMapStoreFactory.store(SembastConfig.kFavoriteMovieKey);
    var finder = Finder(
      filter: Filter.and([
        Filter.equals("id", movie.id),
      ]),
    );
    await store.delete(db, finder: finder);
  }

  void toggleFavoriteMovie(Movie movie) {
    if (!isFavoriteById(movie.id)) {
      listMovie.add(movie);
      addToLocalDatabase(movie);
      notifyListeners();
    } else {
      listMovie.removeWhere((element) {
        return element.id == movie.id;
      });
      removeFromLocalDatabase(movie);
      notifyListeners();
    }
  }
}
