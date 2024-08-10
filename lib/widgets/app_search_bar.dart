import 'package:flutter/material.dart';
import 'package:supermarket/utils/utils.dart';

class AppSearchBar extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onScan;

  const AppSearchBar({
    Key? key,
    required this.onSearch,
    required this.onScan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(15),
              spreadRadius: 4,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onSearch,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Theme.of(context).textTheme.labelLarge?.color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    Translate.of(context).translate('search'),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const VerticalDivider(),
                InkWell(
                  onTap: onScan,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Icon(
                      Icons.qr_code_scanner_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
