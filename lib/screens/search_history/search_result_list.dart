import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

class ResultList extends StatefulWidget {
  const ResultList({
    Key? key,
  }) : super(key: key);

  @override
  _ResultListState createState() {
    return _ResultListState();
  }
}

class _ResultListState extends State<ResultList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) async {
    _onSave(item);
    UtilOther.ShowProduct(
        context: context, productId: item.id, categoryId: item.categoryId);
  }

  void _onSave(item) async {
    List<String>? historyString = Preferences.getStringList(
      Preferences.search,
    );
    if (historyString != null) {
      if (!historyString.contains(jsonEncode(item.toJson()))) {
        historyString.add(jsonEncode(item.toJson()));
        await Preferences.setStringList(
          Preferences.search,
          historyString,
        );
      }
    } else {
      await Preferences.setStringList(
        Preferences.search,
        [jsonEncode(item.toJson())],
      );
    }
  }

  Future<int?> _onSelectUnits(ProductModel product) async {
    final result = await showModalBottomSheet<ProductUnitModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => AppBottomPicker(
        picker: PickerModel(
          selected: [
            product.productUnits.where((element) => element.isSelected)
          ],
          data: product.productUnits,
        ),
        // hasScroll: true,
      ),
    );
    if (result == null) return null;
    return result.unitId;
  }

  Future<String?> checkAuthentication({String? route}) async {
    if (AppBloc.authenticateCubit.state == AuthenticationState.fail) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: route,
      );
      return result as String?;
    } else if (AppBloc.authenticateCubit.state == AuthenticationState.success) {
      return route;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchSuccess) {
            if (state.list.isEmpty) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.sentiment_satisfied),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        Translate.of(context).translate(
                          'can_not_found_data',
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final item = state.list[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppProductItem(
                    product: item,
                    type: ProductViewType.list,
                    onSetState: () {},
                    onSelectUnits: _onSelectUnits,
                    checkAuthentication: checkAuthentication,
                  ),
                );
              },
            );
          }
          if (state is SearchLoading) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
