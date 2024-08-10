import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/models/model_feature.dart';
import 'package:supermarket/repository/repository.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../api/api.dart';
import '../../models/model_location.dart';
import '../../repository/location_repository.dart';

enum TimeType { start, end }

class Filter extends StatefulWidget {
  final FilterModel filter;
  const Filter({Key? key, required this.filter}) : super(key: key);

  @override
  _FilterState createState() {
    return _FilterState();
  }
}

class _FilterState extends State<Filter> {
  late FilterModel _filter;

  // List<PropertyModel> _listProperties = [];
  final Map<String, TextEditingController> _controllers =
      Map<String, TextEditingController>();
  final Map<String, String?> _errors = Map<String, String?>();
  Widget? filterProperties;

  @override
  void initState() {
    super.initState();
    _filter = widget.filter;
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((key, value) {
      value.dispose();
    });
  }

  ///On Navigate Filter Main Category
  void _onChangeMainCategory() async {
    // bool isSelected = false;
    // while (isSelected == false) {
    //   FocusManager.instance.primaryFocus?.unfocus();
    //   final selected = await Navigator.pushNamed(
    //     context,
    //     Routes.picker,
    //     arguments: PickerModel(
    //       name: Translate.of(context).translate('choose_section'),
    //       selected: [_filter.category],
    //       data: Application.submitSetting.categories.toList(),
    //     ),
    //   );
    // }
  }

  ///Apply filter
  void _onApply() {
    Navigator.pop(context, _filter);
  }

  ///Create Field
  Widget _onCreateField() {
    // _filter.extendedAttributes = [];
    List<Widget> widgets = [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
    // setState(() {});
  }

  ///Build content
  Widget _buildContent() {
    Widget cityAction = RotatedBox(
      quarterTurns: AppLanguage.isRTL() ? 2 : 0,
      child: const Icon(
        Icons.keyboard_arrow_right,
        textDirection: TextDirection.ltr,
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            if (_filter.category != null) ...[
              // const SizedBox(height: 8),
              // Divider(color: Colors.grey.withOpacity(0.1)),
              // Wrap(
              //   spacing: 8,
              //   runSpacing: 8,
              //   children: Application.submitSetting.categories.map((item) {
              //     final selected = _filter.category == item;
              //     return SizedBox(
              //       height: 32,
              //       child: FilterChip(
              //         backgroundColor: Theme.of(context).dividerColor,
              //         selectedColor:
              //             Theme.of(context).dividerColor.withOpacity(0.3),
              //         selected: selected,
              //         label: Text(item.name,
              //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
              //                 fontWeight: FontWeight.bold,
              //                 color: selected ? Colors.black : null)),
              //         onSelected: (check) {
              //           if (check) {
              //             // Application.submitSetting.categories.firstWhere(
              //             //     (element) => element.id == _filter.category?.id);
              //             _filter.extendedAttributes = [];
              //           }
              //           setState(() {});
              //         },
              //       ),
              //     );
              //   }).toList(),
              // ),
            ],

            // _onCreateField(),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Translate.of(context).translate('price_currency'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Translate.of(context).translate('price_range'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text(
                    //   '${Application.setting.minPrice}',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // Text(
                    //   '${Application.setting.maxPrice}',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // )
                  ],
                ),
                // const SizedBox(height: 8),
                // SizedBox(
                //   height: 16,
                //   child: RangeSlider(
                //     min: Application.setting.minPrice,
                //     max: Application.setting.maxPrice,
                //     values: RangeValues(
                //       widget.filter.minPriceFilter ??
                //           Application.setting.minPrice,
                //       widget.filter.maxPriceFilter ??
                //           Application.setting.maxPrice,
                //     ),
                //     onChanged: (range) {
                //       setState(() {
                //         widget.filter.minPriceFilter = range.start;
                //         widget.filter.maxPriceFilter = range.end;
                //       });
                //     },
                //   ),
                // ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text(
                    //   Translate.of(context).translate('avg_price'),
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // Text(
                    //   '${widget.filter.minPriceFilter?.toInt() ?? Application.setting.minPrice} ${_filter.currency?.code ?? unitPrice}  - ${widget.filter.maxPriceFilter?.toInt() ?? Application.setting.maxPrice} ${_filter.currency?.code ?? unitPrice}',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // )
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate('sort_options'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: Application.setting.sortOptions.map((item) {
            //     final selected = _filter.sortOptions == item;
            //     return SizedBox(
            //       height: 32,
            //       child: FilterChip(
            //         selected: selected,
            //         label: Text(Translate.of(context).translate(item.name),
            //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
            //                 fontWeight: FontWeight.bold,
            //                 color: selected ? Colors.black : null)),
            //         onSelected: (check) {
            //           if (check) {
            //             _filter.sortOptions = item;
            //           } else {
            //             _filter.sortOptions = item;
            //           }
            //           setState(() {});
            //         },
            //       ),
            //     );
            //   }).toList(),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _filter);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            Translate.of(context).translate('filter'),
          ),
          actions: [
            Visibility(
              visible: !_filter.isEmpty(),
              child: AppButton(
                Translate.of(context).translate('clear'),
                onPressed: () {
                  setState(() {
                    _filter.clear();
                  });
                },
                type: ButtonType.text,
              ),
            ),
            AppButton(
              Translate.of(context).translate('apply'),
              onPressed: _onApply,
              type: ButtonType.text,
            )
          ],
        ),
        body: SafeArea(
          child: _buildContent(),
        ),
      ),
    );
  }
}
