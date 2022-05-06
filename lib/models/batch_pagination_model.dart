import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/models/movie.dart';

class BatchPaginationModel{
  List<Movie> listMovie;
  int pageNumber;
  GlobalKey keyWidget;

  BatchPaginationModel({
    required this.listMovie,
    required this.pageNumber,
    required this.keyWidget,
  });
}