import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/repository/list_repository.dart';

import '../../models/model_filter.dart';
import 'cubit.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(InitialSearchState());
  Timer? timer;

  void onSearch(String keyword) async {
    if (keyword.isNotEmpty) {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 500), () async {
        emit(SearchLoading());
        final result = await ListRepository.loadList(
          searchString: keyword,
          pageSize: Application.pageSize,
          pageNumber: 1,
        );
        if (result != null) {
          emit(SearchSuccess(list: result[0]));
        }
      });
    }
  }

  void onSearchByFilter(FilterModel filter) async {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () async {
      emit(SearchLoading());
      final result = await ListRepository.loadList(
        filter: filter,
        pageSize: Application.pageSize,
        pageNumber: 1,
      );
      if (result != null) {
        emit(SearchSuccess(list: result[0]));
      }
    });
  }

  void onClear() {
    emit(InitialSearchState());
  }
}
