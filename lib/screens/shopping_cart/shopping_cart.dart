import 'package:flutter/cupertino.dart';
import 'package:supermarket/app_properties.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/constants/constants.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/other.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../configs/routes.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final orderListCubit = OrderListCubit();
  int orderItemsLength = 0;
  final ValueNotifier<bool> _updateTotal = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    orderListCubit.onLoadItems().whenComplete(() {
      _updateTotal.value = !_updateTotal.value;
    });
  }

  @override
  void dispose() {
    orderListCubit.close();
    super.dispose();
  }

  Future<void> newOrder() async {
    var order = (orderListCubit.state as OrderDetailsSuccess).orderDetails;
    if (order == null) return;
    // Navigator.pushNamed(context, Routes.checkOut2, arguments: order);

    final result = await orderListCubit.onNewOrder(order: order);
    if (result) {
      Navigator.pop(context, Routes.orderSuccess);
    }
  }

  Future<int?> onChangeUnit(OrderItemModel orderItem) async {
    final result = await showModalBottomSheet<ProductUnitModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => AppBottomPicker(
        picker: PickerModel(
          selected: [
            orderItem.productUnits!.where((element) => element.isSelected)
          ],
          data: orderItem.productUnits!,
        ),
        // hasScroll: true,
      ),
    );
    if (result == null) return null;
    return result.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: darkGrey),
        actions: const <Widget>[],
        title: Text(
          Translate.of(context).translate('shopping_cart'),
          style: const TextStyle(
              color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return false;
        },
        child: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _updateTotal,
              builder: (context, value, child) {
                return Container(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      AppLanguage.isRTL() ? 0 : 32.0,
                      AppLanguage.isRTL() ? 32.0 : 32.0,
                      0),
                  height: 48.0,
                  color: yellow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('subtotal'),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        AppLanguage.isRTL()
                            ? '${Translate.of(context).translate('items')}: ${(orderListCubit.state is OrderDetailsSuccess) == true ? (orderListCubit.state as OrderDetailsSuccess).orderDetails?.orderItems.length ?? 0 : 0}'
                            : '${(orderListCubit.state is OrderDetailsSuccess) == true ? (orderListCubit.state as OrderDetailsSuccess).orderDetails?.orderItems.length ?? 0 : 0} :${Translate.of(context).translate('items')}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      InkWell(
                        onTap: () async {
                          await newOrder();
                        },
                        child: Container(
                            height: double.infinity,
                            width: 80,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 72, 202, 115),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              // gradient: mainButton,
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.16),
                                  offset: Offset(0, 5),
                                  blurRadius: 10.0,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'متابعة',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                ),
                                const Icon(
                                  Icons.shopping_cart_checkout_outlined,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<OrderListCubit, OrderListState>(
                bloc: orderListCubit,
                builder: (context, state) {
                  Widget content = AppPlaceholder(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 90,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );

                  if (state is OrderDetailsSuccess) {
                    // content Unpaid
                    content = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.incompleteOrderList);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              height: 48.0,
                              color: red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    Translate.of(context).translate(
                                        'click_here_to_complete_unpaid_orders'),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]);

                    // content
                    if (state.orderDetails != null) {
                      orderItemsLength = state.orderDetails!.orderItems.length;
                      content = ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemBuilder: (context, index) {
                          final item = state.orderDetails!.orderItems[index];
                          return ShopItemList(
                            item,
                            isShowCase: false, //index == 0,
                            onChangeQuantity: (int quantity) {
                              item.quantity = quantity;
                            },
                            onChangeUnit: () => onChangeUnit(item),
                            onUpdateItem: (OrderItemModel orderItem) {
                              state.orderDetails!.orderItems
                                  .singleWhere(
                                      (element) => element.id == orderItem.id)
                                  .unitId = orderItem.unitId;
                              state.orderDetails!.orderItems
                                  .singleWhere(
                                      (element) => element.id == orderItem.id)
                                  .unitName = orderItem.unitName;
                              state.orderDetails!.orderItems
                                  .singleWhere(
                                      (element) => element.id == orderItem.id)
                                  .price = orderItem.price;
                              state.orderDetails!.orderItems
                                  .singleWhere(
                                      (element) => element.id == orderItem.id)
                                  .total = orderItem.total;
                            },
                            onRemove: () {
                              UtilOther.showMessage(
                                context: context,
                                title:
                                    Translate.of(context).translate('_confirm'),
                                message: Translate.of(context).translate(
                                    'confirm_the_removal_of_the_product_from_the_shopping_cart'),
                                func: () {
                                  Navigator.pop(context);
                                  orderListCubit.onCancelItem(
                                      state.orderDetails!.orderItems[index]
                                          .orderId,
                                      state.orderDetails!.orderItems[index].id);
                                },
                                funcName:
                                    Translate.of(context).translate('confirm'),
                              );
                            },
                          );
                        },
                        itemCount: state.orderDetails!.orderItems.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 12);
                        },
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {},
                      child: content,
                    );
                  }
                  return content;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
