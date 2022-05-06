import 'package:flutter/material.dart';

extension TimeExtension on TimeOfDay {
  int toMinute() {
    return hour * 60 + minute;
  }
}
