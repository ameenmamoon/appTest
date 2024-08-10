import 'package:supermarket/configs/application.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';

enum PageType { list }

class AppNavBar extends StatelessWidget {
  final PageType pageStyle;
  final SortModel? currentSort;
  final VoidCallback onChangeSort;
  final VoidCallback onChangeView;
  final VoidCallback? onFilter;
  final IconData iconModeView;

  const AppNavBar({
    Key? key,
    this.pageStyle = PageType.list,
    this.currentSort,
    required this.onChangeSort,
    required this.iconModeView,
    required this.onChangeView,
    required this.onFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sortTitle = Translate.of(context).translate('sort');
    if (currentSort != null) {
      sortTitle = Translate.of(context).translate(currentSort!.name);
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: onChangeSort,
            child: Row(
              children: <Widget>[
                const Icon(Icons.swap_vert),
                Text(
                  sortTitle,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(overflow: TextOverflow.ellipsis),
                )
              ],
            ),
          ),
          SizedBox(
            height: 24,
            child: VerticalDivider(
              color: Theme.of(context).dividerColor,
            ),
          ),
          IconButton(
            icon: Icon(iconModeView),
            onPressed: onChangeView,
          ),
          SizedBox(
            height: 24,
            child: VerticalDivider(
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            onTap: onChangeSort,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.track_changes),
                  onPressed: onFilter,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Text(
                    Translate.of(context).translate('filter'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
