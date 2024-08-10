import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.action,
    this.loading = false,
  }) : super(key: key);

  final String title;
  final Function() action;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
