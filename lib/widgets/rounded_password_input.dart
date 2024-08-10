import 'package:flutter/material.dart';

import 'package:supermarket/widgets/input_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({Key? key, required this.hint}) : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
      cursorColor: Theme.of(context).primaryColor,
      obscureText: true,
      decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
          hintText: hint,
          border: InputBorder.none),
    ));
  }
}
