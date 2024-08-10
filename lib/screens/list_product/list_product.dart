import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/app_search_bar.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../models/model_feature.dart';
import '../../models/model_location.dart';
import '../../widgets/widget.dart';

class ListProduct extends StatefulWidget {
  final int? categoryId;

  const ListProduct({Key? key, this.categoryId}) : super(key: key);

  @override
  _ListProductState createState() {
    return _ListProductState();
  }
}

class _ListProductState extends State<ListProduct> {
  final _listCubit = ListCubit();
  final _swipeController = SwiperController();
  final _scrollController = ScrollController();
  final _endReachedThreshold = 100;
  final _polylinePoints = PolylinePoints();
  final Map<PolylineId, Polyline> _polyLines = {};
  final List<LatLng> _polylineCoordinates = [];
  int? categoryId;

  late StreamSubscription _wishlistSubscription;
  late StreamSubscription _reviewSubscription;

  GoogleMapController? _mapController;
  MapType _mapType = MapType.normal;
  final PageType _pageType = PageType.list;
  ProductViewType _listMode = ProductViewType.list;

  bool _isRefreshing = true;
  FilterModel _filter = FilterModel.fromDefault();
  Timer? timer;
  final _textSearchStringController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;
  Uint8List? _bytes;
  @override
  void initState() {
    super.initState();
    // categoryId = widget.categoryId;
    categoryId = null;
    _scrollController.addListener(_onScroll);
    setState(() {});
    _wishlistSubscription = AppBloc.wishListCubit.stream.listen((state) {
      if (state is WishListSuccess && state.updateID != null) {
        _listCubit.onUpdate(state.updateID!);
      }
    });
    _reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
      if (state is ReviewByIdSuccess && state.productId != null) {
        _listCubit.onUpdate(state.productId!);
      }
    });
    _onRefresh();
  }

  @override
  void dispose() {
    _wishlistSubscription.cancel();
    _reviewSubscription.cancel();
    _swipeController.dispose();
    _scrollController.dispose();
    _mapController?.dispose();
    _listCubit.close();
    _textSearchStringController.dispose();
    super.dispose();
  }

  ///Handle load more
  void _onScroll() {
    if (_scrollController.position.extentAfter > _endReachedThreshold) return;
    final state = _listCubit.state;
    if (state is ListSuccess && state.canLoadMore && !state.loadingMore) {
      _listCubit.onLoadMore(categoryId: categoryId);
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    _isRefreshing = true;
    // _filter.extendedAttributes = [];
    await _listCubit.onLoad(categoryId: categoryId).then((value) {
      _isRefreshing = false;
    });
  }

  ///On Change Sort
  void _onChangeSort() async {
    final result = await showModalBottomSheet<SortModel?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [_filter.sortOptions],
            data: [],
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        _filter.sortOptions = result;
      });
      _onRefresh();
    }
  }

  ///On Change View
  void _onChangeView() {
    switch (_listMode) {
      case ProductViewType.grid:
        _listMode = ProductViewType.list;
        break;
      case ProductViewType.list:
        _listMode = ProductViewType.block;
        break;
      case ProductViewType.block:
        _listMode = ProductViewType.grid;
        break;
      default:
        return;
    }
    setState(() {
      _listMode = _listMode;
      _mapType = _mapType;
    });
  }

  ///On change filter
  void _onChangeFilter() async {
    await Navigator.pushNamed(
      context,
      Routes.filter,
      arguments: _filter.clone(),
    ).then((value) {
      if (value != null) {
        _filter = (value as FilterModel);
        setState(() {});
        _onRefresh();
      }
    });
    // if (result != null && result is FilterModel) {
    //   setState(() {
    //     _filter = result;
    //   });
    // }
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    UtilOther.ShowProduct(
        context: context, productId: item.id, categoryId: item.categoryId);
  }

  ///Export Icon for Mode View
  IconData _exportIconView() {
    ///Icon for ListView Mode
    switch (_listMode) {
      case ProductViewType.list:
        return Icons.view_list;
      case ProductViewType.grid:
        return Icons.view_quilt;
      case ProductViewType.block:
        return Icons.view_array;
      default:
        return Icons.help;
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

  ///_build Item
  Widget _buildItem({
    ProductModel? item,
    required ProductViewType type,
  }) {
    switch (type) {
      case ProductViewType.list:
        if (item != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppProductItem(
              product: item,
              type: _listMode,
              onSelectUnits: _onSelectUnits,
              checkAuthentication: checkAuthentication,
              onSetState: () {},
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppProductItem(
            type: _listMode,
            onSetState: () {},
            onSelectUnits: _onSelectUnits,
            checkAuthentication: checkAuthentication,
          ),
        );
      default:
        if (item != null) {
          return AppProductItem(
            product: item,
            type: _listMode,
            onSetState: () {},
            onSelectUnits: _onSelectUnits,
            checkAuthentication: checkAuthentication,
          );
        }
        return AppProductItem(
          type: _listMode,
          onSetState: () {},
          onSelectUnits: _onSelectUnits,
          checkAuthentication: checkAuthentication,
        );
    }
  }

  ///Build Content Page Style
  Widget _buildContent() {
    return BlocBuilder<ListCubit, ListState>(
      builder: (context, state) {
        /// List Style
        if (_pageType == PageType.list) {
          Widget contentList = _isRefreshing
              ? ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildItem(type: _listMode),
                    );
                  },
                  itemCount: 8,
                )
              : Container();
          if (_listMode == ProductViewType.grid) {
            final size = MediaQuery.of(context).size;
            final left = MediaQuery.of(context).padding.left;
            final right = MediaQuery.of(context).padding.right;
            const itemHeight = 240;
            final itemWidth = (size.width - 48 - left - right) / 2;
            final ratio = itemWidth / itemHeight;
            contentList = GridView.count(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: ratio,
              children: List.generate(8, (index) => index).map((item) {
                return _buildItem(type: _listMode);
              }).toList(),
            );
          }

          ///Build List
          if (state is ListSuccess) {
            List list = List.from(state.list);
            if (state.loadingMore) {
              list.add(null);
            }
            contentList = RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: _onRefresh,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildItem(item: item, type: _listMode),
                  );
                },
                itemCount: list.length,
              ),
            );
            if (_listMode == ProductViewType.grid) {
              final size = MediaQuery.of(context).size;
              final left = MediaQuery.of(context).padding.left;
              final right = MediaQuery.of(context).padding.right;
              const itemHeight = 240;
              final itemWidth = (size.width - 48 - left - right) / 2;
              final ratio = itemWidth / itemHeight;
              contentList = RefreshIndicator(
                onRefresh: _onRefresh,
                child: GridView.count(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  crossAxisCount: 2,
                  childAspectRatio: ratio,
                  children: list.map((item) {
                    return _buildItem(item: item, type: _listMode);
                  }).toList(),
                ),
              );
            }

            ///Build List empty
            if (state.list.isEmpty) {
              contentList = Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.sentiment_satisfied),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        Translate.of(context).translate('list_is_empty'),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              );
            }
          }

          /// List
          return SafeArea(child: contentList);
        }

        return Container();
      },
    );
  }

  ///On search
  void _onSearch() {
    Navigator.pushNamed(context, Routes.searchHistory, arguments: _image);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> categories = [
      // Container(
      //   width: MediaQuery.of(context).size.width * 0.5,
      //   height: 40,
      //   child: Container(
      //     decoration: BoxDecoration(
      //       color: Theme.of(context).dividerColor.withOpacity(.07),
      //       borderRadius: const BorderRadius.all(
      //         Radius.circular(8),
      //       ),
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.all(1),
      //       child: IntrinsicHeight(
      //         child: Container(
      //           padding: const EdgeInsets.only(
      //             bottom: 8,
      //             top: 10,
      //             left: 16,
      //             right: 16,
      //           ),
      //           child: AppSearchBar(
      //             onSearch: _onSearch,
      //             onScan: () {},
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // )
    ];

    if (_image != null) {
      categories.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 40),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.07),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.memory(
                  height: 20,
                  width: 20,
                  _bytes!,
                  fit: BoxFit.fill,
                ),
                // const Icon(
                //   Icons.photo,
                //   size: 20,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    Translate.of(context).translate('image'),
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  color: Colors.red,
                  onPressed: () {
                    _image = null;
                    _bytes = null;
                    _filter.byImage = null;
                    setState(() {});
                    _onRefresh();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => _listCubit,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Translate.of(context).translate('listing')),
          actions: const <Widget>[],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppNavBar(
              currentSort: _filter.sortOptions,
              onChangeSort: _onChangeSort,
              iconModeView: _exportIconView(),
              onChangeView: _onChangeView,
              onFilter: _onChangeFilter,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  // spacing: 8,
                  // runSpacing: 8,
                  children: categories),
            ),
            Expanded(
              child: _buildContent(),
            )
          ],
        ),
      ),
    );
  }
}
