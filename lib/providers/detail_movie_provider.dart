import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/state_enum.dart';
import 'package:tmdb_movie_app/models/movie.dart';

class DetailMovieProvider extends ChangeNotifier {
  final Movie movie;
  ResultState state = ResultState.noData;
  String detailMessage = "";

  DetailMovieProvider({required this.movie});
}
