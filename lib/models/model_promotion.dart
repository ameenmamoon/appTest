import 'package:supermarket/models/model.dart';

class PromotionModel {
  late final int id;
  final String name;
  final String description;
  late String? image;
  late double price;
  late double priceAfterDiscount;
  late String startDate;
  late String endDate;
  late List<PromotionProductModel>? products;

  PromotionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.priceAfterDiscount,
    required this.startDate,
    required this.endDate,
    this.products,
  });

  @override
  bool operator ==(Object other) => other is CategoryModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['Name'] ?? '',
      description: json['description'] ?? '',
      image: json['imageDataURL'] ?? '',
      price: double.tryParse('${json['price']}') ?? 0.0,
      priceAfterDiscount:
          double.tryParse('${json['priceAfterDiscount']}') ?? 0.0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      products: List.from(json['promotionProducts'] ?? []).map((item) {
        return PromotionProductModel.fromJson(item);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'priceAfterDiscount': priceAfterDiscount,
      'startDate': startDate,
      'endDate': endDate,
      'promotionsProducts': products,
    };
  }
}
