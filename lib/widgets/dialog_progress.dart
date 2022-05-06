import 'package:flutter/material.dart';

Future showDialogProgress(BuildContext context, Function function) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: DialogProgress(function: function));
    },
  );
}

class DialogProgress extends StatefulWidget {
  const DialogProgress({Key? key, required this.function}) : super(key: key);
  final Function function;

  @override
  State<DialogProgress> createState() => _DialogProgressState();
}

class _DialogProgressState extends State<DialogProgress> {
  @override
  void initState() {
    super.initState();
    widget.function(context);
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
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: listWidget(),
            )),
      ),
    );
  }

  List<Widget> listWidget() {
    return [
      const CircularProgressIndicator(),
      const SizedBox(height: 15),
      const Text("Loading")
    ];
  }
}
