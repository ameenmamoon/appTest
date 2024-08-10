import 'package:supermarket/models/model.dart';

class ProductUnitModel {
  final int id;
  final int productId;
  final int unitId;
  final String name;
  final double price;
  final int quantity;
  final double priceAfterDiscount;
  final bool isSelected;

  ProductUnitModel({
    required this.id,
    required this.productId,
    required this.unitId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.priceAfterDiscount,
    required this.isSelected,
  });

  factory ProductUnitModel.fromJson(Map<String, dynamic> json,
      {SettingModel? setting}) {
    return ProductUnitModel(
        id: int.tryParse(json['unitId'].toString()) ?? 0,
        productId: int.tryParse(json['productId'].toString()) ?? 0,
        unitId: int.tryParse(json['unitId'].toString()) ?? 0,
        name: json['unitName'] ?? '',
        price: double.tryParse(json['price'].toString()) ?? 0,
        quantity: int.tryParse(json['quantity'].toString()) ?? 0,
        priceAfterDiscount:
            double.tryParse(json['priceAfterDiscount'].toString()) ?? 0,
        isSelected: false);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": unitId,
      "productId": productId,
      "unitId": unitId,
      "unitName": name,
      "price": price,
      "quantity": quantity,
      "priceAfterDiscount": priceAfterDiscount
    };
  }
}
