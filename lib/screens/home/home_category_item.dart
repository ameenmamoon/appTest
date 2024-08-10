import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supermarket/models/model_category.dart';
import 'package:supermarket/widgets/app_placeholder.dart';

class HomeCategoryItem extends StatelessWidget {
  final CategoryModel? item;
  final Function(CategoryModel)? onPressed;

  const HomeCategoryItem({
    Key? key,
    this.item,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return AppPlaceholder(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.21,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 10,
                width: 48,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.21,
      child: GestureDetector(
        onTap: () => onPressed!(item!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item!.color,
              ),
              child: item?.iconUrl != null && item?.iconUrl != ''
                  ? Image.asset(
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
                    )
                  : FaIcon(
                      item!.icon,
                      size: 18,
                      color: Colors.white,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              item!.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}