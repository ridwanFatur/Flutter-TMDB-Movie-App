import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(String routeName, Object arguments) {
    FocusManager.instance.primaryFocus!.unfocus();
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static intent(String routeName) {
    FocusManager.instance.primaryFocus!.unfocus();
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static intentAndRemove(String routeName) {
    FocusManager.instance.primaryFocus!.unfocus();
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  static back() {
    FocusManager.instance.primaryFocus!.unfocus();
    navigatorKey.currentState?.pop();
  }

  static backToRoot() {
    FocusManager.instance.primaryFocus!.unfocus();
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  static BuildContext? getContext() => navigatorKey.currentContext;
}
