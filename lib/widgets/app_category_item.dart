import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/configs/application.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

enum CategoryView { full, icon, cardLarge }

class AppCategory extends StatelessWidget {
  const AppCategory({
    Key? key,
    this.type = CategoryView.full,
    this.item,
    this.onPressed,
  }) : super(key: key);

  final CategoryView type;
  final CategoryModel? item;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CategoryView.full:
        if (item == null) {
          return AppPlaceholder(
            child: Container(
              height: 120,
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: onPressed,
          child: SizedBox(
            height: 120,
            child: CachedNetworkImage(
              imageUrl: Application.domain +
                  (item!.image != null
                      ? item!.image!
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
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item!.color,
                              ),
                              child: Image.asset(
                                'assets/icons/${item!.iconUrl}',
                                color: Colors.white,
                                width: 18,
                                height: 18,
                                errorBuilder: (context, error, stackTrace) {
                                  return AppPlaceholder(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.error),
                                    ),
                                  );
                                },
                              ),
                              // child: CachedNetworkImage(
                              //   imageUrl: Application.domain +
                              //       item!.iconUrl!
                              //           .replaceAll("\\", "/")
                              //           .replaceAll("TYPE", "full"),
                              //   color: item!.color,
                              //   colorBlendMode: BlendMode.color,
                              //   filterQuality: FilterQuality.high,
                              //   width: 18,
                              //   height: 18,
                              // ),
                              // child: Icon(
                              //   item!.icon,
                              //   color: Colors.white,
                              //   size: 18,
                              // ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${item!.count} ${Translate.of(context).translate('count')}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white),
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
        );

      case CategoryView.icon:
        if (item == null) {
          return AppPlaceholder(
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 8,
                          width: 100,
                          color: Colors.white,
                        ),
                        Container(
                          height: 8,
                          width: 100,
                          color: Colors.white,
                          padding: const EdgeInsets.only(top: 4),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: item!.color,
                ),
                child: Image.asset(
                  'assets/icons/${item!.iconUrl}',
                  color: Colors.white,
                  // color: item!.color,
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
                    return AppPlaceholder(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.error),
                      ),
                    );
                  },
                ),
                // child: CachedNetworkImage(
                //   imageUrl: Application.domain +
                //       item!.iconUrl!
                //           .replaceAll("\\", "/")
                //           .replaceAll("TYPE", "full"),
                //   color: item!.color,
                //   colorBlendMode: BlendMode.color,
                //   filterQuality: FilterQuality.high,
                //   width: 32,
                //   height: 32,
                // ),
                // child: Icon(
                //   item!.icon,
                //   color: Colors.white,
                //   size: 32,
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
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
                      '${item!.count} ${Translate.of(context).translate('location')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            ],
          ),
        );

      ///Case View Card large
      case CategoryView.cardLarge:
        if (item == null) {
          return SizedBox(
            width: 135,
            height: 160,
            child: AppPlaceholder(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        }

        return SizedBox(
          width: 135,
          height: 160,
          child: GestureDetector(
            onTap: onPressed,
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.all(0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: item!.image != null
                    ? Application.domain +
                        item!.image!
                            .replaceAll("\\", "/")
                            .replaceAll("TYPE", "full")
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Text(
                              item!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
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
        );
      default:
        return Container();
    }
  }
}
