import 'package:supermarket/app_properties.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/models/model_order.dart';
import 'package:supermarket/repository/repository.dart';
import 'package:supermarket/utils/other.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as strip;
import 'package:showcaseview/showcaseview.dart';

import '../../repository/location_repository.dart';

class CheckOut2 extends StatefulWidget {
  OrderModel order;
  CheckOut2({Key? key, required this.order}) : super(key: key);

  @override
  _CheckOut2State createState() => _CheckOut2State();
}

class _CheckOut2State extends State<CheckOut2> {
  SwiperController swiperController = SwiperController();
  bool loading = false;

  @override
  void initState() {
    widget.order.paymentMethod = PaymentType.cash;
    super.initState();
    _onRefresh();
  }

  ///On Onder
  Future<void> onOrder() async {
    if ((widget.order.isPaid == null || !widget.order.isPaid!) &&
        widget.order.paymentMethod != PaymentType.cash) {
      final isPaid = await onPay(
          widget.order.orderId,
          widget.order.amount,
          widget.order.orderItems
              .map((item) => '${item.name}-(${item.unitName})')
              .join(', '));
      if (isPaid != true) {
        if (isPaid == false) {
          AppBloc.messageCubit.onShow('فشلت عملية الدفع');
        } else {
          AppBloc.messageCubit.onShow('لم تتم عملية الدفع');
        }
        return;
      }
    }

    if (widget.order.latitude == '0.0') {
      await _onSelectAddress();
    }
    // if (!order.isPaid! && order.paymentMethod != PaymentType.cash) {
    //   final isPaid = await onPay(
    //       order.orderId,
    //       order.amount,
    //       order.orderItems
    //           .map((item) => '${item.name}-(${item.unitName})')
    //           .join(', '));
    //   if (isPaid != true) {
    //     if (isPaid == false) {
    //       AppBloc.messageCubit.onShow('فشلت عملية الدفع');
    //     } else {
    //       AppBloc.messageCubit.onShow('لم تتم عملية الدفع');
    //     }
    //     return;
    //   }
    // }

    if (widget.order.latitude != '0.0') {
      if (widget.order.paymentMethod == PaymentType.cash) {
        OrderRepository.confirmOrderByCash(1).then((value) {
          if (value) {
            Navigator.of(context)
                .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
            Navigator.pushNamed(context, Routes.orderList);
          }
        });
      } else if (widget.order.paymentMethod == PaymentType.creditCard) {
        await makePayment();
      }
    }
  }

  Future<bool?> onPay(int orderId, double amount, String unitName) async {
    var ff = await Navigator.pushNamed(context, Routes.payment, arguments: {
      'orderId': orderId,
      'amount': amount,
      'unitName': unitName
    });
    if (ff is bool) return ff;
    return false;
  }

  ///On Refresh Check Out
  Future<void> _onRefresh() async {}

  @override
  void dispose() {
    swiperController.dispose();
    super.dispose();
  }

  calculateAmount(String amount) {
    final calculatedAmout = double.parse(amount);
    return calculatedAmout.toString();
  }

  createPaymentIntent() async {
    try {
      return await PaymentRepository.createPaymentIntent(
          paymentType: 'order', id: 1, paymentMethodType: 'card');
    } catch (err) {
      //// ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  Future<void> makePayment() async {
    try {
      // final clientSecret = await createPaymentIntent('66', 'USD');
      final clientSecret = await createPaymentIntent();
      // paymentIntent = await createPaymentIntent('10', 'USD');
      //Payment Sheet
      await strip.Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: strip.SetupPaymentSheetParameters(
                  paymentIntentClientSecret: clientSecret,
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Adnan'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await strip.Stripe.instance.presentPaymentSheet().then((value) async {
        Navigator.of(context)
            .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
        Navigator.pushNamed(context, Routes.orderList);
      }).onError((error, stackTrace) {});
    } on strip.StripeException catch (e) {
    } catch (e) {
      print('$e');
    }
  }

  ///Select Address
  Future<void> _onSelectAddress() async {
    loading = true;
    setState(() {});
    final list = await AddressRepository.loadAllAddresses() ?? [];
    loading = false;
    setState(() {});
    final result = await showModalBottomSheet<AddressModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => AppBottomPicker(
        picker: PickerModel(
          selected: [null],
          data: list,
        ),
        // hasScroll: true,
      ),
    );
    if (result != null) {
      widget.order.addressType = result.type;
      widget.order.street = result.address;
      widget.order.latitude = result.latitude;
      widget.order.longitude = result.longitude;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    List<Widget> list = [];

    list = [];
    actions.add(IconButton(
      icon: Image.asset(Images.moreDetails),
      onPressed: () {
        Navigator.pushNamed(
          context,
          Routes.orderItemList,
          arguments: RouteArguments(hasOperations: false, item: 1),
        ).then((value) {
          // orderListCubit.onLoadCheckOut(orderId: widget.id);
        });
      },
    ));
    Widget trailingWidget = const Icon(Icons.arrow_drop_down);
    if (loading) {
      trailingWidget = const Padding(
        padding: EdgeInsets.all(4),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      );
    }

    list.add(
      Padding(
        padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              Translate.of(context).translate('the_address'),
              style: const TextStyle(
                  fontSize: 15, color: darkGrey, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );

    list.add(Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          // boxShadow: smallShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextButton(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order.street ?? '',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          Translate.of(context).translate(
                            "${widget.order.addressType.name == 'home' ? '_home' : widget.order.addressType.name}",
                          ),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .foregroundColor),
                        ),
                      ),
                      trailingWidget,
                    ],
                  ),
                ]),
            onPressed: () {
              _onSelectAddress();
            },
          ),
        ),
      ),
    ));

    list.add(const SizedBox(height: 16));
    list.add(const Divider());
    for (var item in widget.order.orderItems) {
      list.add(CheckOutItem(
        item,
        onChangeQuantity: (int quantity) {
          item.quantity = quantity;
        },
        onRemove: () {
          UtilOther.showMessage(
            context: context,
            title: Translate.of(context).translate('_confirm'),
            message: Translate.of(context).translate(
                'confirm_the_removal_of_the_product_from_the_shopping_cart'),
            func: () {
              Navigator.pop(context);
              // orderListCubit
              //     .onCancelItem(item.orderId, item.id)
              //     .then((value) {
              //   orderListCubit.onLoadCheckOut(orderId: widget.id);
              // });
            },
            funcName: Translate.of(context).translate('confirm'),
          );
        },
        onComplaint: () {},
        onReturn: () {},
      ));
    }
    list.add(const SizedBox(height: 16));
    list.add(const Divider());
    list.add(
      Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Container(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'تفاصيل الفاتورة',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.order.total + widget.order.discount} ر.س',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الفاتورة',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.order.discount.toString()} ر.س',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'اجمالي الخصم',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.order.total} ر.س',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.red, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الاجمالي',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    list.add(const SizedBox(height: 16));
    list.add(Padding(
      padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          // boxShadow: smallShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                Translate.of(context).translate('payment_method'),
                style: const TextStyle(
                    fontSize: 15, color: darkGrey, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ));
    list.add(SizedBox(
      height: 150,
      child: Swiper(
          index: widget.order.paymentMethod.index,
          itemCount: 3,
          itemBuilder: (_, index) {
            if (index == 0) {
              return Stack(
                children: [
                  const PaymentCard(PaymentType.cash),
                  if (widget.order.paymentMethod == PaymentType.cash) ...[
                    Positioned(
                      left: AppLanguage.isRTL() ? null : 5,
                      right: AppLanguage.isRTL() ? 5 : null,
                      top: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ] else
                    Container()
                ],
              );
            } else if (index == 1) {
              return Stack(
                children: [
                  const PaymentCard(PaymentType.creditCard),
                  if (widget.order.paymentMethod == PaymentType.creditCard) ...[
                    Positioned(
                      left: AppLanguage.isRTL() ? null : 5,
                      right: AppLanguage.isRTL() ? 5 : null,
                      top: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ] else
                    Container()
                ],
              );
            } else {
              return Stack(
                children: [
                  const PaymentCard(PaymentType.paypal),
                  if (widget.order.paymentMethod == PaymentType.paypal) ...[
                    Positioned(
                      left: AppLanguage.isRTL() ? null : 5,
                      right: AppLanguage.isRTL() ? 5 : null,
                      top: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ] else
                    Container()
                ],
              );
            }
          },
          scale: 0.8,
          controller: swiperController,
          viewportFraction: 0.6,
          loop: false,
          fade: 0.7,
          onIndexChanged: (index) {
            widget.order.paymentMethod = PaymentType.values[index];
            setState(() {});
          }),
    ));
    list.add(const SizedBox(height: 30));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: darkGrey),
        actions: actions,
        title: Text(
          Translate.of(context).translate('_check_out'),
          style: const TextStyle(
              color: darkGrey, fontWeight: FontWeight.w500, fontSize: 18.0),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) => SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(children: list),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
        // foregroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () {
          onOrder();
        },
        icon: widget.order.paymentMethod == PaymentType.cash
            ? const Icon(Icons.check)
            : Image.asset(Images.pay),
        label: Text(
          Translate.of(context).translate(
              widget.order.paymentMethod == PaymentType.cash
                  ? 'confirm'
                  : 'payment'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
