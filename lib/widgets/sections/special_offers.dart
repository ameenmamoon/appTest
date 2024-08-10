import 'dart:convert';
import 'dart:math';

import 'package:supermarket/blocs/app_bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/widgets/app_product_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supermarket/widgets/widget.dart';
import '../../blocs/authentication/authentication_state.dart';
import '../../configs/application.dart';
import '../../models/model_filter.dart';
import '../../models/model_home_section.dart';
import '../../models/model_product.dart';
import 'package:supermarket/widgets/app_placeholder.dart';

class SpecialOffers extends StatefulWidget {
  final String image;
  final Color color;
  final List<ProductModel> list;
  final Function() onSetState;

  const SpecialOffers(
      {Key? key,
      required this.image,
      required this.color,
      required this.list,
      required this.onSetState})
      : super(key: key);

  @override
  _SpecialOffersState createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
        arguments: '/',
      );
      return result as String?;
    } else if (AppBloc.authenticateCubit.state == AuthenticationState.success) {
      return '/';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    return Container(
      key: Key(random.nextInt(999999999).toString()),
      height: 280,
      color: widget.color, //widget.color,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemCount: widget.list.isNotEmpty ? widget.list.length + 1 : 5,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: Padding(
                  padding: EdgeInsets.only(
                      right: 5, left: index == widget.list.length ? 30 : 5),
                  child: index == 0
                      ? AspectRatio(
                          aspectRatio: 12 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(widget.image),
                          ),
                        )
                      : SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                              child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(index - 1 == 0 ? 5 : 1),
                                  topLeft: Radius.circular(
                                      index == widget.list.length ? 5 : 1),
                                  bottomLeft: Radius.circular(
                                      index == widget.list.length ? 5 : 1),
                                  bottomRight:
                                      Radius.circular(index - 1 == 0 ? 5 : 1),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: const Offset(
                                        0, 10), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: widget.list.isNotEmpty
                                  ? AppProductItem(
                                      type: ProductViewType.grid,
                                      product: widget.list[index - 1],
                                      onSelectUnits: _onSelectUnits,
                                      checkAuthentication: checkAuthentication,
                                      onSetState: widget.onSetState,
                                    )
                                  : SizedBox(
                                      width: 165.0,
                                      height: 250.0,
                                      child: Shimmer.fromColors(
                                          baseColor: Colors.white,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(
                                            width: 165.0,
                                            height: 250.0,
                                            color: Colors.white,
                                          )),
                                    ),
                            ),
                          )),
                        )),
            );
          }),
    );
  }
}
