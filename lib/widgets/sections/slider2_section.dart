import 'dart:convert';
import 'dart:math';

import 'package:supermarket/configs/config.dart';
import 'package:supermarket/configs/routes.dart';
import 'package:supermarket/constants/constants.dart';
import 'package:supermarket/constants/responsive.dart';
import 'package:supermarket/models/model_category.dart';
import 'package:supermarket/widgets/app_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../models/model_home_section.dart';
import '../../utils/other.dart';

class Slider2Section extends StatefulWidget {
  final HomeSectionModel section;

  const Slider2Section({Key? key, required this.section}) : super(key: key);

  @override
  _Slider2SectionState createState() => _Slider2SectionState();
}

class _Slider2SectionState extends State<Slider2Section>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final listString = widget.section.extendedAttributes!
        .singleWhere((element) => element.key == 'list')
        .json;
    final list = listString != null ? jsonDecode(listString) : [];
    list?.sort((a, b) {
      int priorityA = int.tryParse(a['Priority'].toString()) ?? 0;
      int priorityB = int.tryParse(b['Priority'].toString()) ?? 0;
      return priorityA.compareTo(priorityB);
    });

    Random random = Random();
    return CarouselSlider(
      key: Key(random.nextInt(999999999).toString()),
      items: (list as List).map((item) {
        return Builder(
          builder: (BuildContext context) => InkWell(
            onTap: () {
              if (item['EntityType'] == 'category') {
                final categoryId = int.parse(item['EntityId']);
                Navigator.of(context).pushNamed(Routes.listProduct,
                    arguments: {'categoryId': categoryId});
              } else if (item['EntityType'] == 'brand') {
                final categoryId = int.parse(item['EntityId'].split('&')[0]);
                final brandId = int.parse(item['EntityId'].split('&')[1]);
                Navigator.pushNamed(context, Routes.listProduct,
                    arguments: {'categoryId': categoryId, 'brandId': brandId});
              } else if (item['EntityType'] == 'state') {
                final categoryId = widget.section.categoryId;
                final stateId = int.parse(item['EntityId']);
                Navigator.pushNamed(context, Routes.listProduct, arguments: {
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
            child: AspectRatio(
              aspectRatio: 18 / 9,
              child: CachedNetworkImage(
                imageUrl: item['Image'] != null
                    ? '${Application.domain}${item['Image']!.replaceAll("\\", "/").replaceAll("TYPE", "full")}'
                    : '',
                imageBuilder: (context, imageProvider) {
                  return Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    width: double.infinity,
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

              //  Image.network(
              //   item['Image'] != null
              //       ? '${Application.domain}${item['Image']!.replaceAll("\\", "/").replaceAll("TYPE", "full")}'
              //       : '',
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              //   // height: 200,
              // ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        height: 200,
        autoPlay: true,
      ),
    );
  }
}
