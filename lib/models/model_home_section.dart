import 'package:flutter/material.dart';

import '../configs/application.dart';
import '../configs/image.dart';
import 'model.dart';

enum HomeSectionType {
  offerCategory,
  offerCategory2,
  offerDiscount,
  slider,
  categoryMenu,
  categoryMenu2,
  featuredSellers,
  image,
  ads,
  slider2,
  video,
  sectionSmallCarousel,
  sectionOffer,
}

class HomeSectionModel {
  final int id;
  final HomeSectionType sectionType;
  final String lang;
  final int? categoryId;
  final String? image;
  final String title;
  final String? description;
  final String? icon;
  final String? color;
  final bool isActive;
  final int priority;
  late List<ExtendedAttributeModel>? extendedAttributes;

  HomeSectionModel({
    required this.id,
    required this.sectionType,
    required this.lang,
    this.categoryId,
    required this.image,
    required this.title,
    this.description,
    this.icon,
    this.color,
    this.isActive = false,
    required this.priority,
    this.extendedAttributes,
  });

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) {
    List<ExtendedAttributeModel>? extendedAttributes = [];
    var sectionType = HomeSectionType.offerCategory;
    if (json['sectionType'] != null) {
      sectionType =
          HomeSectionType.values[int.parse(json['sectionType'].toString())];
    }
    if (json['extendedAttributes'] != null) {
      extendedAttributes =
          List.from(json['extendedAttributes'] ?? []).map((item) {
        return ExtendedAttributeModel.fromJson(item);
      }).toList();
    }
    return HomeSectionModel(
      id: json['id'] ?? 0,
      sectionType: sectionType,
      lang: json['lang'],
      categoryId: json['categoryId'],
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      icon: json['icon'],
      color: json['color'],
      isActive: json['isActive'],
      priority: json['priority'],
      extendedAttributes: extendedAttributes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sectionType': sectionType.index,
      'lang': lang,
      'categoryId': categoryId,
      'image': image,
      'title': title,
      'description': description,
      'color': color,
      'isActive': isActive,
      'priority': priority,
      'extendedAttributes': extendedAttributes?.map((e) => e.toJson()).toList(),
      // 'refreshToken': refreshToken,
    };
  }
}
