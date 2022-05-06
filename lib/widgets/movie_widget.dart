import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/asset_constants.dart';
import 'package:tmdb_movie_app/core/utils/navigation.dart';
import 'package:tmdb_movie_app/core/utils/routes.dart';
import 'package:tmdb_movie_app/models/movie.dart';

class MovieWidget extends StatelessWidget {
  final Movie movie;
  final bool isGridView;
  final String tag;
  final bool isVertical;
  const MovieWidget({
    Key? key,
    required this.movie,
    this.isGridView = false,
    this.tag = "",
    this.isVertical = false,
  }) : super(key: key);

  Widget verticalWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          color: Theme.of(context).colorScheme.secondary,
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Hero(
                      tag: "${movie.id}$tag",
                      child: movie.posterImageUrlSmall != null
                          ? Image.network(
                              movie.posterImageUrlSmall!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, exception, stackTrace) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Image.asset(
                                    AssetConstant.kDefaultImage,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            )
                          : SizedBox(
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
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                movie.title ?? "",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                movie.releaseDateFormatted ?? "",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                movie.voteAverageString ?? "",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.overline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigation.intentWithData(detailMovieRoute, movie);
                    },
                    splashColor: Colors.lightBlueAccent.withOpacity(0.2),
                    splashFactory: InkRipple.splashFactory,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return verticalWidget(context);
    } else {
      double widthDevice = MediaQuery.of(context).size.width;
      double height = isGridView ? (5 / 3) * (widthDevice - 2 * 10) / 2 : 290;

      return SizedBox(
        width: isGridView ? double.infinity : 180,
        height: isGridView ? double.infinity : 290,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      child: Hero(
                        tag: "${movie.id}$tag",
                        child: movie.posterImageUrlSmall != null
                            ? Image.network(
                                movie.posterImageUrlSmall!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, exception, stackTrace) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.asset(
                                      AssetConstant.kDefaultImage,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              )
                            : SizedBox(
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
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 23, bottom: 8, left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              movie.title ?? "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              movie.releaseDateFormatted ?? "",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.overline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigation.intentWithData(detailMovieRoute, movie);
                    },
                    splashColor: Colors.lightBlueAccent.withOpacity(0.2),
                    splashFactory: InkRipple.splashFactory,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: (8 / 13) * height,
                child: Material(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blueGrey
                      : Colors.black,
                  shape: const CircleBorder(),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      movie.voteAverageString ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
