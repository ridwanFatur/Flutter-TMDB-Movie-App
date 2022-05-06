import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmerMovie extends StatelessWidget {
  final bool isGridView;
  final bool isVertical;
  const LoadingShimmerMovie(
      {Key? key, this.isGridView = false, this.isVertical = false})
      : super(key: key);

  Widget singleLoading(BuildContext context) {
    return SizedBox(
      width: isGridView ? double.infinity : 180,
      height: isGridView ? double.infinity : 250,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
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
        ),
      ),
    );
  }

  Widget singleLoadingVertical(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          height: 200,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return ListView(
        children: List.generate(6, (index) {
          return singleLoadingVertical(context);
        }),
      );
    } else {
      if (!isGridView) {
        return SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              return singleLoading(context);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 20);
            },
            itemCount: 3,
          ),
        );
      } else {
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 4,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return singleLoading(context);
          },
        );
      }
    }
  }
}
