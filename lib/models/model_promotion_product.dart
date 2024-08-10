import 'package:supermarket/models/model.dart';

class PromotionProductModel {
  late final int promotionsId;
  final int productId;
  final String productName;
  final int unitId;
  final String unitName;
  final String? description;
  late String? image;
  late double price;
  late double priceAfterDiscount;

  PromotionProductModel({
    required this.promotionsId,
    required this.productId,
    required this.productName,
    required this.unitId,
    required this.unitName,
    this.description,
    required this.image,
    required this.price,
    required this.priceAfterDiscount,
  });

  @override
  bool operator ==(Object other) =>
      other is CategoryModel && promotionsId == other.id;

  @override
  int get hashCode => promotionsId.hashCode;

  factory PromotionProductModel.fromJson(Map<String, dynamic> json) {
    return PromotionProductModel(
      promotionsId: json['promotionsId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      unitId: json['unitId'] ?? 0,
      unitName: json['unitName'] ?? '',
      description: json['description'] ?? '',
      image: json['imageDataURL'] ?? '',
      price: double.tryParse('${json['price']}') ?? 0.0,
      priceAfterDiscount:
          double.tryParse('${json['priceAfterDiscount']}') ?? 0.0,
    );
  }
}
