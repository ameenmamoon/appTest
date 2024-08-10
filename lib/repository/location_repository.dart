import 'dart:convert';

import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/models/model.dart';

import '../configs/application.dart';
import '../configs/preferences.dart';
import '../models/model_location.dart';

class LocationRepository {
  ///Load Countries
  static Future<List<CountryModel>?> loadCountries() async {
    final result = await Api.requestCountries();
    if (result.succeeded) {
      return List.from(result.data ?? []).map((item) {
        return CountryModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message);
    return List<CountryModel>.empty();
  }

  ///Load Location
  static Future<List<LocationModel>?> loadLocation(LocationType? type) async {
    final result = await Api.requestLocation(type);
    if (result.succeeded) {
      return List.from(result.data ?? []).map((item) {
        return LocationModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message);
    return List<LocationModel>.empty();
  }

  ///Load Location
  static Future<List<LocationModel>?> loadLocationById(int? id) async {
    dynamic data = {};
    final result = await Api.requestLocationById(data);
    if (result.succeeded) {
      return List.from(result.data ?? []).map((item) {
        return LocationModel.fromJson(item);
      }).toList();
    }
    AppBloc.messageCubit.onShow(result.message);
    return null;
  }
}
