import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/models/model.dart';

import '../models/model_location.dart';

class CategoryRepository {
  ///load list
  // static Future<List?> loadList({
  //   int? pageNumber,
  //   int? pageSize,
  //   String? searchString,
  //   List<int>? list,
  // }) async {
  //   Map<String, dynamic> params = {
  //     "pageNumber": pageNumber,
  //     "pageSize": pageSize,
  //     "searchString": searchString,
  //     "list": list,
  //   };
  //   final response = await Api.requestAllPagedCategories(params);
  //   if (response.succeeded) {
  //     final list = List.from(response.data ?? []).map((item) {
  //       return CategoryModel.fromJson(item);
  //     }).toList();

  //     return [list, response.pagination];
  //   }
  //   AppBloc.messageCubit.onShow(response.message);
  //   return null;
  // }

  ///Load Category
  static Future<List<CategoryModel>?> loadCategory() async {
    final result = await Api.requestCategory();
    if (result.succeeded) {
      return List.from(result.data ?? []).map((item) {
        return CategoryModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message);
    return null;
  }
  

  // ///Load Location category
  // static Future<List<LocationModel>?> loadLocation(int id) async {
  //   final result = await Api.requestLocation({"parent_id": id});
  //   if (result.succeeded) {
  //     return List.from(result.data ?? []).map((item) {
  //       return LocationModel.fromJson(item);
  //     }).toList();
  //   }
  //   AppBloc.messageCubit.onShow(result.message);
  //   return null;
  // }

  ///Load Discovery
  static Future<List<DiscoveryModel>?> loadDiscovery() async {
    final result = await Api.requestDiscovery();
    if (result.succeeded) {
      return List.from(result.data ?? []).map((item) {
        return DiscoveryModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message);
    return null;
  }
}
