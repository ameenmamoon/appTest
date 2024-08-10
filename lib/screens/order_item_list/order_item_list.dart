import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supermarket/app_properties.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model_order.dart';
import 'package:supermarket/repository/order_repository.dart';
import 'package:supermarket/utils/other.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/utils/validate.dart';
import 'package:supermarket/widgets/shop_item_list.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../widgets/widget.dart';

class OrderItemList extends StatefulWidget {
  final RouteArguments arguments;
  const OrderItemList({Key? key, required this.arguments}) : super(key: key);

  @override
  _OrderItemListState createState() => _OrderItemListState();
}

class _OrderItemListState extends State<OrderItemList> {
  SwiperController swiperController = SwiperController();
  final orderListCubit = OrderListCubit();
  // final GlobalKey _slidableItemKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    orderListCubit.onLoadDetail(id: widget.arguments.item);
  }

  @override
  void dispose() {
    orderListCubit.close();
    swiperController.dispose();
    super.dispose();
  }

  ///On Return
  void _onReturn(
    BuildContext context_,
    int orderItemId,
  ) async {
    String? errorDescription;
    await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? because;
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('confirm_return_request'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Translate.of(context).translate('reason_for_return'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  maxLines: 10,
                  errorText: errorDescription,
                  hintText: errorDescription ??
                      Translate.of(context)
                          .translate('why_do_you_want_to_return'),
                  controller: TextEditingController(),
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    setState(() {
                      because = text;
                      errorDescription =
                          UtilValidator.validate(text, allowEmpty: false);
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('confirm'),
              onPressed: () async {
                errorDescription =
                    UtilValidator.validate(because ?? "", allowEmpty: false);
                setState(() {});
                if (errorDescription == null) {
                  Navigator.pop(context, because);
                  final result = await OrderRepository.refundRequest(
                      orderItemId: orderItemId, because: because!);
                  if (result) {
                    orderListCubit.onLoadDetail(id: widget.arguments.item);
                    AppBloc.messageCubit.onShow(Translate.of(context_).translate(
                        'dear_customer_the_return_request_has_been_sent_to_the_merchant_In_the_event_that_you_do_not_respond_within_day_please_file_complaint'));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  buildTimeLineTiles(int stepIndex) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              isFirst: true,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 32) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.redAccent, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: const Icon(
                        Icons.list_alt,
                        color: Colors.redAccent,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        Translate.of(context)
                            .translate(OrderStatus.waiting.name),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 0
                    ? Colors.green
                    : Colors.grey.withOpacity(0.5),
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 0
                    ? IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                        fontSize: 16)
                    : null,
              ),
              afterLineStyle: stepIndex >= 1
                  ? const LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 4,
                    ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 32) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.blue, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.thumb_up_sharp,
                        color: (orderListCubit.state is OrderDetailsSuccess)
                            ? ((orderListCubit.state as OrderDetailsSuccess)
                                        .orderDetails!
                                        .status ==
                                    OrderStatus.available
                                ? Colors.green
                                : (orderListCubit.state as OrderDetailsSuccess)
                                            .orderDetails!
                                            .status ==
                                        OrderStatus.partialAvailable
                                    ? Colors.orange
                                    : (orderListCubit.state
                                                    as OrderDetailsSuccess)
                                                .orderDetails!
                                                .status ==
                                            OrderStatus.notAvailable
                                        ? Colors.red
                                        : Colors.blue)
                            : Colors.blue,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        Translate.of(context).translate((orderListCubit.state
                                is OrderDetailsSuccess)
                            ? (orderListCubit.state as OrderDetailsSuccess)
                                            .orderDetails!
                                            .status ==
                                        OrderStatus.available &&
                                    (orderListCubit.state
                                                as OrderDetailsSuccess)
                                            .orderDetails!
                                            .status ==
                                        OrderStatus.partialAvailable &&
                                    (orderListCubit.state
                                                as OrderDetailsSuccess)
                                            .orderDetails!
                                            .status ==
                                        OrderStatus.notAvailable
                                ? (orderListCubit.state as OrderDetailsSuccess)
                                    .orderDetails!
                                    .status
                                    .name
                                : OrderStatus.available.name
                            : OrderStatus.available.name),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 1
                    ? Colors.green
                    : Colors.grey.withOpacity(0.5),
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 1
                    ? IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                        fontSize: 16)
                    : null,
              ),
              beforeLineStyle: stepIndex >= 1
                  ? const LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 4,
                    ),
              afterLineStyle: stepIndex >= 2
                  ? const LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 4,
                    ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 32) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.amber, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.amber,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        Translate.of(context)
                            .translate(OrderStatus.toDelivery.name),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 2
                    ? Colors.green
                    : Colors.grey.withOpacity(0.5),
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 2
                    ? IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                        fontSize: 16)
                    : null,
              ),
              beforeLineStyle: stepIndex >= 2
                  ? const LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 4,
                    ),
              afterLineStyle: stepIndex >= 3
                  ? const LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 4,
                    ),
            ),
            TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.end,
              isLast: true,
              startChild: Container(
                width: (MediaQuery.of(context).size.width - 32) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.green, width: 2),

                        //shape: BoxShape.rectangle,
                      ),
                      child: const Icon(
                        Icons.done_all,
                        color: Colors.green,
                        size: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        Translate.of(context)
                            .translate(OrderStatus.deliveried.name),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      ),
                    )
                  ],
                ),
              ),
              indicatorStyle: IndicatorStyle(
                color: stepIndex >= 3
                    ? Colors.green
                    : Colors.grey.withOpacity(0.5),
                padding: const EdgeInsets.all(0),
                iconStyle: stepIndex >= 3
                    ? IconStyle(
                        color: Colors.white,
                        iconData: Icons.check,
                        fontSize: 16)
                    : null,
              ),
              beforeLineStyle: stepIndex >= 3
                  ? LineStyle(
                      color: Colors.green,
                      thickness: 5,
                    )
                  : LineStyle(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 4,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => orderListCubit,
        child: BlocBuilder<OrderListCubit, OrderListState>(
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
                  Card(
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
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
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                            ? '${Translate.of(context).translate('items')}: ${state.orderDetails?.orderItems.length ?? 0}'
                            : '${state.orderDetails?.orderItems.length ?? 0} :${Translate.of(context).translate('items')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                if (state.orderDetails != null &&
                    state.orderDetails!.orderItems.isNotEmpty)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    color: Theme.of(context).colorScheme.tertiary,
                    child: Scrollbar(
                        child: ListView.builder(
                      itemBuilder: (_, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: buildTimeLineTiles(
                                (state.orderDetails?.status ==
                                        OrderStatus.waiting)
                                    ? 0
                                    : state.orderDetails?.status ==
                                                OrderStatus.available ||
                                            state.orderDetails?.status ==
                                                OrderStatus.partialAvailable
                                        ? 1
                                        : state.orderDetails?.status ==
                                                OrderStatus.toDelivery
                                            ? 2
                                            : 3),
                          );
                        }
                        if (index == 1) {
                          if (state.orderDetails!.status.index ==
                              OrderStatus.toDelivery.index) {
                            return Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        Translate.of(context)
                                            .translate('delivery_code'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                    SizedBox(width: 8),
                                    Text(state.orderDetails!.deliveryCode!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall)
                                  ],
                                ));
                          } else {
                            return Container();
                          }
                        }
                        if (index == 2) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      minWidth: double.infinity),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        'تفاصيل الفاتورة',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${state.orderDetails!.total.toString()} ر.س',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'الفاتورة',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '${state.orderDetails!.discount.toString()} ر.س',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'اجمالي الخصم',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${state.orderDetails!.total} ر.س',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'الاجمالي',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        final item = state.orderDetails!.orderItems[index - 3];
                        return Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Slidable(
                            // enabled: item.status != OrderStatus.waiting,
                            key: ValueKey(item.orderId),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                if (state.orderDetails!.status ==
                                    OrderStatus.toDelivery)
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
                                              .confirmOrderReceipt(
                                                  item.orderId)) {
                                            orderListCubit.onLoad();
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
                                if (state.orderDetails!.status ==
                                    OrderStatus.waiting)
                                  SlidableAction(
                                    flex: 2,
                                    onPressed: (BuildContext? buildContext) {
                                      UtilOther.showMessage(
                                        context: context,
                                        title: Translate.of(context)
                                            .translate('_confirm'),
                                        message: Translate.of(context).translate(
                                            'confirm_item_removal_from_order'),
                                        func: () {
                                          Navigator.of(context).pop();
                                          orderListCubit.onCancelItem(
                                              item.orderId, item.id);
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
                                    label: Translate.of(context)
                                        .translate('cancel'),
                                  ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                  bottom: BorderSide(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer),
                                ),
                                color: Colors.white,
                              ),
                              child: OrderItem(
                                status: state.orderDetails!.status,
                                item,
                                onChangeQuantity: (int quantity) {
                                  item.quantity = quantity;
                                },
                                onShippingFeedback: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.shippingFeedback,
                                    arguments: {
                                      'orderId': item.orderId,
                                      'orderItemId': item.id
                                    },
                                  ).then((value) {
                                    if (value == true) {
                                      orderListCubit.onLoadDetail(
                                          id: widget.arguments.item);
                                    }
                                  });
                                  setState(() {});
                                },
                                onRemove: () {
                                  UtilOther.showMessage(
                                    context: context,
                                    title: Translate.of(context)
                                        .translate('_confirm'),
                                    message: Translate.of(context).translate(
                                        'confirm_item_removal_from_order'),
                                    func: () {
                                      Navigator.pop(context);
                                      orderListCubit.onCancelItem(
                                          item.orderId, item.id);
                                    },
                                    funcName: Translate.of(context)
                                        .translate('confirm'),
                                  );
                                },
                                onReceipt: () {
                                  UtilOther.showMessage(
                                    context: context,
                                    title: Translate.of(context)
                                        .translate('_confirm'),
                                    message: Translate.of(context).translate(
                                        'confirmation_of_customer_receipt_of_the_order'),
                                    func: () {
                                      Navigator.pop(context);
                                      OrderRepository.receiptItem(
                                              item.orderId, item.id)
                                          .then((value) {
                                        if (value) {
                                          orderListCubit.onLoadDetail(
                                              id: widget.arguments.item);
                                        }
                                      });
                                    },
                                    funcName: Translate.of(context)
                                        .translate('confirm'),
                                  );
                                },
                                hasOperations: widget.arguments.hasOperations,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.orderDetails!.orderItems.length + 3,
                    )),
                  ),
              ],
            );
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                iconTheme: const IconThemeData(color: darkGrey),
                actions: const <Widget>[
                  // IconButton(
                  //   icon: Image.asset(Images.commercialInvoices),
                  //   onPressed: () {
                  //     Navigator.pushNamed(
                  //       context,
                  //       Routes.orderDetail,
                  //       arguments: widget.arguments,
                  //     );
                  //   },
                  //   // onPressed: () => Navigator.of(context)
                  //   //     .push(MaterialPageRoute(builder: (_) => UnpaidPage())),
                  // )
                ],
                title: Text(
                  '${Translate.of(context).translate('order_items')} - (${widget.arguments.item})',
                  style: const TextStyle(
                      color: darkGrey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0),
                ),
              ),
              body: LayoutBuilder(
                builder: (_, constraints) => SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: content),
                ),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: const IconThemeData(color: darkGrey),
              actions: const <Widget>[
                // IconButton(
                //   icon: Image.asset(Images.commercialInvoices),
                //   onPressed: () {
                //     Navigator.pushNamed(
                //       context,
                //       Routes.orderDetail,
                //       arguments: widget.arguments,
                //     );
                //   },
                //   // onPressed: () => Navigator.of(context)
                //   //     .push(MaterialPageRoute(builder: (_) => UnpaidPage())),
                // )
              ],
              title: Text(
                Translate.of(context).translate('order_items'),
                style: const TextStyle(
                    color: darkGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0),
              ),
            ),
            body: LayoutBuilder(
              builder: (_, constraints) => SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: content),
              ),
            ),
          );
        }));
  }
}
