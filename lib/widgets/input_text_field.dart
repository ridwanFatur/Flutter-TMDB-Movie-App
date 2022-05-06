import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function onChanged;
  const InputTextField({
    Key? key,
    required this.controller,
    this.hintText = "Placeholder",
    required this.onChanged,
  }) : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) {
          setState(() {
            isFocus = focus;
          });
        },
        child: TextField(
          controller: widget.controller,
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.bodyText2,
          onChanged: (value) {
            widget.onChanged(value);
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
            contentPadding:
                const EdgeInsets.only(right: 10, left: 10, top: 4, bottom: 4),
          ),
        ),
      ),
    );
  }
}
