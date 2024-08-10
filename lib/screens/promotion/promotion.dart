import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/routes.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/app_search_bar.dart';
import 'package:supermarket/widgets/widget.dart';

class Promotion extends StatefulWidget {
  const Promotion({Key? key}) : super(key: key);

  @override
  State<Promotion> createState() {
    return _PromotionState();
  }
}

class _PromotionState extends State<Promotion> {
  final _discoveryCubit = PromotionCubit();
  StreamSubscription? _submitSubscription;

  @override
  void initState() {
    super.initState();
    _discoveryCubit.onLoad();
  }

  @override
  void dispose() {
    _submitSubscription?.cancel();
    _discoveryCubit.close();
    super.dispose();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    await _discoveryCubit.onLoad();
  }

  ///On search
  void _onSearch() {
    Navigator.pushNamed(context, Routes.searchHistory);
  }

  void _onPromotionDetails(PromotionModel item) {
    Navigator.pushNamed(
      context,
      Routes.listProduct,
      arguments: item,
    );
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    Navigator.pushNamed(context, Routes.productDetail, arguments: item);
  }

  ///On scan
  void _onScan() async {
    // final result = await Navigator.pushNamed(context, Routes.scanQR);
    // if (result != null) {
    //   final deeplink = DeepLinkModel.fromString(result as String);
    //   if (deeplink.target.isNotEmpty) {
    //     if (!mounted) return;
    //     Navigator.pushNamed(
    //       context,
    //       Routes.deepLink,
    //       arguments: deeplink,
    //     );
    //   }
    // }
  }
  Future<String?> checkAuthentication() async {
    if (AppBloc.authenticateCubit.state == AuthenticationState.fail) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: Routes.promotion,
      );
      return result as String?;
    } else if (AppBloc.authenticateCubit.state == AuthenticationState.success) {
      return Routes.promotion;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              bottom: 8,
              top: 4,
              left: 16,
              right: 16,
            ),
            child: Column(
              children: [
                AppSearchBar(
                  onSearch: _onSearch,
                  onScan: _onScan,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PromotionCubit, PromotionState>(
              bloc: _discoveryCubit,
              builder: (context, discovery) {
                ///Loading

                Widget content = ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemBuilder: (context, index) {
                    return AppPromotionItem();
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemCount: 15,
                );

                ///Success
                if (discovery is PromotionSuccess) {
                  if (discovery.list.isEmpty) {
                    content = Center(
                      child: Text(
                        Translate.of(context).translate(
                          'can_not_found_data',
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  } else {
                    content = ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemBuilder: (context, index) {
                        final item = discovery.list[index];
                        return Row(
                          children: [
                            // leadingWidget,
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                ),
                                child: AppPromotionItem(
                                  item: item,
                                  checkAuthentication: checkAuthentication,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 12);
                      },
                      itemCount: discovery.list.length,
                    );
                  }
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: content,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
