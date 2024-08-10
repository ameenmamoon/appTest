import 'package:bloc/bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailLoading());
  ProductModel? product;

  void onLoad(int id) async {
    final result = await ListRepository.loadProduct(id);
    if (result != null) {
      product = result;
      emit(ProductDetailSuccess(product!));
    }
  }

  Future<bool> onFavorite() async {
    var result = false;
    if (product != null) {
      product!.isAddedFavorite = !product!.isAddedFavorite;
      emit(ProductDetailSuccess(product!));
      if (product!.isAddedFavorite) {
        result = await AppBloc.wishListCubit.onAdd(product!.id);
      } else {
        result = await AppBloc.wishListCubit.onRemove(product!.id);
      }
    }
    if (!result) {
      product!.isAddedFavorite = !product!.isAddedFavorite;
      emit(ProductDetailSuccess(product!));
    }
    return result;
  }

  Future<bool> onAddDeleteCart({String? color, String? size}) async {
    var result = false;
    if (product != null) {
      product!.isAddedCart = !product!.isAddedCart;
      emit(ProductDetailSuccess(product!));
      result = await OrderRepository.addDeleteCart(
          productId: product!.id, color: color, size: size);
    }
    if (!result) {
      product!.isAddedCart = !product!.isAddedCart;
      emit(ProductDetailSuccess(product!));
    }
    return result;
  }
}
