import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supermarket/blocs/authentication/cubit.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

import '../blocs/app_bloc.dart';
import '../configs/application.dart';
import '../configs/language.dart';
import '../repository/list_repository.dart';

class AppProductItem extends StatelessWidget {
  AppProductItem({
    Key? key,
    this.product,
    this.promotionProduct,
    this.onSelectUnits,
    this.onSetState,
    this.checkAuthentication,
    required this.type,
    this.trailing,
  }) : super(key: key);

  final ProductModel? product;
  final PromotionProductModel? promotionProduct;
  final ProductViewType type;
  final Function(ProductModel)? onSelectUnits;
  final Function()? onSetState;
  final Function({String? route})? checkAuthentication;
  final Widget? trailing;
  final ValueNotifier<bool> _selectedUnit = ValueNotifier<bool>(false);

  double calculateAutoscaleFontSize(
      String text, TextStyle style, double startFontSize, double maxWidth) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    var currentFontSize = startFontSize;

    for (var i = 0; i < 100; i++) {
      // limit max iterations to 100
      final nextFontSize = currentFontSize + 1;
      final nextTextStyle = style.copyWith(fontSize: nextFontSize);
      textPainter.text = TextSpan(text: text, style: nextTextStyle);
      textPainter.layout();
      if (textPainter.width >= maxWidth) {
        break;
      } else {
        currentFontSize = nextFontSize;
        // continue iteration
      }
    }

    return currentFontSize;
  }

  Future<void> _onSelectUnits() async {
    final result = (await onSelectUnits!(product!)) as int?;
    if (result == null) return;

    if (Application.shoppingCartProducts.any((element) =>
        (element[0] as int) == product!.id && (element[1] as int) != result)) {
      // Application.shoppingCartProducts
      //     .singleWhere((element) => element[0] == product.id)[1] = result.id;
      ListRepository.updateProductToShoppingCart(
          productId: product!.id, unitId: result);
    } else if (Application.shoppingCartProducts.any((element) =>
        (element[0] as int) == product!.id && (element[1] as int) == result)) {
      // Application.shoppingCartProducts.singleWhere((element) =>
      //         element[0] == product.id && element[1] == result.id)[1] =
      //     product.productUnits.first.id;
      ListRepository.updateProductToShoppingCart(
          productId: product!.id, unitId: product!.productUnits.first.id);
    } else if (!Application.shoppingCartProducts
        .any((element) => (element[0] as int) == product!.id)) {
      ListRepository.addProductToShoppingCart(
          productId: product!.id, unitId: result, isFavorite: false);
      // Application.shoppingCartProducts.add([product.id, result.id, false]);
    }
    _selectedUnit.value = !_selectedUnit.value;
  }

  String getUnitName() {
    return Application.shoppingCartProducts
            .any((element) => (element[0] as int) == product!.id)
        ? product!.productUnits
            .singleWhere((element) =>
                element.id ==
                Application.shoppingCartProducts
                        .singleWhere((element) => element[0] == product!.id)[1]
                    as int)
            .name
        : product!.productUnits.first.name;
  }

  Future<void> addOrDeleteShoppingCart() async {
    // final result = await checkAuthentication!(route: Routes.listProduct);
    // if (result == null) return;

    if (Application.shoppingCartProducts.any((element) =>
        (element[0] as int) == product!.id && (element[2] as bool) == true)) {
      // Application.shoppingCartProducts
      //     .removeWhere((element) => element[0] == item.id);
      ListRepository.removeProductShoppingCart(productId: product!.id);
    } else if (Application.shoppingCartProducts.any((element) =>
        (element[0] as int) == product!.id && (element[2] as bool) == false)) {
      ListRepository.updateProductToShoppingCart(
          productId: product!.id, isFavorite: true);
    } else {
      ListRepository.addProductToShoppingCart(
          productId: product!.id,
          unitId: product!.productUnits.first.unitId,
          isFavorite: true);
      // Application.shoppingCartProducts
      //     .add([item.id, item!.productUnits.first.id, true]);
    }
    _selectedUnit.value = !_selectedUnit.value;
    onSetState!();
  }

  Future<void> addRemoveProductToWishList() async {
    final result = await checkAuthentication!(route: Routes.listProduct);
    if (result == null) return;

    if (await ListRepository.addRemoveProductToWishList(
        productId: product!.id)) {
      _selectedUnit.value = !_selectedUnit.value;
      AppBloc.wishListCubit.onLoad();
    }
  }

  Widget getPrice(ProductModel product) {
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
    final List<Widget> rateWidget = <Widget>[
      AppTag(
        product == null ? "0.0" : "${product!.rate}",
        type: TagType.rate,
        color: Colors.amber,
      ),
      const SizedBox(width: 4),
      RatingBar.builder(
        initialRating: product == null ? 0.0 : product!.rate,
        minRating: 1,
        allowHalfRating: true,
        unratedColor: Colors.amber.withAlpha(100),
        itemCount: 5,
        itemSize: 14.0,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rate) {},
        ignoreGestures: true,
      ),
    ];

    switch (type) {
      ///Mode View Small
      case ProductViewType.small:
        if (product == null) {
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 180,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: product!.image.replaceAll("TYPE", "thumb"),
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
              placeholder: (context, url) {
                return AppPlaceholder(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    width: 80,
                    height: 100,
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return AppPlaceholder(
                  child: Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.error),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(width: 4),
                  Text(
                    product!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product?.categoryName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            trailing ?? Container()
          ],
        );

      ///Mode View Gird
      case ProductViewType.grid:
        if (product == null) {
          return AppPlaceholder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 24,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _selectedUnit,
            builder: (context, value, child) {
              return Column(
                children: [
                  Container(
                    height: 120,
                    child: CachedNetworkImage(
                      imageUrl:
                          product?.image.replaceAll("TYPE", "thumb") ?? '',
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: InkWell(
                                      onTap: () {
                                        _onSelectUnits();
                                        onSetState!();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 2,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 156, 156, 156),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        child: Text(
                                          getUnitName(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: InkWell(
                                      onTap: () {
                                        addOrDeleteShoppingCart();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Application
                                                  .shoppingCartProducts
                                                  .any((element) =>
                                                      (element[0] as int) ==
                                                          product!.id &&
                                                      (element[2] as bool) ==
                                                          true)
                                              ? const Color.fromARGB(
                                                  255, 235, 21, 57)
                                              : const Color.fromARGB(
                                                  255, 72, 202, 115),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                        ),
                                        child: Icon(
                                          Application.shoppingCartProducts.any(
                                                  (element) =>
                                                      (element[0] as int) ==
                                                          product!.id &&
                                                      (element[2] as bool) ==
                                                          true)
                                              ? CupertinoIcons
                                                  .cart_fill_badge_minus
                                              : CupertinoIcons.cart_badge_plus,
                                          size: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ) // item!.statusText.isNotEmpty
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      addRemoveProductToWishList();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        Application.wishListProducts
                                                .any((e) => e == product!.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return AppPlaceholder(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return AppPlaceholder(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product?.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product?.categoryName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: rateWidget,
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: getPrice(product!),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            });

      ///Mode View List
      case ProductViewType.list:
        if (product == null) {
          return AppPlaceholder(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 140,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 20,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _selectedUnit,
            builder: (context, value, child) {
              return Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: product!.image.replaceAll("TYPE", "thumb"),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: 100,
                            height: 140,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: InkWell(
                                        onTap: () {
                                          _onSelectUnits();
                                          onSetState!();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 156, 156, 156),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                          ),
                                          child: Text(
                                            getUnitName(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: InkWell(
                                        onTap: () {
                                          addOrDeleteShoppingCart();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Application
                                                    .shoppingCartProducts
                                                    .any((element) =>
                                                        (element[0] as int) ==
                                                            product!.id &&
                                                        (element[2] as bool) ==
                                                            true)
                                                ? const Color.fromARGB(
                                                    255, 235, 21, 57)
                                                : const Color.fromARGB(
                                                    255, 72, 202, 115),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                          ),
                                          child: Icon(
                                            Application.shoppingCartProducts
                                                    .any((element) =>
                                                        (element[0] as int) ==
                                                            product!.id &&
                                                        (element[2] as bool) ==
                                                            true)
                                                ? CupertinoIcons
                                                    .cart_fill_badge_minus
                                                : CupertinoIcons
                                                    .cart_badge_plus,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ) // item!.statusText.isNotEmpty
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        placeholder: (context, url) {
                          return AppPlaceholder(
                            child: Container(
                              width: 100,
                              height: 140,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return AppPlaceholder(
                            child: Container(
                              width: 100,
                              height: 140,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: const Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 8),
                            Text(
                              product?.categoryName ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: rateWidget,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "${product?.categoryName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            getPrice(product!),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (AppLanguage.isRTL())
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: InkWell(
                        onTap: () {
                          addRemoveProductToWishList();
                        },
                        child: Icon(
                          Application.wishListProducts
                                  .any((e) => e == product!.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  if (!AppLanguage.isRTL())
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          addRemoveProductToWishList();
                        },
                        child: Icon(
                          Application.wishListProducts
                                  .any((e) => e == product!.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                ],
              );
            });

      ///Mode View Block
      case ProductViewType.block:
        if (product == null) {
          return AppPlaceholder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _selectedUnit,
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: product!.image.replaceAll("TYPE", "full"),
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xff000000),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: InkWell(
                                    onTap: () {
                                      _onSelectUnits();
                                      onSetState!();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 156, 156, 156),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Text(
                                        getUnitName(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: InkWell(
                                    onTap: () {
                                      addOrDeleteShoppingCart();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Application.shoppingCartProducts
                                                .any((element) =>
                                                    (element[0] as int) ==
                                                        product!.id &&
                                                    (element[2] as bool) ==
                                                        true)
                                            ? const Color.fromARGB(
                                                255, 235, 21, 57)
                                            : const Color.fromARGB(
                                                255, 72, 202, 115),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      child: Icon(
                                        Application.shoppingCartProducts.any(
                                                (element) =>
                                                    (element[0] as int) ==
                                                        product!.id &&
                                                    (element[2] as bool) ==
                                                        true)
                                            ? CupertinoIcons
                                                .cart_fill_badge_minus
                                            : CupertinoIcons.cart_badge_plus,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ) // item!.statusText.isNotEmpty
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                getPrice(product!),
                                InkWell(
                                  onTap: () {
                                    addRemoveProductToWishList();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Application.wishListProducts
                                              .any((e) => e == product!.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        //  Column(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     Padding(
                        //       padding: const EdgeInsets.all(4),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           item!.statusText.isNotEmpty
                        //               ? AppTag(
                        //                   item!.statusText,
                        //                   type: TagType.status,
                        //                 )
                        //               : Container(),
                        //           Column(
                        //             children: [
                        //               Icon(
                        //                 item!.isAddedFavorite
                        //                     ? Icons.favorite
                        //                     : Icons.favorite_border,
                        //                 color: Colors.white,
                        //               )
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //     Padding(
                        //         padding: const EdgeInsets.all(4),
                        //         child: Column(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: <Widget>[
                        //               Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.spaceBetween,
                        //                 children: <Widget>[
                        //                   Container(
                        //                     padding: const EdgeInsets.all(4),
                        //                     decoration: BoxDecoration(
                        //                       color:
                        //                           Colors.white.withOpacity(0.5),
                        //                       borderRadius:
                        //                           BorderRadius.circular(8),
                        //                     ),
                        //                     child: getPrice(item!),
                        //                   ),
                        //                   Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: <Widget>[
                        //                       Row(
                        //                         children: <Widget>[
                        //                           AppTag(
                        //                             "${item!.rate}",
                        //                             type: TagType.rate,
                        //                           ),
                        //                           const SizedBox(width: 4),
                        //                           Column(
                        //                             crossAxisAlignment:
                        //                                 CrossAxisAlignment
                        //                                     .start,
                        //                             children: <Widget>[
                        //                               Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .only(left: 4),
                        //                                 child: Text(
                        //                                   Translate.of(context)
                        //                                       .translate(
                        //                                     'rate',
                        //                                   ),
                        //                                   style:
                        //                                       Theme.of(context)
                        //                                           .textTheme
                        //                                           .bodySmall!
                        //                                           .copyWith(
                        //                                             color: Colors
                        //                                                 .white,
                        //                                             fontWeight:
                        //                                                 FontWeight
                        //                                                     .bold,
                        //                                           ),
                        //                                 ),
                        //                               ),
                        //                               RatingBar.builder(
                        //                                 initialRating:
                        //                                     item!.rate,
                        //                                 minRating: 1,
                        //                                 allowHalfRating: true,
                        //                                 unratedColor: Colors
                        //                                     .amber
                        //                                     .withAlpha(100),
                        //                                 itemCount: 5,
                        //                                 itemSize: 14.0,
                        //                                 itemBuilder:
                        //                                     (context, _) =>
                        //                                         const Icon(
                        //                                   Icons.star,
                        //                                   color: Colors.amber,
                        //                                 ),
                        //                                 onRatingUpdate:
                        //                                     (rate) {},
                        //                                 ignoreGestures: true,
                        //                               ),
                        //                             ],
                        //                           )
                        //                         ],
                        //                       ),
                        //                       Text(
                        //                         "${item!.numRate} ${Translate.of(context).translate('feedback')}",
                        //                         style: Theme.of(context)
                        //                             .textTheme
                        //                             .bodySmall!
                        //                             .copyWith(
                        //                               color: Colors.white,
                        //                               fontWeight:
                        //                                   FontWeight.bold,
                        //                             ),
                        //                       )
                        //                     ],
                        //                   ),
                        //                 ],
                        //               ),
                        //             ]))
                        //   ],
                        // ),
                      );
                    },
                    placeholder: (context, url) {
                      return AppPlaceholder(
                        child: Container(
                          height: 200,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return AppPlaceholder(
                        child: Container(
                          height: 200,
                          color: Colors.white,
                          child: const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 8),
                        Text(
                          product?.categoryName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product!.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            });

      ///Case View Card small
      case ProductViewType.card:
        if (product == null && promotionProduct == null) {
          return SizedBox(
            width: 110,
            child: AppPlaceholder(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        } else if (promotionProduct == null) {
          return ValueListenableBuilder<bool>(
              valueListenable: _selectedUnit,
              builder: (context, value, child) {
                return SizedBox(
                  width: 110,
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.all(0),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  product!.image.replaceAll("TYPE", "thumb"),
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
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
                                                _onSelectUnits();
                                                onSetState!();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 2,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 156, 156, 156),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                ),
                                                child: Text(
                                                  getUnitName(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: InkWell(
                                              onTap: () {
                                                addOrDeleteShoppingCart();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Application
                                                          .shoppingCartProducts
                                                          .any((element) =>
                                                              (element[0]
                                                                      as int) ==
                                                                  product!.id &&
                                                              (element[2]
                                                                      as bool) ==
                                                                  true)
                                                      ? const Color.fromARGB(
                                                          255, 235, 21, 57)
                                                      : const Color.fromARGB(
                                                          255, 72, 202, 115),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4)),
                                                ),
                                                child: Icon(
                                                  Application
                                                          .shoppingCartProducts
                                                          .any((element) =>
                                                              (element[0]
                                                                      as int) ==
                                                                  product!.id &&
                                                              (element[2]
                                                                      as bool) ==
                                                                  true)
                                                      ? CupertinoIcons
                                                          .cart_fill_badge_minus
                                                      : CupertinoIcons
                                                          .cart_badge_plus,
                                                  size: 22,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ) // item!.statusText.isNotEmpty
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              addRemoveProductToWishList();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Icon(
                                                Application.wishListProducts
                                                        .any((e) =>
                                                            e == product!.id)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              placeholder: (context, url) {
                                return AppPlaceholder(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return AppPlaceholder(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: const Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            product!.name,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        } else {
          return ValueListenableBuilder<bool>(
              valueListenable: _selectedUnit,
              builder: (context, value, child) {
                return SizedBox(
                  width: 110,
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.all(0),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: Application.domain +
                                  (promotionProduct!.image != null
                                      ? promotionProduct!.image!
                                          .replaceAll("\\", "/")
                                          .replaceAll("TYPE", "full")
                                      : ''),
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) {
                                return AppPlaceholder(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return AppPlaceholder(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: const Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            promotionProduct!.productName,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        }
      default:
        return Container(width: 160.0);
    }
  }
}
