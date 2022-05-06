import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/size_responsive_helper.dart';
import 'package:tmdb_movie_app/core/utils/state_enum.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:tmdb_movie_app/providers/search_movie_provider.dart';
import 'package:tmdb_movie_app/widgets/movie_widget.dart';
import 'package:provider/provider.dart';

class ResultSearchMovieListWidget extends StatefulWidget {
  const ResultSearchMovieListWidget({Key? key}) : super(key: key);

  @override
  State<ResultSearchMovieListWidget> createState() =>
      ResultSearchMovieListWidgetState();
}

class ResultSearchMovieListWidgetState
    extends State<ResultSearchMovieListWidget> {
  Key centerKey = const ValueKey('center-list');

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchMovieProvider>(builder: (context, model, child) {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          final maxScroll = scrollNotification.metrics.maxScrollExtent;
          final minScroll = scrollNotification.metrics.minScrollExtent;

          final currentScroll = scrollNotification.metrics.pixels;

          if (currentScroll == maxScroll) {
            Provider.of<SearchMovieProvider>(context, listen: false)
                .loadBottomPagination();
            return true;
          }

          if (currentScroll == minScroll) {
            Provider.of<SearchMovieProvider>(context, listen: false)
                .loadTopPagination();
            return true;
          }

          return false;
        },
        child: CustomScrollView(
          center: centerKey,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return topPaginationWidget(model);
                },
                childCount: 1,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: listTopPaginationWidget(model),
                  );
                },
                childCount: 1,
              ),
            ),
            SliverList(
              key: centerKey,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return Column(
                      children: listBottomPaginationWidget(model),
                    );
                  } else if (index == 1) {
                    return bottomPaginationWidget(model);
                  } else {
                    return model.optionType ==
                             SearchType.withIndex
                        ? SizedBox(
                            height: Responsive.size(context,
                                small: 70, medium: 80, large: 90),
                          )
                        : const SizedBox(height: 0);
                  }
                },
                childCount: 3,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget bottomPaginationWidget(SearchMovieProvider model) {
    if (model.optionType ==  SearchType.withIndex) {
      return const SizedBox();
    }

    if (model.stateBottomPagination == ResultState.error) {
      String errorMessage = model.detailMessageBottomPagination;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Provider.of<SearchMovieProvider>(context, listen: false)
                    .reloadBottomPagination();
              },
              child: const Text("Reload"),
            ),
            const SizedBox(height: 10),
            Text(errorMessage),
            const SizedBox(height: 10),
            const SizedBox(height: 90),          
          ],
        ),
      );
    }

    if (model.currentBottomPage < model.totalPage &&
        model.stateBottomPagination == ResultState.loading) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    } else {
      return const SizedBox(height: 30);
    }
  }

  Widget topPaginationWidget(SearchMovieProvider model) {
    if (model.optionType ==  SearchType.withIndex) {
      return const SizedBox();
    }

    if (model.stateTopPagination == ResultState.error) {
      String errorMessage = model.detailMessageTopPagination;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Provider.of<SearchMovieProvider>(context, listen: false)
                    .reloadTopPagination();
              },
              child: const Text("Reload"),
            ),
            const SizedBox(height: 10),
            Text(errorMessage),
            const SizedBox(height: 10),
          ],
        ),
      );
    }

    if (model.currentTopPage > 1) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    } else {
      return const SizedBox(height: 10);
    }
  }

  List<Widget> listTopPaginationWidget(SearchMovieProvider model) {
    return List.generate(
      model.data.length,
      (index) {
        var mapData = model.data[index];
        int page = mapData.pageNumber;
        List<Movie> items = mapData.listMovie;
        GlobalKey key = mapData.keyWidget;

        if (model.optionType ==  SearchType.lazyLoading &&
            page < model.showedPageNumber) {
          return Column(
            key: key,
            children: List.generate(items.length, (index) {
              return pageItemRender(items[index]);
            }),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  List<Widget> listBottomPaginationWidget(SearchMovieProvider model) {
    return List.generate(
      model.data.length,
      (index) {
        var mapData = model.data[index];
        int page = mapData.pageNumber;
        List<Movie> items = mapData.listMovie;
        GlobalKey key = mapData.keyWidget;

        if (model.optionType ==  SearchType.withIndex &&
            model.showedPageNumber == page) {
          return Column(
            key: key,
            children: List.generate(items.length, (index) {
              return pageItemRender(items[index]);
            }),
          );
        } else if (model.optionType ==  SearchType.lazyLoading &&
            page >= model.showedPageNumber) {
          return Column(
            key: key,
            children: List.generate(items.length, (index) {
              return pageItemRender(items[index]);
            }),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget pageItemRender(Movie movie) {
    return MovieWidget(
      movie: movie,
      tag: "search",
      isVertical: true,
    );
  }
}
