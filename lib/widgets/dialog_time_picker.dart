import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogDatePicker extends StatefulWidget {
  const DialogDatePicker({
    Key? key,
    required this.initialTime,
    required this.title,
  }) : super(key: key);

  final DateTime initialTime;
  final String title;

  @override
  _DialogDatePickerState createState() => _DialogDatePickerState();
}

class _DialogDatePickerState extends State<DialogDatePicker> {
  DateTime? tempTime;

  @override
  void initState() {
    super.initState();
    tempTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
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
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(
                    widget.initialTime.year,
                    widget.initialTime.month,
                    widget.initialTime.day,
                  ),
                  onDateTimeChanged: (value) {
                    setState(() {
                      tempTime = value;
                    });
                  },
                  use24hFormat: true,
                  minuteInterval: 1,
                ),
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
                        Navigator.pop(context, tempTime);
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
}
