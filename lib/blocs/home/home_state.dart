import 'package:supermarket/models/model.dart';

import '../../models/model_location.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<CategoryModel> category;
  final List<ProductModel> product;
  final List<HomeSectionModel> list;
  final bool canLoadMore;
  final bool loadingMore;

  HomeSuccess(
      {required this.category,
      required this.product,
      required this.list,
      required this.canLoadMore,
      this.loadingMore = false});
}
