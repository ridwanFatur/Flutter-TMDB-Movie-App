import 'package:flutter/material.dart';

class Responsive {
  static double size(
    BuildContext context, {
    required double small,
    double? medium,
    double? large,
  }) {
    double width = MediaQuery.of(context).size.width;
    if (width < 480) {
      return small;
    } else if (width < 600) {
      return medium ?? small;
    } else {
      return large ?? medium ?? small;
    }
  }
}
