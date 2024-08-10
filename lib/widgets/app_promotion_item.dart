import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/list_repository.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

import '../configs/application.dart';

class AppPromotionItem extends StatelessWidget {
  final PromotionModel? item;
  final Function()? checkAuthentication;

  AppPromotionItem({
    Key? key,
    this.item,
    this.checkAuthentication,
  }) : super(key: key);

  final ValueNotifier<bool> _elementUpdate = ValueNotifier<bool>(false);

  Future<void> addOrDeleteShoppingCart() async {
    final result = await checkAuthentication!();
    if (result == null) return;
    if (Application.shoppingCartsPromotions
        .any((element) => element == item!.id)) {
      ListRepository.removePromotionShoppingCart(promotionId: item!.id);
      // Application.shoppingCartsPromotions
      //     .removeWhere((element) => element == item!.id);
    } else {
      ListRepository.addPromotionToShoppingCart(promotionId: item!.id);
      // Application.shoppingCartsPromotions.add(item!.id);
    }
    _elementUpdate.value = !_elementUpdate.value;
  }

  @override
  Widget build(BuildContext context) {
    if (item != null) {
      return ValueListenableBuilder<bool>(
        valueListenable: _elementUpdate,
        builder: (context, value, child) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(width: 16),
                  Container(
                    // width: 40,
                    // height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        // color: Colors.amber, //item!.category.color,
                        border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Theme.of(context).dividerColor,
                      ),
                    )),
                    // child: const Icon(
                    //   CupertinoIcons.gift,
                    //   size: 2,
                    //   color: Color.fromARGB(255, 255, 255, 255),
                    // ),
                    // child: const FaIcon(
                    //   CupertinoIcons.gift,
                    //   size: 18,
                    //   color: Colors.white,
                    // ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item!.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${586} باقي من المنتجات تحتوي على اجبان وزيت وزيتون وزعتر وسمسم وصلصة وعصائر باقي من المنتجات تحتوي على اجبان وزيت وزيتون وزعتر وسمسم وصلصة وعصائر',
                          // '${item!.category.count} ${Translate.of(context).translate('locations')}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      addOrDeleteShoppingCart();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Application.shoppingCartsPromotions
                                .any((element) => element == item!.id)
                            ? const Color.fromARGB(255, 235, 21, 57)
                            : const Color.fromARGB(255, 72, 202, 115),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Icon(
                        Application.shoppingCartsPromotions
                                .any((element) => element == item!.id)
                            ? CupertinoIcons.cart_fill_badge_minus
                            : CupertinoIcons.cart_badge_plus,
                        size: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     onSeeMore!(item!);
                  //   },
                  //   child: Text(
                  //     Translate.of(context).translate('see_more'),
                  //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //           color: Theme.of(context).colorScheme.secondary,
                  //         ),
                  //   ),
                  // ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemBuilder: (context, index) {
                    final product = item!.products?[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AppProductItem(
                        promotionProduct: product,
                        type: ProductViewType.card,
                        onSetState: () {},
                      ),
                    );
                  },
                  itemCount: item!.products?.length,
                ),
              ),
            ],
          );
        },
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppPlaceholder(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 8,
                  width: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppProductItem(
                  type: ProductViewType.card,
                  onSetState: () {},
                ),
              );
            },
            itemCount: List.generate(8, (index) => index).length,
          ),
        ),
      ],
    );
  }
}
