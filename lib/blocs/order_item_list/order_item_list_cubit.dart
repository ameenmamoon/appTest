// import 'package:bloc/bloc.dart';
// import 'package:supermarket/configs/config.dart';
// import 'package:supermarket/models/model.dart';
// import 'package:supermarket/repository/repository.dart';

// import 'cubit.dart';

// class OrderItemListCubit extends Cubit<OrderItemListState> {
//   OrderItemListCubit() : super(OrderItemListLoading());

//   void onLoad(id) async {
//     final result = await OrderRepository.loadDetail(id: id);
//     if (result != null) {
//       emit(OrderItemListSuccess(orderItemList: result));
//     }
//   }

//   Future<void> onCancel(orderId, orderItemId) async {
//     final result = await OrderRepository.cancelItem(orderId, orderItemId);
//     if (result) {
//       onLoad(orderId);
//       // emit(OrderItemListSuccess(orderItemList: result));
//     }
//   }
// }
