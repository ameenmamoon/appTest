import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/models/model.dart';

import '../models/model_location.dart';

class HomeRepository {
  ///Load Category
  static Future<List?> load(
      {required int pageNumber,
      required int pageSize,
      int? categoryId,
      bool withUnActive = false}) async {
    final params = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'withUnActive': withUnActive,
      'categoryId': categoryId,
      'lang': AppBloc.languageCubit.state.languageCode,
    };
    final response = await Api.requestHomeSections(params);
    if (response.succeeded) {
      final list = List.from(response.data ?? []).map((item) {
        return HomeSectionModel.fromJson(item);
      }).toList();
      return [list, response.pagination];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }
}
