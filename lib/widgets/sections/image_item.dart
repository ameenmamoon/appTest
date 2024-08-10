import 'dart:convert';
import 'dart:math';

import 'package:supermarket/models/model.dart';
import 'package:supermarket/widgets/app_product_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../configs/application.dart';
import '../../configs/routes.dart';
import '../../models/model_filter.dart';
import '../../models/model_home_section.dart';
import 'package:supermarket/widgets/app_placeholder.dart';
import '../../repository/list_repository.dart';
import '../../utils/other.dart';
import '../../utils/translate.dart';

class ImageItem extends StatefulWidget {
  final HomeSectionModel section;

  const ImageItem({Key? key, required this.section}) : super(key: key);

  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem>
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
    final item = list.first;

    Random random = Random();
    return Container(
        key: Key(random.nextInt(999999999).toString()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        child: InkWell(
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
              Navigator.pushNamed(context, Routes.listProduct,
                  arguments: {'categoryId': categoryId, 'locationId': stateId});
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
            aspectRatio: 22 / 9,
            child: CachedNetworkImage(
              imageUrl: item['Image'] != null
                  ? '${Application.domain}${item['Image']!.replaceAll("\\", "/").replaceAll("TYPE", "full")}'
                  : '',
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
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (item['IsAppearTitle'] == true)
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black.withOpacity(0.50),
                                      ),
                                      child: Text(
                                        item['EntityTitle'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: item['Color'] != null
                                                    ? Color(int.parse(
                                                        '0x${item['Color']}'))
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
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
        ));
  }
}
