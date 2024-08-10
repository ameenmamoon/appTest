import 'dart:convert';

import 'package:supermarket/configs/application.dart';
import 'package:supermarket/configs/routes.dart';
import 'package:supermarket/utils/other.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/widgets/app_placeholder.dart';

class AppNotificationItem extends StatelessWidget {
  final NotificationModel? item;
  final NotificationType type;

  const AppNotificationItem({
    Key? key,
    this.item,
    this.type = NotificationType.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return AppPlaceholder(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          width: double.infinity,
          height: 100,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
        ),
      );
    }
    return InkWell(
      onTap: () {
        if (item == null || item!.entityId == null || item!.entityId!.isEmpty)
          return;
        if (item!.entityType == 'category') {
          final categoryId = int.parse(item!.entityId!);
          Navigator.of(context).pushNamed(Routes.listProduct,
              arguments: {'categoryId': categoryId});
        } else if (item!.entityType == 'brand') {
          final categoryId = int.parse(item!.entityId!.split('&')[0]);
          final brandId = int.parse(item!.entityId!.split('&')[1]);
          Navigator.pushNamed(context, Routes.listProduct,
              arguments: {'categoryId': categoryId, 'brandId': brandId});
        } else if (item!.entityType == 'state') {
          final stateId = int.parse(item!.entityId!);
          Navigator.pushNamed(context, Routes.listProduct,
              arguments: {'locationId': stateId});
        } else if (item!.entityType == 'product') {
          int productId = int.parse(item!.entityId.toString().split('&')[0]);
          int categoryId = int.parse(item!.entityId.toString().split('&')[1]);
          UtilOther.ShowProduct(
              context: context, productId: productId, categoryId: categoryId);
        } else if (item!.entityType == 'user') {
          Navigator.pushNamed(context, Routes.profile,
              arguments: item!.entityId);
        }
      },
      child:
          // Request amount
          Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (item!.image != null && item!.image!.isNotEmpty)
                    Container(
                      constraints:
                          const BoxConstraints(maxWidth: 50, maxHeight: 50),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${Application.domain}${item!.image!.replaceAll("\\", "/").replaceAll("TYPE", "thumb")}',
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: 50,
                            height: 50,
                            constraints:
                                const BoxConstraints(maxWidth: double.infinity),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) {
                          return AppPlaceholder(
                            child: Container(
                              constraints: const BoxConstraints(
                                  maxWidth: double.infinity),
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
                              constraints: const BoxConstraints(
                                  maxWidth: double.infinity),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: const Icon(
                                Icons.error,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: RichText(
                                  text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: item!.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: RichText(
                                  text: TextSpan(
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      children: [
                                        TextSpan(
                                            text: item!.description,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ]),
                                ),
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
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                item!.timeElapsed,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
      //  AppPlaceholder(
      //   child: Container(
      //     padding: const EdgeInsets.all(16.0),
      //     margin: const EdgeInsets.symmetric(vertical: 4.0),
      //     width: double.infinity,
      //     height: 100,
      //     decoration: const BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.all(Radius.circular(5.0))),
      //   ),
      // ),
    );
  }
}
