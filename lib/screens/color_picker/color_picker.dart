import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
// import 'package:workmanager/workmanager.dart';

class ColorPicker extends StatefulWidget {
  final ContactUsModel? msg;

  const ColorPicker({
    Key? key,
    this.msg,
  }) : super(key: key);

  @override
  _ColorPickerState createState() {
    return _ColorPickerState();
  }
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Color> popularColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.teal,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.cyan,
    Colors.deepOrange,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.lightBlue,
    Colors.pinkAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('اختيار الألوان'),
        ),
        body: Center(
          child: DropdownButton<Color>(
            value: popularColors[0],
            onChanged: (Color? color) {},
            items: popularColors.map((Color color) {
              return DropdownMenuItem<Color>(
                value: color,
                child: Container(
                  color: color,
                  height: 40,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
