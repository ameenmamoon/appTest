import 'package:supermarket/models/model.dart';

abstract class PromotionState {}

class PromotionLoading extends PromotionState {}

class PromotionSuccess extends PromotionState {
  final List<PromotionModel> list;
  final bool canLoadMore;
  final bool loadingMore;

  PromotionSuccess({
    required this.list,
    required this.canLoadMore,
    this.loadingMore = false,
  });
}
