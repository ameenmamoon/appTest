import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';

enum ListViewType { withIcons, withImages }

class CategoryModel {
  late final int id;
  final String name;
  final String description;
  final int? count;
  late String? image;
  final IconData? icon;
  final String? iconUrl;
  final Color? color;
  final ListViewType listViewType;
  final List<ExtendedAttributeModel>? extendedAttributes;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.count,
    this.image,
    this.icon,
    this.iconUrl,
    this.color,
    this.listViewType = ListViewType.withIcons,
    this.extendedAttributes,
  });

  @override
  bool operator ==(Object other) => other is CategoryModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<Color> availableColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.indigo,
    ];
    List<String> availableIconUrls = [
      'fruits.png',
      'healthy-food.png',
      'healthy-food2.png',
      'broccoli.png',
    ];
    Random random = Random();
    int index = random.nextInt(availableColors.length);
    int indexIcons = random.nextInt(availableIconUrls.length);

    List<ExtendedAttributeModel>? extendedAttributes = [];
    if (json['extendedAttributes'] != null ||
        json['ExtendedAttributes'] != null) {
      extendedAttributes = List.from(
              json['extendedAttributes'] ?? json['ExtendedAttributes'] ?? [])
          .map((item) {
        return ExtendedAttributeModel.fromJson(item);
      }).toList();
    }
    ListViewType listViewType = ListViewType.values[int.parse(
        (json['listViewType'] ?? json['ListViewType']) == null
            ? "0"
            : json['listViewType']?.toString() ??
                json['ListViewType'].toString())];
    final color = (json['color'] == null || json['color'] == '')
        ? availableColors[index]
        : UtilColor.getColorFromHex(
            json['color'] ?? json['Color'] ?? "ff2b5097");
    final iconUrl = (json['icon'] == null || json['icon'] == '')
        ? availableIconUrls[indexIcons]
        : '';
    final icon =
        UtilIcon.getIconFromCss(json['icon'] ?? 'solid magnifying-glass-minus');

    return CategoryModel(
      id: json['id'] ?? json['Id'] ?? 0,
      name: json['name'] ?? json['Name'] ?? '',
      description: json['description'] ?? json['Description'] ?? '',
      count: json['count'] ?? json['Count'] ?? 0,
      image: json['imageDataURL'] ?? '',
      icon: icon,
      iconUrl: iconUrl,
      color: color,
      listViewType: listViewType,
      extendedAttributes: extendedAttributes,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'image': image,
      'iconUrl': iconUrl,
      'color': color?.toHex,
      'listViewType': listViewType.index,
      'extendedAttributes': extendedAttributes?.map((e) => e.toJson()).toList(),
    };
  }
}
