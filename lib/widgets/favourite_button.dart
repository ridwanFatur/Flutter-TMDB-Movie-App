import 'package:flutter/material.dart';

class FavouriteButton extends StatefulWidget {
  final VoidCallback onPress;
  final bool isFavorite;
  const FavouriteButton(
      {Key? key, required this.onPress, required this.isFavorite})
      : super(key: key);

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    animation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 35, end: 40)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 40, end: 35)
              .chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
      ],
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.reset();
            controller.forward();
            widget.onPress();
          },
          splashFactory: InkRipple.splashFactory,
          child: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
            size: animation.value,
          ),
        ),
      ),
    );
  }
}
