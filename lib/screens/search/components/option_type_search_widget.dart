import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/math_helper.dart';
import 'package:tmdb_movie_app/core/utils/size_responsive_helper.dart';
import 'package:tmdb_movie_app/core/utils/state_enum.dart';
import 'package:tmdb_movie_app/providers/search_movie_provider.dart';
import 'package:provider/provider.dart';

class OptionsTypeSearchWidget extends StatefulWidget {
  const OptionsTypeSearchWidget({Key? key}) : super(key: key);

  @override
  State<OptionsTypeSearchWidget> createState() =>
      _OptionsTypeSearchWidgetState();
}

class _OptionsTypeSearchWidgetState extends State<OptionsTypeSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchMovieProvider>(builder: (context, model, child) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[350],
          borderRadius: BorderRadius.circular(
            25.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            itemOptionType(
              model.optionType == SearchType.lazyLoading,
              "Lazy Loading",
              () {
                Provider.of<SearchMovieProvider>(context, listen: false)
                    .changeOptionType(SearchType.lazyLoading);
              },
            ),
            itemOptionType(
              model.optionType == SearchType.withIndex,
              "With Index",
              () {
                int? selectedPage;
                double minY = double.infinity;
                if (model.data.isNotEmpty) {
                  try {
                    for (var item in model.data) {
                      GlobalKey key = item.keyWidget;
                      int page = item.pageNumber;
                      RenderBox box =
                          key.currentContext!.findRenderObject() as RenderBox;
                      Offset position = box.localToGlobal(Offset.zero);
                      double y = position.dy;

                      double centerVal = MathHelper.getCenterVal(
                        y,
                        Responsive.size(context, small: 1800),
                      );
                      if (centerVal < minY) {
                        minY = centerVal;
                        selectedPage = page;
                      }
                    }
                  } catch (e) {
                    selectedPage = null;
                  }
                }
                Provider.of<SearchMovieProvider>(context, listen: false)
                    .changeOptionType(
                  SearchType.withIndex,
                  selectedPage: selectedPage,
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget itemOptionType(bool isActive, String title, VoidCallback onPressed) {
    return Expanded(
      child: Material(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: () {
            onPressed();
          },
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
