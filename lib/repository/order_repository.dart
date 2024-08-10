import 'package:flutter/material.dart';
import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/models/model.dart';

class OrderRepository {
  static Future<List?> loadOrderForm(id) async {
    final response = await Api.requestOrderForm({'resource_id': id});
    if (response.succeeded) {
      late OrderStyleModel orderStyle;
      switch (response.data['type']) {
        case 'Standard':
          orderStyle = StandardOrderModel.fromJson(response.data);
          break;
        case 'Daily':
          orderStyle = DailyOrderModel.fromJson(response.data);
          break;
        case 'Hourly':
          orderStyle = HourlyOrderModel.fromJson(response.data);
          break;
        case 'Table':
          orderStyle = TableOrderModel.fromJson(response.data);
          break;
        case 'Slot':
          orderStyle = SlotOrderModel.fromJson(response.data);
          break;
        default:
          orderStyle = StandardOrderModel(
            startDate: DateTime.now(),
            adult: 1,
            children: 1,
            startTime: const TimeOfDay(
              hour: 0,
              minute: 0,
            ),
          );
          break;
      }
      return [orderStyle, OrderPaymentModel.fromJson(response.data)];
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }

  static Future<String?> calcPrice(Map<String, dynamic> params) async {
    final response = await Api.requestPrice(params);
    if (response.succeeded) {
      return response.data['totalDisplay'];
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }

  static Future<ResultApiModel> order(Map<String, dynamic> params) async {
    final response = await Api.requestOrder(params);
    if (response.succeeded) {
      String? url;
      switch (params['paymentMethod']) {
        case '1':
          // case 'paypal':
          url = response.data['links']['href'];
          break;
        // case 'stripe':
        case '2':
          url = response.data['url'];
          break;
      }
      return ResultApiModel.fromJson({'succeeded': true, 'data': url});
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return response;
  }

  static Future<List?> loadList({
    String? searchString,
    int? pageNumber,
    int? pageSize,
    OrderStatus? orderStatus,
  }) async {
    Map<String, dynamic> params = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "searchString": searchString,
      "status": orderStatus?.index,
      "customerStatus": 4,
    };
    final response = await Api.requestOrderList(params);
    if (response.succeeded) {
      final list = List.from(response.data ?? []).map((item) {
        return OrderModel.fromJson(item);
      }).toList();

      final listSort = List.from(response.attr?['sort'] ?? []).map((item) {
        return SortModel.fromJson(item);
      }).toList();
      return [list, response.pagination, listSort /*, listStatus*/];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  static Future<bool> shippingFeeCalc(
      int id, double latitude, double longitude) async {
    final response = await Api.requestShippingFeeCalc(id, latitude, longitude);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<OrderModel?> loadDetail({int? id}) async {
    final response = await Api.requestOrderDetail(id);
    if (response.succeeded) {
      // return OrderModel.fromJson(response.data);
      return response.data != null ? OrderModel.fromJson(response.data) : null;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }

  static Future<bool?> newOrder({required OrderModel order}) async {
    final response = await Api.requestNewOrder(order.toJson());
    if (response.succeeded) {
      return true;
    } else {
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }

  static Future<CheckOutModel?> checkOut(
      {required int orderId, int? currencyId}) async {
    final params = {'orderId': orderId, 'currencyId': currencyId};
    final response = await Api.requestCheckOut(params);
    if (response.succeeded) {
      // return OrderModel.fromJson(response.data);
      return CheckOutModel.fromJson(response.data);
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return null;
  }

  static Future<bool> confirmOrderReceipt(int id) async {
    final params = {'orderId': id};
    final response = await Api.requestOrderReceipt(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<bool> shippingFeedback(
      {required int orderId,
      required int orderItemId,
      required double rate,
      required String review}) async {
    final params = {
      'orderId': orderId,
      'orderItemId': orderItemId,
      'rate': rate,
      'review': review
    };
    final response = await Api.requestShippingFeedback(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<bool> cancelRefundRequest({required int orderItemId}) async {
    final params = {'orderItemId': orderItemId};
    final response = await Api.requestCancelRefundRequest(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<bool> refundRequest(
      {required int orderItemId, required String because}) async {
    final params = {'orderItemId': orderItemId, 'because': because};
    final response = await Api.requestRefundRequest(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<bool> complaint(
      {required int orderItemId, required String txt}) async {
    final params = {'orderItemId': orderItemId, 'txt': txt};
    final response = await Api.requestComplaint(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<bool> closeComplaint({required int orderItemId}) async {
    final params = {'orderItemId': orderItemId};
    final response = await Api.requestCloseComplaint(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<bool> cancel(int id) async {
    final params = {'id': id};
    final response = await Api.requestOrderCancel(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<bool> cancelItem(int orderId, int orderItemId) async {
    final params = {'orderId': orderId, 'orderItemId': orderItemId};
    final response = await Api.requestOrderItemCancel(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  ///Init Order
  static Future<bool> initOrder({
    required List<OrderItemModel> list,
  }) async {
    Map<String, dynamic> params = {
      "orderItems": list
          .map((e) => {'productId': e.productId, 'quantity': e.quantity})
          .toList()
    };
    final response = await Api.requestInitOrder(params);
    if (response.succeeded) {
      return true;
    }
    AppBloc.messageCubit.onShow(response.message);
    return false;
  }

  ///Set Shipping Address
  static Future<bool> setShippingAddress(
      {required int orderId, required int addressId}) async {
    Map<String, dynamic> params = {
      "orderId": orderId,
      "shippingAddressId": addressId,
    };

    final response = await Api.requestSetShippingAddress(params);
    if (response.succeeded) {
      return true;
    }
    AppBloc.messageCubit.onShow(response.message);
    return false;
  }

  ///add delete cart
  static Future<bool> addDeleteCart(
      {required int productId, String? color, String? size}) async {
    final params = {'productId': productId, 'color': color, 'size': size};
    final response = await Api.requestAddDeleteCart(params);
    if (response.succeeded) {
      return true;
    }
    AppBloc.messageCubit.onShow(response.message);
    return false;
  }

  static Future<bool> receiptItem(int orderId, int orderItemId) async {
    final params = {
      'orderId': orderId,
      'orderItemId': orderItemId,
    };
    final response = await Api.requestOrderItemReceipt(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }

  static Future<bool> confirmOrderByCash(int orderId) async {
    final params = {'orderId': orderId};
    final response = await Api.requestConfirmOrderByCash(params);
    if (response.succeeded) {
      return true;
    } else {
      ///Notify
      AppBloc.messageCubit.onShow(response.message);
    }
    return false;
  }
}
