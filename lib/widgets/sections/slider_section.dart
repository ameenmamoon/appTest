import 'dart:convert';
import 'dart:math';

import 'package:supermarket/models/model.dart';
import 'package:supermarket/widgets/app_product_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../configs/application.dart';
import '../../configs/routes.dart';
import '../../models/model_filter.dart';
import '../../models/model_home_section.dart';
import 'package:supermarket/widgets/app_placeholder.dart';
import '../../repository/list_repository.dart';
import '../../utils/other.dart';
import '../../utils/translate.dart';

class SliderSection extends StatefulWidget {
  final HomeSectionModel section;

  const SliderSection({Key? key, required this.section}) : super(key: key);

  @override
  _SliderSectionState createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final listString = widget.section.extendedAttributes!
            .any((element) => element.key == 'list')
        ? widget.section.extendedAttributes!
            .firstWhere((element) => element.key == 'list')
            .json
        : null;
    final list = listString != null ? jsonDecode(listString) : [];
    list?.sort((a, b) {
      int priorityA = int.tryParse(a['Priority'].toString()) ?? 0;
      int priorityB = int.tryParse(b['Priority'].toString()) ?? 0;
      return priorityA.compareTo(priorityB);
    });

    Random random = Random();
    return CarouselSlider(
      key: Key(random.nextInt(999999999).toString()),
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
      ),
      items: List<Widget>.generate(list.length, (index) {
        final item = list[index];
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: -10.0,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    if (item['EntityType'] == 'category') {
                      final categoryId = int.parse(item['EntityId']);
                      Navigator.of(context).pushNamed(Routes.listProduct,
                          arguments: {'categoryId': categoryId});
                    } else if (item['EntityType'] == 'brand') {
                      final categoryId =
                          int.parse(item['EntityId'].split('&')[0]);
                      final brandId = int.parse(item['EntityId'].split('&')[1]);
                      Navigator.pushNamed(context, Routes.listProduct,
                          arguments: {
                            'categoryId': categoryId,
                            'brandId': brandId
                          });
                    } else if (item['EntityType'] == 'state') {
                      final categoryId = widget.section.categoryId;
                      final stateId = int.parse(item['EntityId']);
                      Navigator.pushNamed(context, Routes.listProduct,
                          arguments: {
                            'categoryId': categoryId,
                            'locationId': stateId
                          });
                    } else if (item['EntityType'] == 'product') {
                      int productId =
                          int.parse(item['EntityId'].toString().split('&')[0]);
                      int categoryId =
                          int.parse(item['EntityId'].toString().split('&')[1]);
                      UtilOther.ShowProduct(
                          context: context,
                          productId: productId,
                          categoryId: categoryId);
                    } else if (item['EntityType'] == 'user') {
                      Navigator.pushNamed(context, Routes.profile,
                          arguments: item['EntityId']);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CachedNetworkImage(
                      imageUrl: item['Image'] != null
                          ? '${Application.domain}${item['Image']!.replaceAll("\\", "/").replaceAll("TYPE", "full")}'
                          : '',
                      imageBuilder: (context, imageProvider) {
                        return Image(image: imageProvider, fit: BoxFit.cover);
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
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
