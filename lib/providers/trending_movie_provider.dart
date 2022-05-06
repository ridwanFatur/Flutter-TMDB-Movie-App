import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/api_helper.dart';
import 'package:tmdb_movie_app/core/utils/api_url.dart';
import 'package:tmdb_movie_app/core/utils/state_enum.dart';
import 'package:tmdb_movie_app/models/http_response.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:http/http.dart' as http;

class TrendingMovieProvider extends ChangeNotifier {
  List<Movie> data;
  ResultState state = ResultState.noData;
  String detailMessage = "";

  TrendingMovieProvider({
    this.data = const [],
  });

  void requestData() async {
    state = ResultState.loading;
    detailMessage = "";
    data = [];
    notifyListeners();

    try {
      HTTPResponse response = await APIHelper.get(
        http.Client(),
        ApiUrl.trendingMovie,
        {},
      );
      List<Movie> listMovie = List<Movie>.from(
        response.data["results"].map((x) => Movie.fromMap(x)),
      );

      state = ResultState.hasData;
      detailMessage = "";
      data = List.from(listMovie);
      notifyListeners();
    } catch (e) {
      String errorMessage =
          (e is HTTPResponse ? e.message : 'Something went wrong')!;
      state = ResultState.error;
      detailMessage = errorMessage;
      notifyListeners();
    }
  }

  void reload() async {
    requestData();
  }
}
