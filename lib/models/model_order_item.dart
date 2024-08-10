import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';

class OrderItemModel {
  final int id;
  late int? oId = 0;
  final int orderId;
  final int? productId;
  final int? promotionId;
  final String? promotionName;
  final String name;
  final String? image;
  late double price;
  late double? discount = 0;
  late double total;
  late int quantity;
  late double quantityAvailable;
  final double unitPrice;
  late int? unitId;
  late String? unitName;
  final String? createdOn;
  final List<ProductUnitModel>? productUnits;
  // final ShippingOrderItemModel? itemShipping;

  OrderItemModel({
    required this.id,
    this.oId,
    required this.orderId,
    this.productId,
    this.promotionId,
    this.promotionName,
    required this.name,
    this.image,
    required this.price,
    this.discount,
    required this.total,
    required this.quantity,
    required this.quantityAvailable,
    required this.unitPrice,
    this.unitId,
    this.unitName,
    this.createdOn,
    this.productUnits,
    // this.itemShipping,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    OrderStatus status = OrderStatus.waiting;

    if (json['status'] != null) {
      status = OrderStatus.values[int.parse(json['status'].toString())];
    }

    return OrderItemModel(
      id: json['id'],
      oId: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
      promotionId: json['promotionId'],
      promotionName: json['promotionName'] ?? '',
      name: json['productName'] ?? json['promotionName'] ?? '',
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 0,
      quantityAvailable: json['quantityAvailable'] ?? 0.0,
      unitPrice: json['unitPrice'] != null
          ? double.parse(json['unitPrice'].toString())
          : 0,
      unitName: json['unitName'] ?? '',
      unitId: int.parse(json['unitId']?.toString() ?? '0'),
      total: double.parse(json['total']?.toString() ?? '0'),
      price: double.parse(json['price']?.toString() ?? '0'),
      discount: double.parse(json['discount']?.toString() ?? '0'),
      // createdOn: json['createdOn'] ?? '',
      // itemShipping: json['itemShipping'] != null
      //     ? ShippingOrderItemModel.fromJson(json['itemShipping'])
      //     : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": oId ?? 0,
      "orderId": orderId,
      "productId": productId,
      "productCode": "",
      "productName": "ss",
      "promotionId": promotionId,
      "promotionName": promotionName,
      "unitId": unitId ?? 0,
      "unitQty": 0,
      "unitName": "string",
      "quantity": quantity,
      "quantityAvailable": quantityAvailable,
      "price": price,
      "total": total,
      "discount": 0,
      "isDetails": false,
    };
  }
}
