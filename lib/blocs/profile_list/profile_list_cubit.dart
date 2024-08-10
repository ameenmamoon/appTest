import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';

import 'profile_list_state.dart';

class ProfileListCubit extends Cubit<ProfileListState> {
  ProfileListCubit() : super(ProfileListLoading());

  int pageNumber = 1;
  List<UserModel> list = [];
  PaginationModel? pagination;
  Timer? timer;
  String keyword = "";
  UserType? userType;

  Future<void> onLoad({List<String>? filterList}) async {
    pageNumber = 1;

    if (list.isEmpty) {
      emit(ProfileListLoading());
    }

    ///Listing Load
    final result = await UserRepository.loadProfiles(
        pageNumber: pageNumber,
        pageSize: Application.pageSize,
        searchString: keyword,
        list: filterList);

    if (result != null) {
      list = result[0];
      pagination = result[1];

      ///Notify
      emit(ProfileListSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onSearch() async {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () async {
      pageNumber = 1;

      if (list.isEmpty) {
        emit(ProfileListLoading());
      }

      ///Listing Load
      final result = await UserRepository.loadProfiles(
          pageNumber: pageNumber,
          pageSize: Application.pageSize,
          searchString: keyword);
      if (result != null) {
        list = result[0];
        pagination = result[1];

        ///Notify
        emit(ProfileListSuccess(
          list: list,
          canLoadMore: pagination!.currentPage < pagination!.totalPages,
        ));
      }
    });
  }

  Future<void> onLoadMore() async {
    pageNumber += 1;

    ///Notify loading more

    emit(ProfileListSuccess(
      list: list,
      canLoadMore: pagination!.currentPage < pagination!.totalPages,
    ));

    ///Listing Load
    final result = await UserRepository.loadProfiles(
        pageNumber: pageNumber,
        pageSize: Application.pageSize,
        searchString: keyword);
    if (result != null) {
      list.addAll(result[0]);
      pagination = result[1];

      ///Notify
      emit(ProfileListSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }
}
