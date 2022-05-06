import 'dart:convert';

import 'package:intl/intl.dart';

class Movie {
  int id;
  String? title;
  DateTime? releaseDate;
  String? overview;
  double? voteAverage;
  String? posterImagePath;

  Movie({
    required this.id,
    this.title,
    this.releaseDate,
    this.overview,
    this.voteAverage,
    this.posterImagePath,
  });

  String? get posterImageUrl {
    if (posterImagePath != null) {
      return "https://image.tmdb.org/t/p/w500$posterImagePath";
    }
  }

  String? get posterImageUrlSmall {
    if (posterImagePath != null) {
      return "https://image.tmdb.org/t/p/w200$posterImagePath";
    }
  }

  String? get releaseDateFormatted {
    if (releaseDate != null) {
      return DateFormat("MMM dd, yyyy").format(releaseDate!);
    }
  }

  String? get releaseDateYear {
    if (releaseDate != null) {
      return DateFormat("yyyy").format(releaseDate!);
    }
  }

  String? get voteAverageString {
    if (voteAverage != null) {
      return voteAverage.toString();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "release_date": releaseDate != null
          ? DateFormat("yyyy-MM-dd").format(releaseDate!)
          : null,
      "vote_average": voteAverage,
      "poster_path": posterImagePath,
      "overview": overview,
    };
  }

  Movie copy() {
    return Movie(
      id: id,
      title: title,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      posterImagePath: posterImagePath,
      overview: overview,
    );
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    DateTime? releaseDate;
    if (map["release_date"] != null) {
      try {
        releaseDate = DateFormat("yyyy-MM-dd").parse(map["release_date"]);
      } catch (e) {
        releaseDate = null;
      }
    }

    double? voteAverage;
    if (map["vote_average"] != null) {
      if (map["vote_average"] is int) {
        int value = map["vote_average"];
        voteAverage = value.toDouble();
      } else if (map["vote_average"] is double) {
        voteAverage = map["vote_average"];
      }
    }

    return Movie(
      id: map["id"],
      title: map["title"],
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      posterImagePath: map["poster_path"],
      overview: map["overview"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) => Movie.fromMap(json.decode(source));
}
