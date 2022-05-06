import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tmdb_movie_app/core/styles/colors.dart';
import 'package:tmdb_movie_app/core/styles/text_styles.dart';
import 'package:tmdb_movie_app/core/utils/local_database_config.dart';
import 'package:tmdb_movie_app/core/utils/navigation.dart';
import 'package:tmdb_movie_app/core/utils/routes.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:tmdb_movie_app/providers/app_theme_provider.dart';
import 'package:tmdb_movie_app/providers/favorite_movie_provider.dart';
import 'package:tmdb_movie_app/providers/main_navigation_provider.dart';
import 'package:tmdb_movie_app/providers/popular_movie_provider.dart';
import 'package:tmdb_movie_app/providers/profile_provider.dart';
import 'package:tmdb_movie_app/providers/rate_movie_provider.dart';
import 'package:tmdb_movie_app/providers/search_movie_provider.dart';
import 'package:tmdb_movie_app/providers/trending_movie_provider.dart';
import 'package:tmdb_movie_app/screens/detail/detail_screen.dart';
import 'package:tmdb_movie_app/screens/edit_profile/edit_profile_screen.dart';
import 'package:tmdb_movie_app/screens/main/main_screen.dart';
import 'package:tmdb_movie_app/screens/setting/setting_screen.dart';
import 'package:tmdb_movie_app/services/background_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool(SharedPrefConfig.kThemeDarkMode) ?? false;
  ThemeMode? themeMode = isDarkMode ? ThemeMode.dark : null;

  BackgroundService backgroundService = BackgroundService();
  backgroundService.setReminder();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MyApp(themeMode: themeMode),
    );
  });
}

class MyApp extends StatelessWidget {
  final ThemeMode? themeMode;
  const MyApp({Key? key, required this.themeMode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoriteMovieProvider>(
            create: (context) => FavoriteMovieProvider()),
        ChangeNotifierProvider<AppThemeProvider>(
            create: (context) => AppThemeProvider(themeModeInitial: themeMode)),
        ChangeNotifierProvider<ProfileProvider>(
            create: (context) => ProfileProvider()),
        ChangeNotifierProvider<MainNavigationProvider>(
            create: (context) => MainNavigationProvider()),
        ChangeNotifierProvider<SearchMovieProvider>(
            create: (context) => SearchMovieProvider()),
        ChangeNotifierProvider<RateMovieProvider>(
            create: (context) => RateMovieProvider()),
        ChangeNotifierProvider<PopularMovieProvider>(
            create: (context) => PopularMovieProvider()),
        ChangeNotifierProvider<TrendingMovieProvider>(
            create: (context) => TrendingMovieProvider()),
      ],
      child: Consumer<AppThemeProvider>(
        builder: (context, model, child) {
          return MaterialApp(
            title: 'TMDB Movie App',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: kColorLightScheme,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              textTheme: kTextThemeLight,
            ),
            darkTheme: ThemeData(
              colorScheme: kColorDarkScheme,
              primarySwatch: Colors.blueGrey,
              scaffoldBackgroundColor: const Color(0xff25262E),
              textTheme: kTextThemeDark,
            ),
            themeMode: model.themeMode,
            home: const MainScreen(),
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case detailMovieRoute:
                  return MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(
                          movie: settings.arguments as Movie));
                case editProfileRoute:
                  return MaterialPageRoute(
                      builder: (_) => const EditProfileScreen());
                case settingRoute:
                  return MaterialPageRoute(
                      builder: (_) => const SettingScreen());
                default:
                  return MaterialPageRoute(
                    builder: (_) {
                      return const Scaffold(
                        body: Center(
                          child: Text('Page not found :('),
                        ),
                      );
                    },
                  );
              }
            },
          );
        },
      ),
    );
  }
}
