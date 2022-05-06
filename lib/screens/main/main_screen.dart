import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/local_notify_manager.dart';
import 'package:tmdb_movie_app/core/utils/navigation.dart';
import 'package:tmdb_movie_app/core/utils/routes.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:tmdb_movie_app/providers/main_navigation_provider.dart';
import 'package:tmdb_movie_app/providers/search_movie_provider.dart';
import 'package:tmdb_movie_app/screens/home/home_screen.dart';
import 'package:tmdb_movie_app/screens/profile/profile_screen.dart';
import 'package:tmdb_movie_app/screens/search/search_screen.dart';
import 'package:tmdb_movie_app/widgets/dialog_exit_widget.dart';
import 'package:tmdb_movie_app/screens/main/components/panel_pagination_widget.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }

  void onNotificationReceive(ReceiveNotification notification) {}

  void onNotificationClick(String payload) {
    try {
      var payloadMap = json.decode(payload);
      if (payloadMap["id"] == "no_id") {
        Navigation.backToRoot();
        Provider.of<MainNavigationProvider>(context, listen: false).setPage(0);
        Provider.of<SearchMovieProvider>(context, listen: false)
            .checkOpenClosePaginationByNavigation(0);
      } else {
        Movie movie = Movie.fromMap(payloadMap);
        Navigation.intentWithData(detailMovieRoute, movie);
      }
    } catch (e) {
      Navigation.backToRoot();
      Provider.of<MainNavigationProvider>(context, listen: false).setPage(0);
      Provider.of<SearchMovieProvider>(context, listen: false)
          .checkOpenClosePaginationByNavigation(0);
    }
  }

  List<Widget> pageList = [
    const HomeScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var exit = await showDialogExit(context);
        if (exit != null) {
          return true;
        }

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Consumer<MainNavigationProvider>(
              builder: (context, model, child) {
                return IndexedStack(
                  index: model.currentPage,
                  children: pageList,
                );
              },
            ),
            Positioned(
              bottom: 15,
              left: 20,
              right: 20,
              child: bottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNavigationBar() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          const PanelPaginationWidget(),
          Consumer<MainNavigationProvider>(
            builder: (context, model, child) {
              return SizedBox(
                height: 50,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconSize: 0,
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  selectedItemColor: Colors.blue,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  currentIndex: model.currentPage,
                  onTap: (int index) async {
                    Provider.of<MainNavigationProvider>(context, listen: false)
                        .setPage(index);
                    Provider.of<SearchMovieProvider>(context, listen: false)
                        .checkOpenClosePaginationByNavigation(index);
                  },
                  items: [
                    navBarItem(Icons.home, model.currentPage == 0, "Home"),
                    navBarItem(Icons.search, model.currentPage == 1, "Search"),
                    navBarItem(Icons.account_circle, model.currentPage == 2,
                        "Profile"),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem navBarItem(
      IconData icon, bool isActive, String label) {
    Color colorActive = Theme.of(context).colorScheme.primary;
    Color colorInactive = Theme.of(context).colorScheme.onSurface;

    return BottomNavigationBarItem(
      icon: SizedBox(
        width: 35,
        height: 35,
        child: Icon(
          icon,
          color: isActive ? colorActive : colorInactive,
          size: 30,
        ),
      ),
      label: label,
    );
  }
}
