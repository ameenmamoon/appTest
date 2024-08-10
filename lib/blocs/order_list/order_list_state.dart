import 'package:supermarket/models/model.dart';

abstract class OrderListState {}

class OrderListLoading extends OrderListState {}

class OrderListSuccess extends OrderListState {
  final List<OrderModel> list;
  final bool canLoadMore;
  final bool loadingMore;

  OrderListSuccess({
    required this.list,
    required this.canLoadMore,
    this.loadingMore = false,
  });
}

class OrderDetailsSuccess extends OrderListState {
  final OrderModel? orderDetails;
  final List<ProductModel>? products;
  final List<PromotionModel>? promotions;

  OrderDetailsSuccess({
    required this.orderDetails,
    this.products,
    this.promotions,
  });
}

class CheckOutSuccess extends OrderListState {
  final OrderModel? checkOut;

  CheckOutSuccess({
    required this.checkOut,
  });
}
