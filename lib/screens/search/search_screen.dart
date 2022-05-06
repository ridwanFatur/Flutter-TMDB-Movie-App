import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/asset_constants.dart';
import 'package:tmdb_movie_app/core/utils/size_responsive_helper.dart';
import 'package:tmdb_movie_app/core/utils/state_enum.dart';
import 'package:tmdb_movie_app/providers/search_movie_provider.dart';
import 'package:tmdb_movie_app/widgets/input_search_text_field.dart';
import 'package:tmdb_movie_app/widgets/loading_shimmer_movie.dart';
import 'package:tmdb_movie_app/screens/search/components/option_type_search_widget.dart';
import 'package:tmdb_movie_app/screens/search/components/result_search_movie_list_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(const Duration(seconds: 0));
    Provider.of<SearchMovieProvider>(context, listen: false)
        .requestDataFirstAttempt();
  }

  @override
  void dispose(){
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxScrolled) {
                  return <Widget>[
                    textSearchWidget(),
                    optionsSectionWidget(),
                  ];
                },
                body: Consumer<SearchMovieProvider>(
                  builder: (context, model, child) {
                    if (model.stateFirstAttempt == ResultState.loading) {
                      return const LoadingShimmerMovie(isVertical: true);
                    }

                    if (model.stateFirstAttempt == ResultState.error) {
                      return Container(
                        width: double.infinity,
                        height: 250,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<SearchMovieProvider>(context,
                                        listen: false)
                                    .reload();
                              },
                              child: const Text("Reload"),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              model.detailMessageFirstAttempt,
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                      );
                    }

                    if (model.data.length == 1 &&
                        model.data[0].listMovie.isEmpty) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AssetConstant.kIconNotFound,
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 10),
                              const Text("No Result to show"),
                            ],
                          ),
                        ),
                      );
                    }

                    if (model.optionType == SearchType.withIndex &&
                        model.stateWithIndex == ResultState.loading) {
                      return const LoadingShimmerMovie(isVertical: true);
                    }

                    if (model.optionType == SearchType.withIndex &&
                        model.stateWithIndex == ResultState.error) {
                      String errorMessage = model.detailMessageWithIndex;
                      return Container(
                        width: double.infinity,
                        height: 250,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<SearchMovieProvider>(context,
                                        listen: false)
                                    .requestDataWithIndex();
                              },
                              child: const Text("Reload"),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              errorMessage,
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                      );
                    }

                    return const ResultSearchMovieListWidget();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar textSearchWidget() {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pinned: false,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      toolbarHeight:
          Responsive.size(context, small: 70, medium: 90, large: 100),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: InputSearchTextField(
          controller: _searchTextController,
          hintText: "Search",
          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }

            _debounce = Timer(const Duration(milliseconds: 500), () {
              Provider.of<SearchMovieProvider>(context, listen: false)
                  .changeQuery(value);
            });
          },
        ),
      ),
    );
  }

  SliverAppBar optionsSectionWidget() {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      pinned: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      toolbarHeight: Responsive.size(context, small: 70, medium: 80),
      title: Container(
        width: double.infinity,
        height: Responsive.size(context, small: 70, medium: 80),
        alignment: Alignment.center,
        child: const OptionsTypeSearchWidget(),
      ),
    );
  }
}
