import 'package:supermarket/models/model.dart';

class CheckOutModel {
  final int id;
  final double totalAmount;
  final double totalDiscount;
  final double serviceFee;
  final double deliveryFee;
  final String totalShippingDestance;
  final double totalTax;
  final double total;
  final int currencyId;
  final bool allowCashPayment;
  final AddressModel? address;
  final List<OrderItemModel> orderItems;

  CheckOutModel({
    required this.id,
    required this.totalAmount,
    required this.totalDiscount,
    required this.serviceFee,
    required this.deliveryFee,
    required this.totalShippingDestance,
    required this.totalTax,
    required this.total,
    required this.currencyId,
    required this.allowCashPayment,
    required this.address,
    required this.orderItems,
  });

  factory CheckOutModel.fromJson(Map<String, dynamic> json) {
    return CheckOutModel(
      id: json['id'],
      totalAmount: double.parse(json['totalAmount'].toString()),
      totalDiscount: double.parse(json['totalDiscount'].toString()),
      serviceFee: double.parse(json['serviceFee']?.toString() ?? '0'),
      deliveryFee: double.parse(json['deliveryFee']?.toString() ?? '0'),
      totalShippingDestance: json['totalShippingDestance'],
      totalTax: double.parse(json['totalTax'].toString()),
      total: double.parse(json['total'].toString()),
      currencyId: json['currencyId'],
      allowCashPayment: json['allowCashPayment'],
      address: json['shipppingAddress'] != null
          ? AddressModel.fromJson(json['shipppingAddress'])
          : null,
      orderItems: List.from(json['orderItems'] ?? []).map((item) {
        return OrderItemModel.fromJson(item);
      }).toList(),
    );
  }

}
