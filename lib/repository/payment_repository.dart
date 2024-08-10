import 'package:flutter/material.dart';
import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/models/model.dart';

class PaymentRepository {
  static Future<bool> paymentByJawali({
    required int orderId,
    required int? currencyId,
    required String receiverMobile,
    required String voucher,
  }) async {
    final response = await Api.requestPaymentByJawali({
      'orderId': orderId,
      'currencyId': currencyId,
      'receiverMobile': receiverMobile,
      'voucher': voucher,
    });
    if (response.succeeded) {
      return true;
    }
    AppBloc.messageCubit.onShow(response.message);
    return false;
  }

  static Future<String?> createPaymentIntent({
    required String paymentType,
    required int id,
    required String paymentMethodType,
  }) async {
    final response = await Api.requestCreatePaymentIntent(
        {'paymentType': paymentType, 'id': id, 'paymentMethodTypes': 'card'});
    if (response.succeeded) {
      return response.data['clientSecret'];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  static Future<Map<String, String>?> createPaymentLink(
      {required int productId,
      required String amount,
      required String currency,
      required String paymentMethodType}) async {
    final response = await Api.requestCreatePaypalLink({
      'productId': productId,
      'amount': 2500,
      'currency': 'USD',
      // 'paymentMethodTypes': 'card'
    });
    if (response.succeeded) {
      return {
        'executeUrl': response.data['executeUrl'],
        'approvalUrl': response.data['approvalUrl']
      };
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }
}
