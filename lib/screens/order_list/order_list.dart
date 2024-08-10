import 'dart:async';

import 'package:supermarket/app_properties.dart';
import 'package:supermarket/repository/order_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() {
    return _OrderListState();
  }
}

class _OrderListState extends State<OrderList> {
  final _textSearchController = TextEditingController();
  final _scrollController = ScrollController();
  final _endReachedThreshold = 100;

  Timer? _timer;
  SortModel? _sort;

  @override
  void initState() {
    super.initState();
    _onRefresh();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _textSearchController.clear();
    _scrollController.dispose();
    super.dispose();
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    return await AppBloc.orderListCubit
        .onLoad(searchString: _textSearchController.text);
  }

  ///Handle load more
  void _onScroll() {
    if (_scrollController.position.extentAfter > _endReachedThreshold) return;
    final state = AppBloc.orderListCubit.state;
    if (state is OrderListSuccess && state.canLoadMore && !state.loadingMore) {
      AppBloc.orderListCubit.onLoadMore(
        sort: _sort,
        searchString: _textSearchController.text,
      );
    }
  }

  ///On Search
  void _onSearch(String? keyword) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 100), () {
      AppBloc.orderListCubit.onLoad(
        searchString: keyword,
      );
    });
  }

  ///On Sort
  void _onSort() async {
    if (AppBloc.orderListCubit.sortOption.isEmpty) return;
    final result = await showModalBottomSheet<SortModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [_sort],
            data: AppBloc.orderListCubit.sortOption,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _sort = result;
      });
      _onRefresh();
    }
  }

  ///On Filter
  void _onFilter() async {
    if (AppBloc.orderListCubit.statusOption.isEmpty) return;
    final result = await showModalBottomSheet<SortModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [AppBloc.orderListCubit.status],
            data: AppBloc.orderListCubit.statusOption,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        AppBloc.orderListCubit.status = result;
      });
      _onRefresh();
    }
  }

  ///On Detail Order
  void _onDetail(int id) {
    Navigator.pushNamed(
      context,
      Routes.orderDetail,
      arguments: RouteArguments(
        item: id,
        callback: _onRefresh,
      ),
    );
  }

  ///On List Items Order
  void _onOrderItemList(int id) {
    Navigator.pushNamed(
      context,
      Routes.orderItemList,
      arguments: RouteArguments(
        item: id,
        callback: _onRefresh,
      ),
    ).then((value) {
      AppBloc.orderListCubit.onLoad();
    });
  }

  ///On Check Out
  void _onCheckOut(int id) {
    Navigator.pushNamed(
      context,
      Routes.checkOut,
      arguments: id,
    ).then((value) {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(Translate.of(context).translate('orders'))),
      body: BlocProvider(
        create: (context) => AppBloc.orderListCubit,
        child: BlocBuilder<OrderListCubit, OrderListState>(
          bloc: AppBloc.orderListCubit,
          builder: (context, state) {
            Widget content = ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                return const AppOrderItem();
              },
              itemCount: 15,
            );
            if (state is OrderListSuccess) {
              if (state.list.isEmpty) {
                content = Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.sentiment_satisfied),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          Translate.of(context).translate(
                            'data_not_found',
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                int count = state.list.length;
                if (state.loadingMore) {
                  count = count + 1;
                }

                content = ListView.builder(
                  controller: _scrollController,
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    var item = state.list[index];
                    return Slidable(
                      enabled: item.status == OrderStatus.waiting ||
                          item.status == OrderStatus.toDelivery,
                      key: ValueKey(item.orderId),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          if (item.status == OrderStatus.toDelivery)
                            SlidableAction(
                              flex: 2,
                              onPressed: (BuildContext? buildContext) {
                                UtilOther.showMessage(
                                  context: context,
                                  title: Translate.of(context)
                                      .translate('receipt_confirmation'),
                                  message: Translate.of(context).translate(
                                      'please_do_not_confirm_receipt_if_there_is_any_shortage_in_the_order'),
                                  func: () async {
                                    Navigator.of(context).pop();
                                    if (await OrderRepository
                                        .confirmOrderReceipt(item.orderId)) {
                                      AppBloc.orderListCubit.onLoad();
                                      Navigator.pushNamed(
                                        context,
                                        Routes.shippingFeedback,
                                        arguments: item.orderId,
                                      );
                                    }
                                    setState(() {});
                                  },
                                  funcName: Translate.of(context)
                                      .translate('confirm'),
                                );
                              },
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.check_circle_outline_outlined,
                              label: Translate.of(context)
                                  .translate('order_receipt'),
                            ),
                          if (item.status == OrderStatus.waiting)
                            SlidableAction(
                              flex: 2,
                              onPressed: (BuildContext? buildContext) {
                                UtilOther.showMessage(
                                  context: context,
                                  title: Translate.of(context)
                                      .translate('cancellation_confirmation'),
                                  message: Translate.of(context).translate(
                                      'are_you_sure_to_cancel_the_order'),
                                  func: () {
                                    Navigator.of(context).pop();
                                    AppBloc.orderListCubit
                                        .onCancel(item.orderId);
                                    setState(() {});
                                  },
                                  funcName: Translate.of(context)
                                      .translate('confirm'),
                                );
                                // setState(() {});
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.cancel,
                              label: Translate.of(context).translate('cancel'),
                            ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                width: 1,
                                color: Theme.of(context).colorScheme.tertiary),
                            bottom: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: AppOrderItem(
                            order: item,
                            onPressed: () {
                              // if (item.status == OrderStatus.waiting) {
                              //   _onCheckOut(item.orderId);
                              // } else {
                              _onOrderItemList(item.orderId);
                              // }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    AppTextInput(
                      hintText: Translate.of(context).translate('search'),
                      controller: _textSearchController,
                      onChanged: _onSearch,
                      onSubmitted: _onSearch,
                      trailing: GestureDetector(
                        dragStartBehavior: DragStartBehavior.down,
                        onTap: () {
                          _textSearchController.clear();
                          _onSearch(null);
                        },
                        child: const Icon(Icons.clear),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InkWell(
                          onTap: _onFilter,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.track_changes_outlined,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Translate.of(context).translate('filter'),
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: _onSort,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.sort_outlined,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Translate.of(context).translate('sort'),
                                  style: Theme.of(context).textTheme.bodySmall,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: content,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
