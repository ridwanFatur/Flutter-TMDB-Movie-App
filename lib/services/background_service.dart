import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/api_helper.dart';
import 'package:tmdb_movie_app/core/utils/api_url.dart';
import 'package:tmdb_movie_app/core/utils/local_notify_manager.dart';
import 'package:tmdb_movie_app/models/http_response.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:tmdb_movie_app/core/extensions/time_extension.dart';

class BackgroundService {
  void setReminder() async {
    TimeOfDay timeOfDayTarget = const TimeOfDay(hour: 10, minute: 0);
    TimeOfDay timeOfDayNow = TimeOfDay.now();

    int difference = timeOfDayTarget.toMinute() - timeOfDayNow.toMinute();
    if (difference < 0) {
      difference = 24 * 60 + difference;
    }

    const int alarmID = 0;
    await AndroidAlarmManager.oneShot(
      Duration(seconds: difference),
      alarmID,
      showDailyNotification,
      exact: true,
    );
  }

  static void showDailyNotification() async {
    try {
      HTTPResponse response = await APIHelper.get(
        http.Client(),
        ApiUrl.nowPlayingMovie,
        {},
      );
      List<Movie> listMovie = List<Movie>.from(
        response.data["results"].map((x) => Movie.fromMap(x)),
      );
      Movie movie = listMovie[0];
      await localNotifyManager.showNotification(
        "Hi User",
        "Let's see the new movie",
        movie.toJson(),
        movie,
      );
    } catch (e) {
      await localNotifyManager.showSimpleNotification(
          "Hi User", "Let's see another movies", '{"id": "no_id"}');
    }
    const int alarmID = 0;
    await AndroidAlarmManager.oneShot(
      const Duration(hours: 24),
      alarmID,
      showDailyNotification,
      exact: true,
    );
  }
}
