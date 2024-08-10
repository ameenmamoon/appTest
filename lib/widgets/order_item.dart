import 'package:supermarket/app_properties.dart';
import 'package:supermarket/configs/language.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/widgets/color_list.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import '../blocs/app_bloc.dart';
import '../configs/application.dart';
import '../configs/config.dart';

class OrderItem extends StatefulWidget {
  final OrderItemModel orderItem;
  late OrderStatus? status = OrderStatus.waiting;
  final bool hasOperations;
  final Function(int) onChangeQuantity;
  final VoidCallback onShippingFeedback;
  final VoidCallback onReceipt;
  final VoidCallback onRemove;

  OrderItem(this.orderItem,
      {Key? key,
      this.status,
      required this.onChangeQuantity,
      required this.onShippingFeedback,
      required this.onReceipt,
      required this.onRemove,
      this.hasOperations = true})
      : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  void initState() {
    super.initState();
  }

  dynamic getPrice(ProductModel product) {
    double price = 0;
    double priceAfterDiscount = 0;

    if (Application.shoppingCartProducts
        .any((element) => (element[0] as int) == product.id)) {
      priceAfterDiscount = product.productUnits
          .singleWhere((element) =>
              element.id ==
              (Application.shoppingCartProducts.singleWhere(
                  (element) => (element[0] as int) == product.id)[1] as int))
          .priceAfterDiscount;
      price = product.productUnits
          .singleWhere((element) =>
              element.id ==
              (Application.shoppingCartProducts.singleWhere(
                  (element) => (element[0] as int) == product.id)[1] as int))
          .price;
      price = priceAfterDiscount != 0 && priceAfterDiscount != price
          ? priceAfterDiscount
          : price;
    } else {
      price = product.productUnits.first.priceAfterDiscount != 0 &&
              product.productUnits.first.priceAfterDiscount !=
                  product.productUnits.first.price
          ? product.productUnits.first.priceAfterDiscount
          : product.productUnits.first.price;
    }

    return {price: price, priceAfterDiscount: priceAfterDiscount};
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: shadow,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.only(
            left: AppLanguage.isRTL() ? 10 : 0,
            right: AppLanguage.isRTL() ? 0 : 10),
        title: Row(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: CachedNetworkImage(
                imageUrl: Application.domain +
                    widget.orderItem.image!
                        .replaceAll("\\", "/")
                        .replaceAll("TYPE", "full"),
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                color: Colors.transparent,
                colorBlendMode: BlendMode.color,
                filterQuality: FilterQuality.high,
                width: 80,
                height: 80,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 12.0,
                  right: AppLanguage.isRTL() ? 8 : 12.0,
                  left: AppLanguage.isRTL() ? 12.0 : 8),
              width: MediaQuery.of(context).size.width * .55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.orderItem.name,
                    textAlign:
                        AppLanguage.isRTL() ? TextAlign.right : TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: darkGrey,
                    ),
                  ),

                  Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: InkWell(
                          hoverColor: Colors.amber,
                          onTap: () {
                            AppBloc.messageCubit.onShow(
                                'dear_customer_if_you_find_violation_of_the_policy_from_the_seller_please_file_complaint');
                          },
                          child: Text(
                            Translate.of(context)
                                .translate('refusal_to_refund'),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            Translate.of(context).translate('quantity'),
                            textAlign: AppLanguage.isRTL()
                                ? TextAlign.right
                                : TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: darkGrey,
                            ),
                          ),
                          Text(
                            widget.orderItem.name,
                            textAlign: AppLanguage.isRTL()
                                ? TextAlign.right
                                : TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: darkGrey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            Translate.of(context)
                                .translate('quantity_available'),
                            textAlign: AppLanguage.isRTL()
                                ? TextAlign.right
                                : TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            widget.orderItem.quantityAvailable.toString(),
                            textAlign: AppLanguage.isRTL()
                                ? TextAlign.right
                                : TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  // ],) ,
                ],
              ),
            ),
          ],
        ),
        children: <Widget>[
          const Divider(),
          const SizedBox(height: 8),
          Text(
            Translate.of(context).translate('quantity'),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            widget.orderItem.quantity.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            Translate.of(context).translate('price'),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Text(
            '${widget.orderItem.total.toString()} ر.س',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          if (widget.status == OrderStatus.waiting)
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(
                      MediaQuery.of(context).size.width * 0.5, double.infinity),
                ),
              ),
              onPressed: () {
                widget.onRemove();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cancel_outlined),
                  const SizedBox(width: 4),
                  Text(Translate.of(context).translate('cancel')),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
        // ],
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: Align(
        alignment: Alignment(
            AppLanguage.isRTL() ? 0.4 : 0, AppLanguage.isRTL() ? 0 : 0.4),
        child: content,
      ),
    );
  }
}
