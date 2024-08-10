import 'package:bloc/bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';
import 'package:supermarket/utils/utils.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState.loading);

  Future<void> onCheck() async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event load user
    UserModel? user = await AppBloc.userCubit.onLoadUser();

    if (user != null) {
      ///Save user
      await AppBloc.userCubit.onSaveUser(user);

      ///Valid token server
      final result = await UserRepository.validateToken();

      if (result) {
        ///Load wishList
        AppBloc.wishListCubit.onLoad();

        ///Fetch user
        AppBloc.userCubit.onFetchUser();

        ///Notify
        emit(AuthenticationState.success);
      } else {
        ///Logout
        onClear();
      }
    } else {
      ///Notify
      emit(AuthenticationState.fail);
    }
  }

  Future<void> onSave(UserModel user) async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event Save user
    // AppBloc.userCubit.onSaveUser(user).ignore();
    // await AppBloc.initCubit.onLoad();
    // ///Event Save user
    await AppBloc.userCubit.onSaveUser(user);

    ///Load wishList
    AppBloc.wishListCubit.onLoad();

    /// Notify
    emit(AuthenticationState.success);
  }

  void onClear() {
    /// Notify
    emit(AuthenticationState.fail);

    ///Delete user
    AppBloc.userCubit.onDeleteUser();
  }
}
