class ApiUrl{
  // BASE URL
  static const String kBaseUrl = "https://api.themoviedb.org/3/";

  // API KEY
  static const String kApiKey = "YOUR API KEY";

  // URL 
  static const String popularMovie = "${kBaseUrl}movie/popular";
  static const String trendingMovie = "${kBaseUrl}trending/movie/week";
  static String rateMovie(List<String> args) => "${kBaseUrl}movie/${args[0]}/rating";
  static const String searchMovie = "${kBaseUrl}search/movie";
  static const String nowPlayingMovie = "${kBaseUrl}movie/now_playing";
}