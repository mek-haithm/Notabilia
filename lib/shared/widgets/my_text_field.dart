import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData? icon;
  final Color? color;
  final bool readOnly;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.icon,
    this.color,
    this.readOnly = false,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  TextDirection _textDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
    _handleTextChange();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    setState(() {
      _textDirection = _detectTextDirection(widget.controller.text);
    });
  }

  TextDirection _detectTextDirection(String text) {
    if (text.isEmpty) {
      return TextDirection.ltr;
    }
    final firstChar = text.codeUnitAt(0);
    if (firstChar >= 0x600 && firstChar <= 0x6FF) {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      cursorColor: kMainColor,
      controller: widget.controller,
      style: kSmallTextStyle(context),
      textDirection: _textDirection,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.color ?? kCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: "ibmFont",
        ),
        suffixIcon: widget.icon != null ? Icon(
          widget.icon,
          color: kMainColor,
        ) : null,
      ),
    );
  }
}
