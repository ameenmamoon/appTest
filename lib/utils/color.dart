import 'package:flutter/material.dart';

class UtilColor {
  static final List<Map<String, dynamic>> popularColors = [
    {'name': 'white', 'value': Colors.white},
    {'name': 'black', 'value': Colors.black},
    {'name': 'red', 'value': Colors.red},
    {'name': 'blue', 'value': Colors.blue},
    {'name': 'green', 'value': Colors.green},
    {'name': 'yellow', 'value': Colors.yellow},
    {'name': 'orange', 'value': Colors.orange},
    {'name': 'purple', 'value': Colors.purple},
    {'name': 'pink', 'value': Colors.pink},
    {'name': 'brown', 'value': Colors.brown},
    {'name': 'grey', 'value': Colors.grey},
    {'name': 'teal', 'value': Colors.teal},
    {'name': 'indigo', 'value': Colors.indigo},
    {'name': 'amber', 'value': Colors.amber},
    {'name': 'cyan', 'value': Colors.cyan},
    {'name': 'deepOrange', 'value': Colors.deepOrange},
    {'name': 'lightGreen', 'value': Colors.lightGreen},
    {'name': 'deepPurple', 'value': Colors.deepPurple},
    {'name': 'blueGrey', 'value': Colors.blueGrey},
    {'name': 'lightBlue', 'value': Colors.lightBlue},
    {'name': 'pinkAccent', 'value': Colors.pinkAccent},
    // Colors.red,
    // Colors.blue,
    // Colors.green,
    // Colors.yellow,
    // Colors.orange,
    // Colors.purple,
    // Colors.pink,
    // Colors.brown,
    // Colors.grey,
    // Colors.teal,
    // Colors.indigo,
    // Colors.lime,
    // Colors.amber,
    // Colors.cyan,
    // Colors.deepOrange,
    // Colors.lightGreen,
    // Colors.deepPurple,
    // Colors.blueGrey,
    // Colors.lightBlue,
    // Colors.pinkAccent,
  ];

  static Color getColorFromHex(String? hexColor) {
    if (hexColor != null) {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      if (hexColor.length == 7) {
        hexColor = "FF$hexColor";
      }
      return Color(int.tryParse(hexColor, radix: 16) ?? 255);
    }
    return Colors.black;
  }

  ///Singleton factory
  static final UtilColor _instance = UtilColor._internal();

  factory UtilColor() {
    return _instance;
  }

  UtilColor._internal();
}

extension ColorToHex on Color {
  String get toHex {
    return value.toRadixString(16);
  }
}
