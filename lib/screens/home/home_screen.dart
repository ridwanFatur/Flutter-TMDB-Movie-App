import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/asset_constants.dart';
import 'package:tmdb_movie_app/core/utils/navigation.dart';
import 'package:tmdb_movie_app/core/utils/routes.dart';
import 'package:tmdb_movie_app/core/utils/state_enum.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:tmdb_movie_app/providers/main_navigation_provider.dart';
import 'package:tmdb_movie_app/providers/popular_movie_provider.dart';
import 'package:tmdb_movie_app/providers/search_movie_provider.dart';
import 'package:tmdb_movie_app/providers/trending_movie_provider.dart';
import 'package:tmdb_movie_app/widgets/loading_shimmer_movie.dart';
import 'package:tmdb_movie_app/widgets/movie_widget.dart';
import 'package:tmdb_movie_app/screens/home/components/option_menu.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(const Duration(seconds: 0));
    Provider.of<PopularMovieProvider>(context, listen: false).requestData();
    Provider.of<TrendingMovieProvider>(context, listen: false).requestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Movie App",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OptionMenu(
                    onPressed: () {
                      Provider.of<MainNavigationProvider>(context,
                              listen: false)
                          .setPage(1);
                      Provider.of<SearchMovieProvider>(context, listen: false)
                          .checkOpenClosePagination();
                    },
                    icon: Icons.search,
                  ),
                  const SizedBox(width: 10),
                  OptionMenu(
                    onPressed: () {
                      Provider.of<MainNavigationProvider>(context,
                              listen: false)
                          .setPage(2);
                    },
                    icon: Icons.account_circle,
                  ),
                  const SizedBox(width: 10),
                  OptionMenu(
                    onPressed: () {
                      Navigation.intent(settingRoute);
                    },
                    icon: Icons.settings,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Popular Movie",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            popularMoviesWidget(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Trending Movie",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            trendingMoviesWidget(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget trendingMoviesWidget() {
    return Consumer<TrendingMovieProvider>(
      builder: (context, model, child) {
        if (model.state == ResultState.loading) {
          return const LoadingShimmerMovie(isGridView: true);
        }

        if (model.state == ResultState.error) {
          return Container(
            width: double.infinity,
            height: 250,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<TrendingMovieProvider>(context, listen: false)
                        .reload();
                  },
                  child: const Text("Reload"),
                ),
                const SizedBox(height: 10),
                Text(
                  model.detailMessage,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          );
        }

        if (model.data.isNotEmpty) {
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 3 / 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: model.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Movie movie = model.data[index];
              return MovieWidget(
                movie: movie,
                isGridView: true,
                tag: "trending",
              );
            },
          );
        } else {
          return Container(
            width: double.infinity,
            height: 250,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetConstant.kIconNotFound,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  "Empy Data",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget popularMoviesWidget() {
    return Consumer<PopularMovieProvider>(
      builder: (context, model, child) {
        if (model.state == ResultState.loading) {
          return const LoadingShimmerMovie();
        }

        if (model.state == ResultState.error) {
          return Container(
            width: double.infinity,
            height: 250,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<PopularMovieProvider>(context, listen: false)
                        .reload();
                  },
                  child: const Text("Reload"),
                ),
                const SizedBox(height: 10),
                Text(
                  model.detailMessage,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          );
        }

        if (model.data.isNotEmpty) {
          return SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemBuilder: (context, index) {
                Movie movie = model.data[index];
                return MovieWidget(
                  movie: movie,
                  tag: "popular",
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 20);
              },
              itemCount: model.data.length,
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            height: 250,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetConstant.kIconNotFound,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  "Empy Data",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
