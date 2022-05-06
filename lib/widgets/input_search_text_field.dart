import 'package:flutter/material.dart';

class InputSearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function onChanged;
  const InputSearchTextField({
    Key? key,
    required this.controller,
    this.hintText = "Placeholder",
    required this.onChanged,
  }) : super(key: key);

  @override
  State<InputSearchTextField> createState() => _InputSearchTextFieldState();
}

class _InputSearchTextFieldState extends State<InputSearchTextField> {
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
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.grey),
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
            fillColor: Colors.grey.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(
              Icons.search,
              color: isFocus
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            contentPadding:
                const EdgeInsets.only(right: 0, left: 0, top: 4, bottom: 4),
          ),
        ),
      ),
    );
  }
}
