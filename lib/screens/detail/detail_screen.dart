import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/asset_constants.dart';
import 'package:tmdb_movie_app/core/utils/state_enum.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:tmdb_movie_app/providers/detail_movie_provider.dart';
import 'package:tmdb_movie_app/providers/favorite_movie_provider.dart';
import 'package:tmdb_movie_app/providers/rate_movie_provider.dart';
import 'package:tmdb_movie_app/widgets/favourite_button.dart';
import 'package:tmdb_movie_app/widgets/image_network_with_original_ratio.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailMovieProvider>(
          create: (context) => DetailMovieProvider(movie: widget.movie),
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.movie.posterImageUrl != null
                  ? ImageNetworkWithOriginalRatio(
                      url: widget.movie.posterImageUrl!,
                      tagHero: widget.movie.id,
                    )
                  : AspectRatio(
                      aspectRatio: 1,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          AssetConstant.kDefaultImage,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Consumer<DetailMovieProvider>(
                        builder: (context, model, child) {
                      return Expanded(
                        child: model.state == ResultState.loading
                            ? shimmerLoadingText(40)
                            : Text(
                                "${widget.movie.title ?? ''} (${widget.movie.releaseDateYear ?? ''})",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                      );
                    }),
                    const SizedBox(width: 15),
                    Consumer<FavoriteMovieProvider>(
                        builder: (context, model, child) {
                      return FavouriteButton(
                        onPress: () {
                          Provider.of<FavoriteMovieProvider>(context,
                                  listen: false)
                              .toggleFavoriteMovie(widget.movie);
                        },
                        isFavorite: model.isFavoriteById(widget.movie.id),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Consumer<DetailMovieProvider>(
                    builder: (context, model, child) {
                  return model.state == ResultState.loading
                      ? shimmerLoadingText(20)
                      : Text(
                          "Release Date: ${widget.movie.releaseDateFormatted ?? ''}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
                        );
                }),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Consumer<DetailMovieProvider>(
                    builder: (context, model, child) {
                  return model.state == ResultState.loading
                      ? shimmerLoadingText(20)
                      : Text(
                          "User Score: ${widget.movie.voteAverageString ?? ''}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
                        );
                }),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Overview",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Consumer<DetailMovieProvider>(
                    builder: (context, model, child) {
                  return model.state == ResultState.loading
                      ? shimmerLoadingText(80)
                      : Text(
                          widget.movie.overview ?? "",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.justify,
                        );
                }),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.primary,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    splashFactory: InkRipple.splashFactory,
                    onTap: () async {
                      Provider.of<RateMovieProvider>(context, listen: false)
                          .rateMovie(
                              context: context, movieId: widget.movie.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 15),
                      width: double.infinity,
                      child: Text(
                        "Rate Movie",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget shimmerLoadingText(double height) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.blueGrey
            : Colors.grey[300]!,
        highlightColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey
            : Colors.grey[100]!,
        direction: ShimmerDirection.ltr,
        child: const Material(),
      ),
    );
  }
}
