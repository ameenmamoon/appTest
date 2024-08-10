import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/widgets/app_product_item.dart';
import 'package:supermarket/widgets/app_tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/widgets/widget.dart';
import '../../blocs/app_bloc.dart';
import '../../blocs/authentication/authentication_state.dart';
import '../../configs/application.dart';
import '../../models/model_filter.dart';
import '../../models/model_home_section.dart';
import 'package:supermarket/widgets/app_placeholder.dart';
import '../../repository/list_repository.dart';
import '../../utils/other.dart';

class FeaturedOffers extends StatefulWidget {
  final String image;
  final List<ProductModel> list;
  final Function() onSetState;

  const FeaturedOffers(
      {Key? key,
      required this.image,
      required this.list,
      required this.onSetState})
      : super(key: key);

  @override
  _FeaturedOffersState createState() => _FeaturedOffersState();
}

class _FeaturedOffersState extends State<FeaturedOffers>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<int> featureOffers = [];

  Future<void> _onSelectUnits(ProductModel product) async {
    final result = await showModalBottomSheet<ProductUnitModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => AppBottomPicker(
        picker: PickerModel(
          selected: [
            product.productUnits.where((element) => element.isSelected)
          ],
          data: product.productUnits,
        ),
        // hasScroll: true,
      ),
    );
    setState(() {
      if (result != null &&
          Application.shoppingCartProducts.any((element) =>
              (element[0] as int) == product.id &&
              (element[1] as int) != result.id)) {
        // Application.shoppingCartProducts
        //     .singleWhere((element) => element[0] == product.id)[1] = result.id;
        ListRepository.updateProductToShoppingCart(
            productId: product.id, unitId: result.id);
      } else if (result != null &&
          Application.shoppingCartProducts.any((element) =>
              (element[0] as int) == product.id &&
              (element[1] as int) == result.id)) {
        // Application.shoppingCartProducts.singleWhere((element) =>
        //         element[0] == product.id && element[1] == result.id)[1] =
        //     product.productUnits.first.id;
        ListRepository.updateProductToShoppingCart(
            productId: product.id, unitId: product.productUnits.first.id);
      } else if (result != null &&
          !Application.shoppingCartProducts
              .any((element) => (element[0] as int) == product.id)) {
        ListRepository.addProductToShoppingCart(
            productId: product.id, unitId: result.unitId, isFavorite: false);
        // Application.shoppingCartProducts.add([product.id, result.id, false]);
      }
    });
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          '${priceAfterDiscount == price ? price : priceAfterDiscount} ر.س',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        if (product.productUnits.first.price !=
                product.productUnits.first.priceAfterDiscount &&
            product.productUnits.first.priceAfterDiscount != 0)
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
    );
  }

  String getUnitName(ProductModel item) {
    return Application.shoppingCartProducts
            .any((element) => (element[0] as int) == item!.id)
        ? item!.productUnits
            .singleWhere((element) =>
                element.id ==
                Application.shoppingCartProducts
                    .singleWhere((element) => element[0] == item!.id)[1] as int)
            .name
        : item!.productUnits.first.name;
  }

  Future<String?> checkAuthentication() async {
    if (AppBloc.authenticateCubit.state == AuthenticationState.fail) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: '/',
      );
      return result as String?;
    } else if (AppBloc.authenticateCubit.state == AuthenticationState.success) {
      return '/';
    }
    return null;
  }

  Future<void> addOrDeleteShoppingCart(ProductModel item) async {
    // final result = await checkAuthentication();
    // if (result == null) return;
    setState(() {
      if (Application.shoppingCartProducts.any((element) =>
          (element[0] as int) == item!.id && (element[2] as bool) == true)) {
        // Application.shoppingCartProducts
        //     .removeWhere((element) => element[0] == item.id);
        ListRepository.removeProductShoppingCart(productId: item.id);
      } else if (Application.shoppingCartProducts.any((element) =>
          (element[0] as int) == item!.id && (element[2] as bool) == false)) {
        // Application.shoppingCartProducts.singleWhere((element) =>
        //     (element[0] as int) == item!.id &&
        //     (element[2] as bool) == false)[2] = true;
        ListRepository.updateProductToShoppingCart(
            productId: item.id, isFavorite: true);
      } else {
        ListRepository.addProductToShoppingCart(
            productId: item.id,
            unitId: item.productUnits.first.unitId,
            isFavorite: true);
        // Application.shoppingCartProducts
        //     .add([item.id, item!.productUnits.first.id, true]);
      }
    });
  }

  Future<void> addRemoveProductToWishList(int productId) async {
    final result = await checkAuthentication();
    if (result == null) return;

    setState(() {
      ListRepository.addRemoveProductToWishList(productId: productId);
    });
    AppBloc.wishListCubit.onLoad();
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    return Container(
      key: Key(random.nextInt(999999999).toString()),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.image,
                imageBuilder: (context, imageProvider) {
                  return Image(
                    image: imageProvider,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // height: 150,
                  );
                },
                placeholder: (context, url) {
                  return AppPlaceholder(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return AppPlaceholder(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                      ),
                      child: const Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (widget.list.isNotEmpty)
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (widget.list.isEmpty) {
                  return Container();
                }

                return Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: CachedNetworkImage(
                        imageUrl:
                            widget.list[index].image.replaceAll('\\', '/'),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 120,
                            width: double.infinity,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: InkWell(
                                        onTap: () async {
                                          _onSelectUnits(widget.list[index]);
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
                                            getUnitName(widget.list[index]),
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
                                          addOrDeleteShoppingCart(
                                              widget.list[index]);
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
                                                            widget.list[index]
                                                                .id &&
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
                                                            widget.list[index]
                                                                .id &&
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
                                    ) // widget.list[index].statusText.isNotEmpty
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        addRemoveProductToWishList(
                                            widget.list[index].id);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Application.wishListProducts.any(
                                                  (e) =>
                                                      e ==
                                                      widget.list[index].id)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        placeholder: (context, url) {
                          return AppPlaceholder(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return AppPlaceholder(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                              ),
                              child: const Icon(Icons.error),
                            ),
                          );
                        },
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              widget.list[index].name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            getPrice(widget.list[index]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
