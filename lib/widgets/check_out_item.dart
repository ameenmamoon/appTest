import 'package:supermarket/app_properties.dart';
import 'package:supermarket/configs/language.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/widgets/color_list.dart';
import 'package:supermarket/widgets/shop_product.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:showcaseview/showcaseview.dart';
import '../blocs/app_bloc.dart';
import '../configs/application.dart';
import '../configs/config.dart';

class CheckOutItem extends StatefulWidget {
  final OrderItemModel orderItem;
  final bool hasOperations;
  final Function(int) onChangeQuantity;
  final VoidCallback onRemove;
  final VoidCallback onReturn;
  final VoidCallback onComplaint;

  const CheckOutItem(this.orderItem,
      {Key? key,
      required this.onChangeQuantity,
      required this.onRemove,
      required this.onReturn,
      required this.onComplaint,
      this.hasOperations = true})
      : super(key: key);

  @override
  _CheckOutItemState createState() => _CheckOutItemState();
}

class _CheckOutItemState extends State<CheckOutItem> {
  @override
  void initState() {
    super.initState();
  }

  Widget getPrice() {
    double price = 0;
    double priceAfterDiscount = 0;

    price = widget.orderItem.price + (widget.orderItem.discount ?? 0);
    priceAfterDiscount =
        widget.orderItem.price - (widget.orderItem.discount ?? 0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              '${priceAfterDiscount == price ? price : priceAfterDiscount} ر.س',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            if (priceAfterDiscount != price && priceAfterDiscount != 0)
              Text(
                '$price ر.س',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Slidable(
      key: ValueKey(widget.orderItem.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (BuildContext? buildContext) {
              widget.onRemove();
              setState(() {});
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.cancel_outlined,
            label: Translate.of(context).translate('cancel'),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: shadow,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: widget.orderItem.promotionId == null
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.orderItem.promotionId == null)
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
                  top: widget.orderItem.promotionId == null ? 12.0 : 10,
                  bottom: widget.orderItem.promotionId == null ? 0 : 10,
                  right: AppLanguage.isRTL() ? 10 : 10,
                  left: AppLanguage.isRTL() ? 10 : 10),
              width: widget.orderItem.promotionId == null
                  ? MediaQuery.of(context).size.width * 0.4
                  : MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: widget.orderItem.promotionId == null
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
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
                  const SizedBox(height: 4),
                  if (widget.orderItem.promotionId != null) ...[
                    const Divider(),
                    const SizedBox(height: 4),
                  ],
                  getPrice(),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              '${Translate.of(context).translate('quantity')}: ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              widget.orderItem.quantity.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              '${Translate.of(context).translate('unit')}: ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              widget.orderItem.unitName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${Translate.of(context).translate('total')}: ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${widget.orderItem.total.toString()} ر.س',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Align(
        alignment: Alignment(
            AppLanguage.isRTL() ? 0.4 : 0, AppLanguage.isRTL() ? 0 : 0.4),
        child: content,
      ),
    );
  }
}
