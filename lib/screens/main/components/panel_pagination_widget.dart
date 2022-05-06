import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/providers/search_movie_provider.dart';
import 'package:provider/provider.dart';

class PanelPaginationWidget extends StatefulWidget {
  const PanelPaginationWidget({Key? key}) : super(key: key);

  @override
  State<PanelPaginationWidget> createState() => _PanelPaginationWidgetState();
}

class _PanelPaginationWidgetState extends State<PanelPaginationWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<double> animationRotate;
  late bool openPanel;

  @override
  void initState() {
    super.initState();
    openPanel = false;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationRotate =
        Tween<double>(begin: 0, end: pi / 2).animate(animationController);
    setTogglePagination();
  }

  void setTogglePagination() async {
    await Future.delayed(const Duration(seconds: 0));
    Provider.of<SearchMovieProvider>(context, listen: false)
        .setTogglePagination(setOpen: setOpen, setClose: setClose);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void setOpen() {
    if (!openPanel) {
      animationController.forward();
      openPanel = true;
      setState(() {});
    }
  }

  void setClose() {
    if (openPanel) {
      animationController.reverse();
      openPanel = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchMovieProvider>(
      builder: (context, model, child) {
        return Material(
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            axis: Axis.vertical,
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardPagination(
                    "1",
                    onPressed: () {
                      Provider.of<SearchMovieProvider>(context, listen: false)
                          .changeShowedPageNumber(1);
                    },
                    isShowed: model.showedPageNumber - 2 >= 1,
                  ),
                  cardPagination(
                    "...",
                    isShowed: model.showedPageNumber - 2 > 1,
                  ),
                  cardPagination(
                    "${model.showedPageNumber - 1}",
                    onPressed: () {
                      Provider.of<SearchMovieProvider>(context, listen: false)
                          .changeShowedPageNumber(model.showedPageNumber - 1);
                    },
                    isShowed: model.showedPageNumber > 1,
                  ),
                  cardPagination(
                    "${model.showedPageNumber}",
                    isShowed: true,
                    isCurrentPage: true,
                  ),
                  cardPagination(
                    "${model.showedPageNumber + 1}",
                    onPressed: () {
                      Provider.of<SearchMovieProvider>(context, listen: false)
                          .changeShowedPageNumber(model.showedPageNumber + 1);
                    },
                    isShowed: model.showedPageNumber + 1 < model.totalPage,
                  ),
                  cardPagination(
                    "...",
                    isShowed: model.showedPageNumber + 2 < model.totalPage,
                  ),
                  cardPagination(
                    "${model.totalPage}",
                    onPressed: () {
                      Provider.of<SearchMovieProvider>(context, listen: false)
                          .changeShowedPageNumber(model.totalPage);
                    },
                    isShowed: model.showedPageNumber != model.totalPage &&
                        model.totalPage != 0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget cardPagination(String caption,
      {VoidCallback? onPressed, required bool isShowed, bool? isCurrentPage}) {
    if (isShowed) {
      double cardSize = (MediaQuery.of(context).size.width - 80) / 7;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: cardSize,
        color: isCurrentPage != null
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        constraints: const BoxConstraints(
          minHeight: 50,
        ),
        child: InkWell(
          onTap: onPressed,
          splashFactory: InkRipple.splashFactory,
          child: Center(
            child: Text(
              caption,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: isCurrentPage != null
                        ? Colors.white
                        : Theme.of(context).scaffoldBackgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
