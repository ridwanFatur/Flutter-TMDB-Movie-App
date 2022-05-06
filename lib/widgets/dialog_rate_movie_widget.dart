import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tmdb_movie_app/core/utils/asset_constants.dart';

Future<int?> showDialogRateMovie(BuildContext context) async {
  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: const DialogRateMovieWidget(),
      );
    },
  );
}

class DialogRateMovieWidget extends StatefulWidget {
  const DialogRateMovieWidget({
    Key? key,
  }) : super(key: key);

  @override
  _DialogRateMovieWidget createState() => _DialogRateMovieWidget();
}

class _DialogRateMovieWidget extends State<DialogRateMovieWidget> {
  int rateMovie = 0;

  List<Widget> ratingStarWidget() {
    List<Widget> ratingStarWidgetList = [];
    for (int i = 1; i <= 5; i++) {
      if (rateMovie < i) {
        ratingStarWidgetList.add(
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              onTap: () {
                setState(() {
                  rateMovie = i;
                });
              },
              child: SvgPicture.asset(
                AssetConstant.kIconRatingStartNotFilled,
              ),
            ),
          ),
        );
      } else {
        ratingStarWidgetList.add(
          Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              onTap: () {
                setState(() {
                  rateMovie = i;
                });
              },
              child: SvgPicture.asset(
                AssetConstant.kIconRatingStartFilled,
              ),
            ),
          ),
        );
      }
    }
    return ratingStarWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: rateMovieText(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ratingStarWidget(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, rateMovie * 2);
                      },
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> rateMovieText() {
    return [
      Text(
        "Rate Movie",
        style: Theme.of(context).textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    ];
  }
}
