import 'package:bloc/bloc.dart';
import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:flutter/widgets.dart';

import '../../models/model_location.dart';
import '../../repository/repository.dart';
import '../../utils/other.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());
  // int pageNumber = 1;
  List<HomeSectionModel> list = [];
  List<CategoryModel> listCategory = [];
  List<ProductModel> listProduct = [];
  PaginationModel? pagination;
  int pageNumber = 1;

  Future<void> onLoad({bool withUnActive = false, int? categoryId}) async {
    pageNumber = 1;
    list = [];
    listCategory = [];
    listProduct = [];

    final categoriesResult = await CategoryRepository.loadCategory();
    final productResult =
        await ListRepository.loadList(pageNumber: 1, pageSize: 10);
    if (categoriesResult != null) {
      listCategory = categoriesResult;
    }
    if (productResult != null) {
      listProduct.addAll(productResult[0]);
    }

    emit(HomeSuccess(
      category: listCategory,
      product: listProduct,
      list: [], //list,
      canLoadMore: false, //pagination!.currentPage < pagination!.totalPages,
    ));
  }

  Future<void> onLoadMore({bool withUnActive = false, int? categoryId}) async {
    pageNumber = pageNumber + 1;
    emit(HomeSuccess(
      category: [
        CategoryModel(id: 1, name: 'العصائر', description: 'قسم العصائر'),
        CategoryModel(id: 2, name: 'الاجبان', description: 'قسم الاجبان'),
      ],
      product: [],
      loadingMore: true,
      list: list,
      canLoadMore: pagination!.currentPage < pagination!.totalPages,
    ));

    ///Fetch API
    final result = await HomeRepository.load(
        pageNumber: pageNumber,
        pageSize: Application.pageSize,
        categoryId: categoryId,
        withUnActive: withUnActive);
    if (result != null) {
      list.addAll(result[0]);
      pagination = result[1];
    }

    ///Notify
    emit(HomeSuccess(
      category: [
        CategoryModel(id: 1, name: 'العصائر', description: 'قسم العصائر'),
        CategoryModel(id: 2, name: 'الاجبان', description: 'قسم الاجبان'),
      ],
      product: [],
      loadingMore: false,
      list: list,
      canLoadMore: pagination!.currentPage < pagination!.totalPages,
    ));
  }
}
