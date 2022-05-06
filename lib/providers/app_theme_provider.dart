import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/local_database_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  AppThemeProvider({ThemeMode? themeModeInitial}) {
    if (themeModeInitial != null) {
      themeMode = themeModeInitial;
    }
  }

  void changeTheme(ThemeMode input) async {
    if (input != themeMode) {
      themeMode = input;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isDarkMode = input == ThemeMode.dark;
      await prefs.setBool(SharedPrefConfig.kThemeDarkMode, isDarkMode);
    }
  }
}
