import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:path/path.dart' as path;

import 'location_repository.dart';

class ListRepository {
  ///load list
  static Future<List?> loadList({
    int? pageNumber,
    int? pageSize,
    FilterModel? filter,
    int? categoryId,
    String? searchString,
    bool? loading = true,
  }) async {
    Map<String, dynamic> params = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "searchString": searchString,
      "categoryId": categoryId,
    };

    if (filter != null) {
      params.addAll(UtilOther.buildFilterParams(filter));
    }
    final response = await Api.requestList(params, loading);
    if (response.succeeded) {
      final list = List.from(response.data ?? []).map((item) {
        return ProductModel.fromJson(item);
      }).toList();

      return [list, response.pagination];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  static Future<List?> loadListByList({
    List<int>? products,
    List<int>? promotions,
  }) async {
    Map<String, dynamic> params = {
      "productsIds": products,
      "promotionsIds": promotions,
    };

    final response = await Api.requestProductsByList(params);
    if (response.succeeded) {
      final list = List.from(response.data['products'] ?? []).map((item) {
        return ProductModel.fromJson(item);
      }).toList();
      final listPromotions =
          List.from(response.data['promotions'] ?? []).map((item) {
        return PromotionModel.fromJson(item);
      }).toList();
      return [list, listPromotions];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  ///load list
  static Future<List?> loadPromotionList({
    int? pageNumber,
    int? pageSize,
    String? searchString,
  }) async {
    Map<String, dynamic> params = {
      "pageNumber": pageNumber,
      "pageSize": pageSize,
      "searchString": searchString,
    };

    final response = await Api.requestPromotionList(params);
    if (response.succeeded) {
      final list = List.from(response.data ?? []).map((item) {
        return PromotionModel.fromJson(item);
      }).toList();

      return [list, response.pagination];
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  static Future<List?> loadWishListProducts() async {
    List<int> wishListProducts = [];
    final wishListProductsString =
        Preferences.getString(Preferences.wishListProducts);
    if (wishListProductsString != null && wishListProductsString.isNotEmpty) {
      wishListProducts = List.from(jsonDecode(wishListProductsString));
      Application.wishListProducts = wishListProducts;
    }
    return wishListProducts;
  }

  static Future<bool> addRemoveProductToWishList(
      {required int productId}) async {
    List<int> wishListProducts = [];
    final wishListProductsString =
        Preferences.getString(Preferences.wishListProducts);
    if (wishListProductsString != null) {
      wishListProducts = List.from(jsonDecode(wishListProductsString));
      if (!wishListProducts.any((element) => element == productId)) {
        wishListProducts.add(productId);
      } else {
        wishListProducts.removeWhere((element) => element == productId);
      }
      Application.wishListProducts = wishListProducts;
    } else {
      wishListProducts = [productId];
      Application.wishListProducts = wishListProducts;
    }
    return await Preferences.setString(
        Preferences.wishListProducts, jsonEncode(wishListProducts));
  }

  static Future<List?> loadWishListPromotions() async {
    List<int> wishListPromotions = [];
    final wishListPromotionsString =
        Preferences.getString(Preferences.wishListPromotions);
    if (wishListPromotionsString != null &&
        wishListPromotionsString.isNotEmpty) {
      wishListPromotions = List.from(jsonDecode(wishListPromotionsString));
      Application.wishListPromotions = wishListPromotions;
    }
    return wishListPromotions;
  }

  static Future<bool> addPromotionToWishList({required int promotionId}) async {
    List<int> wishListPromotions = [];
    final wishListPromotionsString =
        Preferences.getString(Preferences.wishListPromotions);
    if (wishListPromotionsString != null) {
      wishListPromotions = List.from(jsonDecode(wishListPromotionsString));
      if (!wishListPromotions.any((element) => element == promotionId)) {
        wishListPromotions.add(promotionId);
        Application.wishListPromotions = wishListPromotions;
      }
    } else {
      wishListPromotions = [promotionId];
      Application.wishListPromotions = wishListPromotions;
    }
    return await Preferences.setString(
        Preferences.wishListPromotions, jsonEncode(wishListPromotions));
  }

  static Future<List?> loadShoppingCartProducts() async {
    List<dynamic> shoppingCartProducts = [];
    final shoppingCartProductsString =
        Preferences.getString(Preferences.shoppingCartProducts);
    if (shoppingCartProductsString != null &&
        shoppingCartProductsString.isNotEmpty) {
      shoppingCartProducts = List.from(jsonDecode(shoppingCartProductsString));
      Application.shoppingCartProducts = shoppingCartProducts;
    }
    return shoppingCartProducts;
  }

  static Future<bool> addProductToShoppingCart(
      {required int productId,
      required int unitId,
      required bool isFavorite}) async {
    List<dynamic> shoppingCartProducts = [];
    final shoppingCartProductsString =
        Preferences.getString(Preferences.shoppingCartProducts);
    if (shoppingCartProductsString != null) {
      shoppingCartProducts = List.from(jsonDecode(shoppingCartProductsString));
      if (!shoppingCartProducts.any((element) => element[0] == productId)) {
        shoppingCartProducts.add([productId, unitId, isFavorite]);
        Application.shoppingCartProducts = shoppingCartProducts;
      }
    } else {
      shoppingCartProducts = [
        [productId, unitId, isFavorite]
      ];
      Application.shoppingCartProducts = shoppingCartProducts;
    }
    return await Preferences.setString(
        Preferences.shoppingCartProducts, jsonEncode(shoppingCartProducts));
  }

  static Future<bool> updateProductToShoppingCart(
      {required int productId, int? unitId, bool? isFavorite}) async {
    List<dynamic> shoppingCartProducts = [];
    final shoppingCartProductsString =
        Preferences.getString(Preferences.shoppingCartProducts);
    if (shoppingCartProductsString != null &&
        shoppingCartProductsString.isNotEmpty) {
      shoppingCartProducts = List.from(jsonDecode(shoppingCartProductsString));
      if (shoppingCartProducts.isNotEmpty &&
          shoppingCartProducts.any((element) => element[0] == productId)) {
        if (unitId != null) {
          shoppingCartProducts.singleWhere((e) => e[0] == productId)[1] =
              unitId;
        }
        if (isFavorite != null) {
          shoppingCartProducts.singleWhere((e) => e[0] == productId)[2] =
              isFavorite;
        }
        Application.shoppingCartProducts = shoppingCartProducts;
      }
      return await Preferences.setString(
          Preferences.shoppingCartProducts, jsonEncode(shoppingCartProducts));
    }
    return false;
  }

  static Future<bool> removeProductShoppingCart(
      {required int productId}) async {
    List<dynamic> shoppingCartProducts = [];
    final shoppingCartProductsString =
        Preferences.getString(Preferences.shoppingCartProducts);
    if (shoppingCartProductsString != null &&
        shoppingCartProductsString.isNotEmpty) {
      shoppingCartProducts = List.from(jsonDecode(shoppingCartProductsString));
      if (shoppingCartProducts.isNotEmpty) {
        shoppingCartProducts.removeWhere((element) => element[0] == productId);
        Application.shoppingCartProducts = shoppingCartProducts;
      }
      return await Preferences.setString(
          Preferences.shoppingCartProducts, jsonEncode(shoppingCartProducts));
    }
    return false;
  }

  static Future<List?> loadShoppingCartPromotions() async {
    List<int> shoppingCartPromotions = [];
    final shoppingCartPromotionsString =
        Preferences.getString(Preferences.shoppingCartPromotion);
    if (shoppingCartPromotionsString != null &&
        shoppingCartPromotionsString.isNotEmpty) {
      shoppingCartPromotions =
          List.from(jsonDecode(shoppingCartPromotionsString));
      Application.shoppingCartsPromotions = shoppingCartPromotions;
    }
    return shoppingCartPromotions;
  }

  static Future<bool> addPromotionToShoppingCart(
      {required int promotionId}) async {
    List<int> shoppingCartPromotions = [];
    final shoppingCartPromotionsString =
        Preferences.getString(Preferences.shoppingCartPromotion);
    if (shoppingCartPromotionsString != null) {
      shoppingCartPromotions =
          List.from(jsonDecode(shoppingCartPromotionsString));
      if (!shoppingCartPromotions.any((element) => element == promotionId)) {
        shoppingCartPromotions.add(promotionId);
        Application.shoppingCartsPromotions = shoppingCartPromotions;
      }
    } else {
      shoppingCartPromotions = [promotionId];
      Application.shoppingCartsPromotions = shoppingCartPromotions;
    }
    return await Preferences.setString(
        Preferences.shoppingCartPromotion, jsonEncode(shoppingCartPromotions));
  }

  static Future<bool> removePromotionShoppingCart(
      {required int promotionId}) async {
    List<int> shoppingCartPromotions = [];
    final shoppingCartPromotionsString =
        Preferences.getString(Preferences.shoppingCartPromotion);
    if (shoppingCartPromotionsString != null &&
        shoppingCartPromotionsString.isNotEmpty) {
      shoppingCartPromotions =
          List.from(jsonDecode(shoppingCartPromotionsString));
      if (shoppingCartPromotions.isNotEmpty) {
        shoppingCartPromotions.removeWhere((element) => element == promotionId);
        Application.shoppingCartsPromotions = shoppingCartPromotions;
      }
      return await Preferences.setString(Preferences.shoppingCartPromotion,
          jsonEncode(shoppingCartPromotions));
    }
    return false;
  }

  ///load wish list
  static Future<List?> loadWishList({
    int? pageNumber,
    int? pageSize,
    bool isProduct = true,
  }) async {
    final response = await loadListByList(
        products: Application.wishListProducts,
        promotions: Application.wishListPromotions);
    if (isProduct) {
      return [
        response?[0] ?? [],
        PaginationModel(
            currentPage: 1,
            pageSize: 1000,
            totalPages: 1,
            totalCount: (response?[0] ?? []).length)
      ];
    }
    return [
      response?[1] ?? [],
      PaginationModel(
          currentPage: 1,
          pageSize: 1000,
          totalPages: 1,
          totalCount: (response?[0] ?? []).length)
    ];

    // Map<String, dynamic> params = {
    //   "pageNumber": pageNumber,
    //   "pageSize": pageSize,
    // };
    // final response = await Api.requestWishList(params);
    // if (response.succeeded) {
    //   final list = List.from(response.data ?? []).map((item) {
    //     return ProductModel.fromJson(item);
    //   }).toList();

    //   return [list, response.pagination];
    // }
    // AppBloc.messageCubit.onShow(response.message);
    // return null;
  }

  ///add wishList
  static Future<bool> addWishList(id, {bool isProduct = true}) async {
    List<int> wishList = [];
    final wishListString = Preferences.getString(isProduct
        ? Preferences.wishListProducts
        : Preferences.wishListPromotions);
    if (wishListString != null) {
      wishList = List.from(jsonDecode(wishListString));
      if (!wishList.any((element) => element == id)) {
        wishList.add(id);
        if (isProduct) {
          Application.wishListProducts = wishList;
        } else {
          Application.wishListPromotions = wishList;
        }
      }
    } else {
      wishList = [id];
      if (isProduct) {
        Application.wishListProducts = wishList;
      } else {
        Application.wishListPromotions = wishList;
      }
    }
    return await Preferences.setString(
        isProduct
            ? Preferences.wishListProducts
            : Preferences.wishListPromotions,
        jsonEncode(wishList));
    // final response = await Api.requestAddWishList(id);
    // if (response.succeeded) {
    //   return true;
    // }
    // AppBloc.messageCubit.onShow(response.message);
    // return false;
  }

  ///remove wishList
  static Future<bool> removeWishList(id, {bool isProduct = true}) async {
    List<int> wishList = [];
    final wishListString = Preferences.getString(isProduct
        ? Preferences.wishListProducts
        : Preferences.wishListPromotions);
    if (wishListString != null && wishListString.isNotEmpty) {
      wishList = List.from(jsonDecode(wishListString));
      if (wishList.isNotEmpty) {
        wishList.removeWhere((element) => element == id);
        if (isProduct) {
          Application.wishListProducts = wishList;
        } else {
          Application.wishListPromotions = wishList;
        }
      }
      return await Preferences.setString(
          isProduct
              ? Preferences.wishListProducts
              : Preferences.wishListPromotions,
          jsonEncode(wishList));
    }
    return false;

    // final response = await Api.requestRemoveWishList(id);
    // if (response.succeeded) {
    //   return true;
    // }
    // AppBloc.messageCubit.onShow(response.message);
    // return false;
  }

  ///clear wishList
  static Future<bool> clearWishList() async {
    Application.wishListProducts = [];
    return await Preferences.setString(
        Preferences.wishListProducts, jsonEncode([]));
    // final response = await Api.requestClearWishList();
    // if (response.succeeded) {
    //   return true;
    // }
    // AppBloc.messageCubit.onShow(response.message);
    // return false;
  }

  ///Upload image
  static Future<ResultApiModel> uploadImage(File file, progress) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.path),
    });
    return await Api.requestUploadImage(formData, progress);
  }

  ///load detail
  static Future<ProductModel?> loadProduct(id) async {
    final response = await Api.requestProduct({"id": id});
    if (response.succeeded) {
      return ProductModel.fromJson(response.data);
    }
    AppBloc.messageCubit.onShow(response.message);
    return null;
  }

  ///save product
  static Future<bool> saveProduct(params) async {
    final response = await Api.requestSaveProduct(params);
    if (response.succeeded) {
      return true;
    }
    AppBloc.messageCubit.onShow(response.message);
    return false;
  }

  ///Delete author item
  static Future<bool> removeProduct(id) async {
    final response = await Api.requestDeleteProduct(id);
    AppBloc.messageCubit.onShow(response.message);
    if (response.succeeded) {
      return true;
    }
    return false;
  }

  ///Delete author item
  static Future<List<String>?> loadTags(String keyword) async {
    final response = await Api.requestTags({"s": keyword});
    if (response.succeeded) {
      return List.from(response.data ?? []).map((e) {
        return e['name'] as String;
      }).toList();
    }
    AppBloc.messageCubit.onShow(response.message);
    return [];
  }
}
