import 'package:bloc/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';

import 'cubit.dart';

class CustomerOrderListCubit extends Cubit<CustomerOrderListState> {
  CustomerOrderListCubit() : super(CustomerOrderListLoading());

  int pageNumber = 1;
  List<CustomerOrderModel> list = [];
  int countAwaitingApproval = 0;
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

  Future<void> onLoad({
    SortModel? sort,
    String? searchString,
    OrderStatus? orderStatus,
  }) async {
    pageNumber = 1;

    ///Fetch API
    final result = await CustomerOrderRepository.loadList(
      pageNumber: pageNumber,
      pageSize: Application.pageSize,
      sort: sort,
      orderStatus: orderStatus,
      searchString: searchString,
    );
    if (result != null) {
      list = result[0];
      countAwaitingApproval = result[1];
      pagination = result[2];
      if (sortOption.isEmpty) {
        sortOption = result[3];
      }

      ///Notify
      emit(CustomerOrderListSuccess(
        list: list,
        countAwaitingApproval: countAwaitingApproval,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onLoadMore({
    SortModel? sort,
    String? searchString,
    OrderStatus? orderStatus,
  }) async {
    pageNumber = pageNumber + 1;

    ///Notify
    emit(CustomerOrderListSuccess(
      loadingMore: true,
      list: list,
      countAwaitingApproval: countAwaitingApproval,
      canLoadMore: pagination!.currentPage < pagination!.totalPages,
    ));

    ///Fetch API
    final result = await CustomerOrderRepository.loadList(
      pageNumber: pageNumber,
      pageSize: Application.pageSize,
      sort: sort,
      orderStatus: orderStatus,
      searchString: searchString,
    );

    if (result != null) {
      list.addAll(result[0]);
      // countAwaitingApproval = result[1];
      pagination = result[2];

      ///Notify
      emit(CustomerOrderListSuccess(
        list: list,
        countAwaitingApproval: countAwaitingApproval,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }

  Future<void> onGetCustomerOrderAmount({required int id}) async {
    ///Fetch API
    final result = await CustomerOrderRepository.customerOrderAmount(id: id);
    emit(CustomerOrderAmountSuccess(
      customerOrderAmount: result,
    ));
  }

  // Future<void> onLoadDetail({int? id}) async {
  //   ///Fetch API
  //   final result = await CustomerOrderRepository.loadDetail(id: id);
  //   emit(OrderDetailsSuccess_(
  //     orderDetails: result == null ? null : result[0],
  //     hasUnpaidOrders: result == null ? false : result[1],
  //   ));
  // }

  Future<void> onCancel(id) async {
    final result = await OrderRepository.cancel(id);
    if (result) {
      list.removeWhere((element) => element.orderId == id);
      emit(CustomerOrderListSuccess(
        list: list,
        countAwaitingApproval: countAwaitingApproval,
        canLoadMore: pagination!.currentPage < pagination!.totalPages,
      ));
    }
  }
}
