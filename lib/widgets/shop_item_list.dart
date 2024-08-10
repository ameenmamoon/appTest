import 'package:supermarket/app_properties.dart';
import 'package:supermarket/blocs/app_bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/language.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/widgets/color_list.dart';
import 'package:supermarket/widgets/shop_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:showcaseview/showcaseview.dart';
import '../configs/application.dart';

class ShopItemList extends StatefulWidget {
  final OrderItemModel orderItem;
  final bool isShowCase;
  final Function(int) onChangeQuantity;
  final VoidCallback onRemove;
  final Function()? onChangeUnit;
  final Function(OrderItemModel orderItem)? onUpdateItem;

  ShopItemList(
    this.orderItem, {
    Key? key,
    required this.isShowCase,
    required this.onChangeQuantity,
    required this.onChangeUnit,
    required this.onUpdateItem,
    required this.onRemove,
  }) : super(key: key);

  @override
  _ShopItemListState createState() => _ShopItemListState();
}

class _ShopItemListState extends State<ShopItemList> {
  final ValueNotifier<bool> _selectedUnit = ValueNotifier<bool>(false);
  int _quantity = 1;
  @override
  void initState() {
    super.initState();
  }

  Future<void> onSelectUnits() async {
    final result = (await widget.onChangeUnit!()) as int?;
    if (result == null) return;

    if (widget.orderItem.unitId != result) {
      var unit =
          widget.orderItem.productUnits!.singleWhere((e) => e.unitId == result);
      widget.orderItem.unitId = unit.unitId;
      widget.orderItem.unitName = unit.name;
      widget.orderItem.price =
          unit.priceAfterDiscount != 0 ? unit.priceAfterDiscount : unit.price;
      widget.orderItem.total =
          widget.orderItem.price * widget.orderItem.quantity;
    }
    widget.onUpdateItem!(widget.orderItem);
    _selectedUnit.value = !_selectedUnit.value;
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
              icon: Icons.cancel,
              label: Translate.of(context).translate('remove'),
            ),
          ],
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: _selectedUnit,
          builder: (context, value, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: shadow,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child:
                  //  ExpansionTile(
                  //   tilePadding: EdgeInsets.only(
                  //       left: AppLanguage.isRTL() ? 10 : 0,
                  //       right: AppLanguage.isRTL() ? 0 : 10),
                  //   title:
                  Padding(
                padding:
                    const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          if (widget.orderItem.productId != null)
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                  left: AppLanguage.isRTL() ? 10 : 5,
                                  right: AppLanguage.isRTL() ? 5 : 10),
                              child: CachedNetworkImage(
                                imageUrl: Application.domain +
                                    widget.orderItem.image!
                                        .replaceAll("\\", "/")
                                        .replaceAll("TYPE", "full"),
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: InkWell(
                                                onTap: () {
                                                  onSelectUnits();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 156, 156, 156),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  ),
                                                  child: Text(
                                                    widget.orderItem.unitName ??
                                                        '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.orderItem.name,
                                  textAlign: AppLanguage.isRTL()
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: darkGrey,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Align(
                                  alignment: AppLanguage.isRTL()
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Translate.of(context)
                                                  .translate('price'),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${widget.orderItem.unitPrice.toString()} ر.س',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: darkGrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Translate.of(context)
                                                  .translate('subtotal'),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${widget.orderItem.unitPrice * _quantity} ر.س',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: darkGrey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                      // constraints: const BoxConstraints(maxHeight: 200),
                      child: NumberPicker(
                        itemHeight: 30,
                        itemWidth: 30,
                        value: widget.orderItem.quantity ?? 1,
                        minValue: 1,
                        maxValue: 100,
                        onChanged: (value) {
                          setState(() {
                            _quantity = value;
                            widget.onChangeQuantity(value);
                            widget.orderItem.quantity = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: content,
    );
  }
}
