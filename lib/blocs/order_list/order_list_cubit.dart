import 'package:bloc/bloc.dart';
import 'package:supermarket/blocs/app_bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/models/model_order.dart';
import 'package:supermarket/repository/repository.dart';

import 'cubit.dart';

class OrderListCubit extends Cubit<OrderListState> {
  OrderListCubit() : super(OrderListLoading());

  int pageNumber = 1;
  List<OrderModel> list = [];
  CheckOutModel? checkOut;
  PaginationModel? pagination;
  SortModel? sort;
  SortModel? status;
  List<SortModel> sortOption = [
    SortModel(
      name: "lasted",
      value: "descending",
      field: "CreatedOn",
    ),
    SortModel(
      name: "oldest",
      value: "ascending",
      field: "CreatedOn",
    ),
  ];
  List<SortModel> statusOption = [
    SortModel(
      name: 'all',
      value: null,
      field: "Status",
    ),
    SortModel(
      name: OrderStatus.waiting.name,
      value: OrderStatus.waiting.index,
      field: "Status",
    ),
    SortModel(
      name: OrderStatus.available.name,
      value: OrderStatus.available.index,
      field: "Status",
    ),
    SortModel(
      name: OrderStatus.notAvailable.name,
      value: OrderStatus.notAvailable.index,
      field: "Status",
    ),
    SortModel(
      name: OrderStatus.partialAvailable.name,
      value: OrderStatus.partialAvailable.index,
      field: "Status",
    ),
    SortModel(
      name: OrderStatus.toDelivery.name,
      value: OrderStatus.toDelivery.index,
      field: "Status",
    ),
  ];
  static List<dynamic> shoppingCartProducts = [];
  static List<int> shoppingCartsPromotions = [];

  Future<void> onLoad({
    String? searchString,
  }) async {
    pageNumber = 1;

    ///Fetch API
    final result = await OrderRepository.loadList(
      pageNumber: pageNumber,
      pageSize: Application.pageSize,
      orderStatus: status != null && status?.value != null
          ? OrderStatus.values[status?.value as int]
          : null,
      searchString: searchString,
    );
    if (result != null) {
      list = result[0];
      pagination = result[1];
      if (sortOption.isEmpty) {
        sortOption = result[2];
      }

      ///Notify
      emit(OrderListSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onLoadMore({
    SortModel? sort,
    String? searchString
  }) async {
    pageNumber = pageNumber + 1;

    ///Notify
    emit(OrderListSuccess(
      loadingMore: true,
      list: list,
      canLoadMore: pagination!.currentPage < pagination!.totalPages,
    ));

    ///Fetch API
    final result = await OrderRepository.loadList(
      pageNumber: pageNumber,
      pageSize: Application.pageSize,
      orderStatus: status != null && status?.value != null
          ? OrderStatus.values[status?.value as int]
          : null,
      searchString: searchString,
    );

    if (result != null) {
      list.addAll(result[0]);
      pagination = result[1];

      ///Notify
      emit(OrderListSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onLoadItems({int? id}) async {
    if (Application.shoppingCartProducts.map((e) => e[0] as int).isEmpty &&
        Application.shoppingCartsPromotions.isEmpty) {
      AppBloc.messageCubit.onShow('لاتوجد عناصر في السلة');
      return;
    }

    ///Fetch API
    final shoppingItems = await ListRepository.loadListByList(
        products:
            Application.shoppingCartProducts.map((e) => e[0] as int).toList(),
        promotions: Application.shoppingCartsPromotions);
    if ((Application.shoppingCartProducts.map((e) => e[0] as int).isNotEmpty ||
            Application.shoppingCartsPromotions.isNotEmpty) &&
        shoppingItems == null) {
      AppBloc.messageCubit.onShow('تحقق من وجود الانترنت');
    }

    final resultProduct = shoppingItems![0];
    final resultPromotion = shoppingItems[1];
    List<OrderItemModel> orderItems = [];
    if (resultProduct != null) {
      orderItems
          .addAll(List.from((resultProduct as List<ProductModel>)).map((item) {
        return OrderItemModel(
          id: item.id,
          orderId: 0,
          productId: (item as ProductModel).id,
          name: item.name,
          image: item.image,
          quantity: 1,
          unitId: Application.shoppingCartProducts
              .singleWhere((e) => e[0] == item.id)[1],
          unitName: item.productUnits
              .singleWhere((e) =>
                  e.id ==
                  Application.shoppingCartProducts
                      .singleWhere((e) => e[0] == item.id)[1])
              .name,
          unitPrice: item.productUnits
                      .singleWhere((e) =>
                          e.id ==
                          Application.shoppingCartProducts
                              .singleWhere((e) => e[0] == item.id)[1])
                      .priceAfterDiscount !=
                  0
              ? item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .priceAfterDiscount
              : item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .price,
          price: item.productUnits
                      .singleWhere((e) =>
                          e.id ==
                          Application.shoppingCartProducts
                              .singleWhere((e) => e[0] == item.id)[1])
                      .priceAfterDiscount !=
                  0
              ? item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .priceAfterDiscount
              : item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .price,
          discount: item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .price -
              item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .priceAfterDiscount,
          quantityAvailable: 0,
          total: 0,
          productUnits: item.productUnits,
        );
      }).toList());
    }
    if (resultPromotion != null) {
      orderItems.addAll(
          List.from((resultPromotion as List<PromotionModel>)).map((item) {
        return OrderItemModel(
            id: item.id,
            orderId: 0,
            promotionId: item.id,
            name: item.name,
            image: item.image,
            quantity: 1,
            unitName: 'العرض الواحد',
            unitPrice: item.priceAfterDiscount != 0
                ? item.priceAfterDiscount
                : item.price,
            price: item.priceAfterDiscount != 0
                ? item.priceAfterDiscount
                : item.price,
            discount: item.price - item.priceAfterDiscount,
            quantityAvailable: 0,
            total: 0);
      }).toList());
    }
    if (resultPromotion != null || resultProduct != null) {
      double total = 0;
      double discount = 0;
      for (var item in orderItems) {
        total += item.price;
        discount += item.discount!;
      }
      emit(OrderDetailsSuccess(
        orderDetails: OrderModel(
          orderId: 0,
          status: OrderStatus.waiting,
          amount: 0,
          discount: discount,
          total: total,
          orderItems: orderItems,
          latitude: '',
          longitude: '',
          paymentMethod: PaymentType.cash,
          addressType: AddressType.home,
        ),
      ));
    }
  }

  Future<void> onLoadDetail({int? id}) async {
    ///Fetch API

    final result = await OrderRepository.loadDetail(id: id);
    if (result != null) {
      emit(OrderDetailsSuccess(
        orderDetails: result,
      ));
    }
  }

  Future<bool> onNewOrder({required OrderModel order}) async {
    final result = await OrderRepository.newOrder(order: order);
    if (result == true) {
      Application.shoppingCartProducts = [];
      Application.shoppingCartsPromotions = [];
    }
    return false;
  }

  Future<bool> onInitOrder({required List<OrderItemModel> list}) async {
    return await OrderRepository.initOrder(list: list);
  }

  Future<void> onLoadCheckOut({required int orderId}) async {
    emit(OrderListLoading());

    ///Fetch API
    final shoppingItems = await ListRepository.loadListByList(
        products:
            Application.shoppingCartProducts.map((e) => e[0] as int).toList(),
        promotions: Application.shoppingCartsPromotions);

    final resultProduct = shoppingItems![0];
    final resultPromotion = shoppingItems[1];
    List<OrderItemModel> orderItems = [];
    if (resultProduct != null) {
      orderItems
          .addAll(List.from((resultProduct as List<ProductModel>)).map((item) {
        return OrderItemModel(
          id: item.id,
          orderId: 0,
          productId: (item as ProductModel).id,
          name: item.name,
          image: item.image,
          quantity: 1,
          unitId: Application.shoppingCartProducts
              .singleWhere((e) => e[0] == item.id)[1],
          unitName: item.productUnits
              .singleWhere((e) =>
                  e.id ==
                  Application.shoppingCartProducts
                      .singleWhere((e) => e[0] == item.id)[1])
              .name,
          unitPrice: item.productUnits
                      .singleWhere((e) =>
                          e.id ==
                          Application.shoppingCartProducts
                              .singleWhere((e) => e[0] == item.id)[1])
                      .priceAfterDiscount !=
                  0
              ? item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .priceAfterDiscount
              : item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .price,
          price: item.productUnits
                      .singleWhere((e) =>
                          e.id ==
                          Application.shoppingCartProducts
                              .singleWhere((e) => e[0] == item.id)[1])
                      .priceAfterDiscount !=
                  0
              ? item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .priceAfterDiscount
              : item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .price,
          discount: item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .price -
              item.productUnits
                  .singleWhere((e) =>
                      e.id ==
                      Application.shoppingCartProducts
                          .singleWhere((e) => e[0] == item.id)[1])
                  .priceAfterDiscount,
          quantityAvailable: 0,
          total: 0,
          productUnits: item.productUnits,
        );
      }).toList());
    }
    if (resultPromotion != null) {
      orderItems.addAll(
          List.from((resultPromotion as List<PromotionModel>)).map((item) {
        return OrderItemModel(
            id: item.id,
            orderId: 0,
            promotionId: item.id,
            name: item.name,
            image: item.image,
            quantity: 1,
            unitName: 'العرض الواحد',
            unitPrice: item.priceAfterDiscount != 0
                ? item.priceAfterDiscount
                : item.price,
            price: item.priceAfterDiscount != 0
                ? item.priceAfterDiscount
                : item.price,
            discount: item.price - item.priceAfterDiscount,
            quantityAvailable: 0,
            total: 0);
      }).toList());
    }
    if (resultPromotion != null || resultProduct != null) {
      double total = 0;
      double discount = 0;
      for (var item in orderItems) {
        total += item.price;
        discount += item.discount!;
      }
      emit(CheckOutSuccess(
        checkOut: OrderModel(
          orderId: 0,
          status: OrderStatus.waiting,
          amount: 0,
          discount: discount,
          total: total,
          orderItems: orderItems,
          latitude: '',
          longitude: '',
          paymentMethod: PaymentType.cash,
          addressType: AddressType.home,
        ),
      ));
    }
  }

  // Future<void> onCheckOut({required int orderId, int? currencyId}) async {
  //   emit(OrderListLoading());

  //   ///Fetch API
  //   final result = await OrderRepository.checkOut(
  //       orderId: orderId, currencyId: currencyId);
  //   checkOut = result;
  //   emit(CkeckOutSuccess(
  //     checkOut: result,
  //   ));
  // }

  Future<bool> onSetShippingAddress(
      {required int orderId, required int addressId}) async {
    ///Fetch API
    return await OrderRepository.setShippingAddress(
        orderId: orderId, addressId: addressId);
    // emit(CkeckOutSuccess(
    //   checkOut: result,
    // ));
  }

  Future<void> onCancel(id) async {
    final result = await OrderRepository.cancel(id);
    if (result) {
      list.removeWhere((element) => element.orderId == id);
      emit(OrderListSuccess(
        list: list,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onCancelItem(orderId, orderItemId) async {
    final result = await OrderRepository.cancelItem(orderId, orderItemId);
    if (result) {
      // list.removeWhere((element) => element.orderId == id);
      onLoadDetail(id: orderId);
      // emit(OrderListSuccess(
      //   list: list,
      //   canLoadMore: pagination!.currentPage < pagination!.totalPages,
      // ));
    }
  }
}
