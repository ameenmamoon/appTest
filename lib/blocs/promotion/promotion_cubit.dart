import 'package:bloc/bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';
import 'package:supermarket/utils/logger.dart';

import 'cubit.dart';

class PromotionCubit extends Cubit<PromotionState> {
  PromotionCubit() : super(PromotionLoading());

  int page = 1;
  List<PromotionModel> list = [];
  PaginationModel? pagination;

  void onResetPagination() {
    page = 1;
    list = [];
    pagination = null;
  }

  Future<void> onLoad({String? searchString}) async {
    page = 1;

    ///Fetch API
    final result = await ListRepository.loadPromotionList(
      pageNumber: page,
      pageSize: Application.pageSize,
      searchString: searchString,
    );
    if (result != null) {
      list = result[0];
      pagination = result[1];

      ///Notify
      emit(PromotionSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
    // emit(PromotionSuccess(
    //   list: [
    //     PromotionModel(
    //         id: 1,
    //         name: 'name1',
    //         description: 'description1',
    //         image: 'image1',
    //         price: 52.5,
    //         priceAfterDiscount: 45,
    //         startDate: 'startDate',
    //         endDate: 'endDate'),
    //     PromotionModel(
    //         id: 2,
    //         name: 'name2',
    //         description: 'description2',
    //         image: 'image2',
    //         price: 5445.5,
    //         priceAfterDiscount: 4512,
    //         startDate: 'startDate',
    //         endDate: 'endDate'),
    //     PromotionModel(
    //         id: 3,
    //         name: 'name3',
    //         description: 'description3',
    //         image: 'image3',
    //         price: 52.5,
    //         priceAfterDiscount: 45,
    //         startDate: 'startDate',
    //         endDate: 'endDate'),
    //   ],
    //   canLoadMore: false,
    // ));
  }

  Future<void> onLoadMore({String? searchString}) async {
    page = page + 1;

    ///Notify
    emit(PromotionSuccess(
      loadingMore: true,
      list: list,
      canLoadMore: pagination!.currentPage < pagination!.totalPages,
    ));

    ///Fetch API
    final result = await ListRepository.loadPromotionList(
      pageNumber: page,
      pageSize: Application.pageSize,
      searchString: searchString,
    );
    if (result != null) {
      list.addAll(result[0]);
      pagination = result[1];

      ///Notify
      emit(PromotionSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onUpdate(int id) async {
    // try {
    //   final exist = list.firstWhere((e) => e.id == id);
    //   final result = await ListRepository.loadProduct(id);
    //   if (result != null) {
    //     list = list.map((e) {
    //       if (e.id == exist.id) {
    //         return result;
    //       }
    //       return e;
    //     }).toList();

    //     ///Notify
    //     emit(DiscoverySuccess(
    //       list: list,
    //       canLoadMore: pagination!.currentPage < pagination!.totalPages,
    //     ));
    //   }
    // } catch (error) {
    //   UtilLogger.log("LIST NOT FOUND UPDATE");
    // }
  }
}
