import 'dart:async';
import 'dart:typed_data';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/models/model_category.dart';
import 'package:supermarket/widgets/app_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:supermarket/widgets/app_search_bar.dart';
import 'package:supermarket/widgets/sections/featured_offers.dart';
import 'package:supermarket/widgets/sections/special_offers.dart';
import '../../blocs/bloc.dart';
import '../../configs/config.dart';
import '../../utils/translate.dart';
import 'home_category_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showLogo = true;
  TextEditingController textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;
  late StreamSubscription _reviewSubscription;
  final _scrollController = ScrollController();
  final _endReachedThreshold = 100;
  final ValueNotifier<bool> _shoppingCartNotifier = ValueNotifier<bool>(false);

  ///On search
  void _onSearch() {
    Navigator.pushNamed(context, Routes.searchHistory, arguments: _image);
  }

  @override
  void initState() {
    super.initState();
    AppBloc.homeCubit.onLoad();
    _scrollController.addListener(_onScroll);
    _reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
      if (state is ReviewByIdSuccess && state.productId != null) {
        AppBloc.homeCubit.onLoad();
      }
    });
  }

  @override
  void dispose() {
    _reviewSubscription.cancel();
    _scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  ///Refresh
  Future<void> _onRefresh() async {
    await AppBloc.homeCubit.onLoad();
  }

  ///Handle load more
  void _onScroll() {
    if (_scrollController.position.extentAfter > _endReachedThreshold) return;
    final state = AppBloc.homeCubit.state;
    if (state is HomeSuccess && state.canLoadMore && !state.loadingMore) {
      AppBloc.homeCubit.onLoadMore();
    }
  }

  Widget _buildCategory(List<CategoryModel>? category) {
    ///Loading
    Widget content = Wrap(
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(8, (index) => index).map(
        (item) {
          return const HomeCategoryItem();
        },
      ).toList(),
    );

    if (category != null) {
      final more = CategoryModel.fromJson({
        "term_id": -1,
        "name": Translate.of(context).translate("more"),
        "icon": "fas fa-ellipsis",
        "color": "#ff8a65",
      });

      content = Wrap(
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          ...category.take(7).toList().map(
            (item) {
              return HomeCategoryItem(
                item: item,
                onPressed: _onCategory,
              );
            },
          ),
          HomeCategoryItem(
            item: more,
            onPressed: (item) {
              _onCategory(null);
            },
          )
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      child: content,
    );
  }

  void _onCategory(CategoryModel? item) {
    if (item == null) {
      Navigator.pushNamed(context, Routes.category, arguments: item?.id);
      return;
    }
    Navigator.pushNamed(context, Routes.listProduct, arguments: item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // flexibleSpace: Container(
          //   padding: const EdgeInsets.only(
          //     bottom: 8,
          //     top: 4,
          //     left: 16,
          //     right: 16,
          //   ),
          //   child: AppSearchBar(
          //     onSearch: _onSearch,
          //     onScan: () {},
          //   ),
          // ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: showLogo ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 100),
                    child:
                        Image.asset(Images.homeLogo, width: 200, height: 200),
                  ),
                )
              ],
            ),
          ),
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
            bloc: AppBloc.homeCubit,
            builder: (context, state) {
              List<CategoryModel>? category;
              List<ProductModel> product = [];
              if (state is HomeSuccess) {
                category = state.category;
                product = state.product;

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: AnimationLimiter(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: _shoppingCartNotifier,
                        builder: (context, value, child) {
                          return CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    Widget childWidget = Container();
                                    HomeSectionModel item;
                                    if (index == 0) {
                                      childWidget = Container(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                          top: 10,
                                          left: 16,
                                          right: 16,
                                        ),
                                        child: AppSearchBar(
                                          onSearch: _onSearch,
                                          onScan: () {},
                                        ),
                                      );
                                    } else if (index == 1) {
                                      childWidget = _buildCategory(category);
                                    } else if (index == 2) {
                                      childWidget = SpecialOffers(
                                        image: Images.demo,
                                        color: const Color(0xff262628),
                                        list: product,
                                        onSetState: () {
                                          // _shoppingCartNotifier.value =
                                          //     !_shoppingCartNotifier.value;
                                        },
                                      );
                                    } else if (index == 3) {
                                      childWidget = FeaturedOffers(
                                        image:
                                            'https://peakbusinessvaluation.com/wp-content/uploads/how-to-value-a-grocery-store-or-supermarket-980x653.webp',
                                        list: product,
                                        onSetState: () {
                                          // _shoppingCartNotifier.value =
                                          //     !_shoppingCartNotifier.value;
                                        },
                                      );
                                    } else if (index == 4) {
                                      childWidget = SpecialOffers(
                                        image: Images.demo2,
                                        color: const Color(0xfff6f6f6),
                                        list: product,
                                        onSetState: () {
                                          // _shoppingCartNotifier.value =
                                          //     !_shoppingCartNotifier.value;
                                        },
                                      );
                                    } else if (index == 5) {
                                      childWidget = FeaturedOffers(
                                        image:
                                            'https://peakbusinessvaluation.com/wp-content/uploads/how-to-value-a-grocery-store-or-supermarket-980x653.webp',
                                        list: product,
                                        onSetState: () {
                                          // _shoppingCartNotifier.value =
                                          //     !_shoppingCartNotifier.value;
                                        },
                                      );
                                    } else {
                                      item = state.list[index - 5];
                                    }
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: index == 0 ? 0 : 8),
                                              child: childWidget),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: state.list.length + 6,
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                );
              }
              return AnimationLimiter(
                  child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      top: 4,
                      left: 16,
                      right: 16,
                    ),
                    child: AppSearchBar(
                      onSearch: _onSearch,
                      onScan: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppPlaceholder(
                      child: Container(
                    color: Colors.white,
                    height: 250,
                    width: double.infinity,
                  )),
                  const SizedBox(height: 8),
                  AppPlaceholder(
                      child: Container(
                    color: Colors.white,
                    height: 250,
                    width: double.infinity,
                  )),
                  const SizedBox(height: 8),
                  AppPlaceholder(
                      child: Container(
                    color: Colors.white,
                    height: 250,
                    width: double.infinity,
                  )),
                  const SizedBox(height: 8),
                  AppPlaceholder(
                      child: Container(
                    color: Colors.white,
                    height: 250,
                    width: double.infinity,
                  )),
                  const SizedBox(height: 8),
                  AppPlaceholder(
                      child: Container(
                    color: Colors.white,
                    height: 250,
                    width: double.infinity,
                  )),
                  const SizedBox(height: 16),
                ],
              ));
            }));
  }

  void _showProductScreen(BuildContext context, String id) {
    //   Navigator.of(context).push(CupertinoPageRoute(
    //       builder: (context) => const ProductScreen(id: 2, categoryId: 4)));
  }
}
