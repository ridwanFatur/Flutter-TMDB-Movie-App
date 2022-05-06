import 'package:flutter/material.dart';

class OptionMenu extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const OptionMenu({Key? key, 
    required this.onPressed,
    required this.icon,
  }) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
