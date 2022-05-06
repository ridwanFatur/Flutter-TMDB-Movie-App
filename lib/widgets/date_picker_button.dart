import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_movie_app/controller/date_time_editing_controller.dart';
import 'package:tmdb_movie_app/widgets/dialog_time_picker.dart';

class DatePickerButton extends StatefulWidget {
  final DateTimeEditingController controller;
  const DatePickerButton({Key? key, required this.controller})
      : super(key: key);
  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: () async {
          DateTime? dateTime = await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: DialogDatePicker(
                  title: "Select Birth Date",
                  initialTime: widget.controller.dateTime != null
                      ? widget.controller.dateTime!
                      : DateTime.now(),
                ),
              );
            },
          );

          if (dateTime != null) {
            widget.controller.setDateTime(dateTime);
            setState(() {});
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Icon(
                  Icons.date_range,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: textDateTime(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textDateTime() {
    String dateTimeString = "";
    if (widget.controller.dateTime == null) {
      dateTimeString = "(Empty Date)";
    } else {
      dateTimeString =
          DateFormat("dd-MMM-yyyy").format(widget.controller.dateTime!);
    }

    return Text(
      dateTimeString,
      style: Theme.of(context).textTheme.caption,
    );
  }
}
