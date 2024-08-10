import 'package:supermarket/models/model.dart';
import '../configs/application.dart';

enum ProductStatus {
  publish,
  draft,
  pending,
  sold,
  incomplete,
  deleted,
}

class ProductModel {
  final int id;
  final String name;
  final String content;
  late String image;
  late int categoryId;
  late String categoryName;
  final double rate;
  final num numRate;
  final String rateText;
  late ProductStatus status;
  final String statusText;
  final String? statusNote;
  late String? statusColor;
  bool isAddedFavorite;
  bool isAddedCart;
  final String price;
  final UserModel? createdBy;
  final List<ProductModel> related;
  final List<ProductModel> latest;
  final String? baracode;
  final bool hasDiscount;
  final double? discount;
  final List<ProductUnitModel> productUnits;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
    required this.categoryName,
    required this.rate,
    required this.numRate,
    required this.rateText,
    required this.status,
    required this.statusText,
    this.statusNote,
    this.statusColor,
    required this.isAddedFavorite,
    required this.isAddedCart,
    required this.content,
    required this.price,
    this.createdBy,
    required this.related,
    required this.latest,
    this.baracode,
    this.hasDiscount = false,
    this.discount,
    required this.productUnits,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    UserModel? createdBy;
    ProductStatus status = ProductStatus.publish;
    String statusText = '';
    if (json['createdBy'] != null) {
      createdBy = UserModel.fromJson(json['createdBy']);
    }

    final listRelated = List.from(json['related'] ?? []).map((item) {
      return ProductModel.fromJson(item);
    }).toList();

    final listLatest = List.from(json['lastest'] ?? []).map((item) {
      return ProductModel.fromJson(item);
    }).toList();

    return ProductModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      image: (json['imageDataURL'] != null &&
              !json['imageDataURL'].toString().startsWith(Application.domain))
          ? "${Application.domain}${json['imageDataURL'].toString().replaceAll("\\", "/")}"
          : '',
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      rate: double.tryParse('${json['rate']}') ?? 0.0,
      numRate: json['numRate'] ?? 0,
      rateText: json['product_status'] ?? '',
      status: status,
      statusText: statusText,
      statusNote: json['statusNote'],
      statusColor: json['statusColor'],
      isAddedFavorite: json['favorite'] == true,
      isAddedCart: json['isAddedCart'] == true,
      content: json['content'] ?? '',
      price: json['price']?.toString() ?? '',
      createdBy: createdBy,
      related: listRelated,
      latest: listLatest,
      baracode: json['baracode'],
      hasDiscount: json['hasDiscount'] ?? false,
      discount: json['discount'] != null
          ? double.tryParse(json['discount'].toString())
          : null,
      productUnits: List.from(json['productUnits'] ?? []).map((item) {
        return ProductUnitModel.fromJson(item);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "categoryId": categoryId,
      "categoryName": categoryName,
      "name": name,
      "image": image
    };
  }

  Map<String, Object?> getProperties() {
    Map<String, Object?> result = <String, Object?>{};
    return result;
  }
}
