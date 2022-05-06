import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/api_helper.dart';
import 'package:tmdb_movie_app/core/utils/api_url.dart';
import 'package:tmdb_movie_app/models/http_response.dart';
import 'package:tmdb_movie_app/widgets/dialog_progress.dart';
import 'package:tmdb_movie_app/widgets/dialog_rate_movie_widget.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/widgets/show_toast.dart';

class RateMovieProvider extends ChangeNotifier {
  void rateMovie({required BuildContext context, required int movieId}) async {
    int? rateMovie = await showDialogRateMovie(context);
    if (rateMovie != null) {
      double rateMovieDouble = rateMovie.toDouble();
      try {
        var response = await showDialogProgress(context, (context) async {
          try {
            HTTPResponse result = await APIHelper.post(
              http.Client(),
              ApiUrl.rateMovie([movieId.toString()]),
              {},
              {"value": rateMovieDouble},
            );

            Navigator.pop(context, result);
          } catch (e) {
            Navigator.pop(context, e);
          }
        });

        if (response is HTTPResponse && response.isSuccessful){
          showToast("Success Rate Movie");
        }else{
          throw (response);
        }
      } catch (e) {
        String detailMessage =
            (e is HTTPResponse ? e.message : 'Something went wrong')!;
        Map<String, dynamic> detailMap = jsonDecode(detailMessage);
        showToast(detailMap["status_message"]);
      }
    }
  }
}
