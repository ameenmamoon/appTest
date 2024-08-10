import 'package:flutter/cupertino.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';

class BrandModel {
  late final int id;
  late final int categoryId;
  final String name;
  final String description;
  final int? count;
  final String? image;
  final String? icon;
  final Color? color;
  final bool isActive;

  BrandModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    this.count,
    this.image,
    this.icon,
    this.color,
    this.isActive = false,
  });

  @override
  bool operator ==(Object other) => other is BrandModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    final color =
        UtilColor.getColorFromHex(json['color'] ?? json['Color'] ?? "ff2b5097");
    return BrandModel(
      id: json['id'] ?? json['Id'] ?? 0,
      categoryId: json['categoryId'] ?? json['CategoryId'] ?? 0,
      name: json['name'] ?? json['Name'] ?? 'Unknown',
      description: json['description'] ?? json['Description'] ?? 'Unknown',
      count: json['count'] ?? json['Count'] ?? 0,
      image: json['image'] ?? json['Image'] ?? '',
      icon: json['icon'] ?? json['Icon'] ?? '',
      color: color,
      isActive: json['isActive'] ?? json['IsActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'count': count,
      'image': image,
      'iconUrl': icon,
      'color': color?.toHex,
      'isActive': isActive,
    };
  }
}
