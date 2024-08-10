import 'package:bloc/bloc.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';

import '../../configs/application.dart';
import 'cubit.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryLoading());
  List<CategoryModel> list = [];
  PaginationModel? pagination;
  int? parentId;
  int pageNumber = 1;

  Future<void> onLoad({CategoryModel? item, required String keyword}) async {
    if (keyword.isEmpty) {
      final result = await CategoryRepository.loadCategory();
      if (result != null) {
        list = result;
      }

      ///Notify
      emit(CategorySuccess(list.where((item) {
        return item.name.toUpperCase().contains(keyword.toUpperCase());
      }).toList()));
    } else {
      if (list.isEmpty) {
        final result = await CategoryRepository.loadCategory();
        if (result != null) {
          list = result;
        }
      }

      ///Notify
      emit(CategorySuccess(list.where((item) {
        return item.name.toUpperCase().contains(keyword.toUpperCase());
      }).toList()));
    }
  }
}
