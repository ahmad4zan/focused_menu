import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Widget? trailingIcon;
  Widget? leadingIcon;
  Function onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
      required this.title,
      this.leadingIcon,
      this.trailingIcon,
      required this.onPressed});
}
