import 'package:supermarket/models/model.dart';

enum PaymentType { cash, creditCard, paypal }

enum OrderType { cart, order }

// enum OrderStatus {
//   cart,
//   order,
//   awaitingApproval,
//   outStock,
//   progress,
//   onShipping,
//   finished,
//   returned,
//   canceled,
// }

enum OrderStatus {
  waiting,
  available,
  notAvailable,
  partialAvailable,
  toDelivery,
  deliveried,
}

class OrderModel {
  final int orderId;
  late AddressType addressType;
  final OrderStatus status;
  late PaymentType paymentMethod;
  late bool? isPaid = false;
  late String? street = '';
  final String? userName;
  late String latitude;
  late String longitude;
  final double amount;
  final double discount;
  final double total;
  final String? deliveryCode;
  late List<OrderItemModel> orderItems;

  OrderModel({
    required this.orderId,
    required this.addressType,
    this.street,
    required this.status,
    required this.paymentMethod,
    this.isPaid,
    this.userName,
    required this.amount,
    required this.discount,
    required this.total,
    required this.latitude,
    required this.longitude,
    this.deliveryCode,
    required this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    AddressType addressT = AddressType.home;
    OrderStatus status = OrderStatus.waiting;
    PaymentType payment = PaymentType.creditCard;
    if (json['addressType'] != null) {
      addressT =
          AddressType.values[int.parse(json['addressType'].toString()) - 1];
    }
    if (json['orderStatus'] != null) {
      status = OrderStatus.values[int.parse(json['orderStatus'].toString())];
    }
    if (json['payment'] != null) {
      payment = PaymentType.values[int.parse(json['payment'].toString()) - 1];
    }
    return OrderModel(
      orderId: json['id'],
      addressType: addressT,
      userName: json['userName'] ?? '',
      street: json['street'] ?? '',
      status: status,
      paymentMethod: payment,
      isPaid: json['isPaid'] ?? false,
      amount: double.parse(json['amount']?.toString() ?? '0'),
      discount: double.parse(json['discount']?.toString() ?? '0'),
      total: double.parse(json['total']?.toString() ?? '0'),
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      deliveryCode: json['deliveryCode'],
      orderItems: List.from(json['orderItems'] ?? json['orderDetails'] ?? [])
          .map((item) {
        return OrderItemModel.fromJson(item);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    latitude = latitude.isEmpty ? "24.770966" : latitude;
    longitude = longitude.isEmpty ? "46.07584" : longitude;
    // طباعة القيم للتحقق منها
    print('customerLat: $latitude, customerLong: $longitude');

    return {
      "id": orderId,
      "addressType": addressType.index,
      "street": street ?? "Not provided",
      "paymentMethod": paymentMethod.index,
      "amount": amount,
      "discount": discount,
      "total": total,
      "customerLat": latitude.isEmpty ? "24.770966" : latitude,
      "customerLong": longitude.isEmpty ? "46.07584" : longitude,
      "orderItems": orderItems.map((e) => e.toJson()).toList(),
    };
  }
}
