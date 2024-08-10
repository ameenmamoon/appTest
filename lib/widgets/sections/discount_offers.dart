import 'dart:convert';
import 'dart:math';

import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/widgets/app_tag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/model_filter.dart';
import '../../models/model_home_section.dart';
import '../../models/model_product.dart';
import 'package:supermarket/widgets/app_placeholder.dart';
import '../../repository/list_repository.dart';
import '../../utils/other.dart';

class DiscountOffers extends StatefulWidget {
  final HomeSectionModel section;

  const DiscountOffers({Key? key, required this.section}) : super(key: key);

  @override
  _DiscountOffersState createState() => _DiscountOffersState();
}

class _DiscountOffersState extends State<DiscountOffers>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<int> discountOffers = [];
  List<dynamic>? _cachedData;

  @override
  Widget build(BuildContext context) {
    final listString = widget.section.extendedAttributes!
            .any((element) => element.key == 'list')
        ? widget.section.extendedAttributes!
            .firstWhere((element) => element.key == 'list')
            .json
        : null;
    final list = listString != null ? jsonDecode(listString) : [];
    discountOffers = [];
    if (list != null) {
      for (var item in list) {
        discountOffers.add(item['ProductId']);
      }
    } else {
      return Container();
    }
    list?.sort((a, b) {
      int priorityA = int.tryParse(a['Priority'].toString()) ?? 0;
      int priorityB = int.tryParse(b['Priority'].toString()) ?? 0;
      return priorityA.compareTo(priorityB);
    });

    Random random = Random();
    return FutureBuilder<List<dynamic>?>(
        key: Key(random.nextInt(999999999).toString()),
        initialData: [_cachedData],
        future: _cachedData == null
            ? ListRepository.loadList(
                pageNumber: 1,
                pageSize: list.length,
                filter: FilterModel(containsList: discountOffers))
            : Future.value([_cachedData]),

        /// Adding data by updateDataSource method
        builder: (BuildContext futureContext,
            AsyncSnapshot<List<dynamic>?> snapShot) {
          if (snapShot.connectionState != ConnectionState.done &&
              (_cachedData == null || _cachedData!.isEmpty)) {
            return Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: discountOffers.length,
                itemBuilder: (context, index) {
                  return const DiscountOfferCard();
                },
              ),
            );
          }
          if (snapShot.data == null && _cachedData == null) return Container();
          if (_cachedData == null && snapShot.data?[0] != null) {
            _cachedData = snapShot.data![0];
          }
          List<ProductModel> data = [];
          for (var item in list) {
            if ((snapShot.data![0] as List<ProductModel>)
                .any((e) => e.id == item['ProductId'])) {
              data.add((snapShot.data![0] as List<ProductModel>)
                  .firstWhere((e) => e.id == item['ProductId']));
            }
          }
          return Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                // data.any((element) => element.id == )
                return DiscountOfferCard(product: data[index]);
              },
            ),
          );
        });
  }
}

class DiscountOfferCard extends StatelessWidget {
  final ProductModel? product;

  const DiscountOfferCard({this.product});

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Container(
        width: 200,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppPlaceholder(
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AppPlaceholder(
                child: Container(
                  width: double.infinity,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AppPlaceholder(
                child: Container(
                  width: double.infinity,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.all(8),
      // width: 150,
      constraints: BoxConstraints(maxWidth: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          UtilOther.ShowProduct(
              context: context,
              productId: product!.id,
              categoryId: product!.categoryId);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                // child: Image.network(
                //   product!.image
                //       .replaceAll('TYPE', 'full')
                //       .replaceAll('\\', '/'),
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                // ),
                child: CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: product!.image
                      .replaceAll('TYPE', 'full')
                      .replaceAll('\\', '/'),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              product!.statusText.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: AppTag(
                                        product!.statusText,
                                        type: TagType.status,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  ListRepository.addRemoveProductToWishList(
                                      productId: product!.id);
                                  AppBloc.wishListCubit.onLoad();
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    product!.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        '${product!.discount == null ? double.parse(product!.price) : (double.parse(product!.price) - double.parse(product!.price) * ((product!.discount! / 100)))} ر.س',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (product!.discount != null)
                        Text(
                          '${product!.price} ر.س',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
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
  }
}
