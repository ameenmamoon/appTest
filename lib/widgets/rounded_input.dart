import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:supermarket/widgets/input_container.dart';

class RoundedInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Function()? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final int? maxLines;
  final bool? autofocus;
  final bool? readOnly;
  final Color? color;
  final IconData icon;
  final String hint;

  const RoundedInput(
      {Key? key,
      this.hintText,
      this.controller,
      this.focusNode,
      this.onTap,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.leading,
      this.trailing,
      this.obscureText = false,
      this.inputFormatters,
      this.keyboardType,
      this.textInputAction,
      this.errorText,
      this.maxLines = 1,
      this.autofocus = false,
      this.readOnly = false,
      this.color,
      required this.icon,
      required this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        onTap: onTap,
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: onSubmitted,
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        autofocus: autofocus ?? false,
        readOnly: readOnly ?? false,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            icon: Icon(icon, color: Theme.of(context).primaryColor),
            hintText: hint,
            suffixIcon: trailing,
            border: InputBorder.none),
      ),
    );
  }
}
