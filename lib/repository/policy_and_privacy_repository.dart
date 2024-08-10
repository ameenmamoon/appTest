import 'dart:convert';

import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';

class PolicyAndPrivacyRepository {
  static Future<String?> loadPolicyAndPrivacy() async {
    final response = await Api.requestPolicyAndPrivacy();
    if (response.succeeded) {
      return response.data;
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  static Future<String?> loadTermsAndConditions() async {
    final response = await Api.requestTermsAndConditions();
    if (response.succeeded) {
      return response.data;
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }
}
