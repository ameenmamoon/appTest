import 'package:bloc/bloc.dart';
import 'package:supermarket/blocs/app_bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/repository/repository.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../models/model_user.dart';

enum LoginState {
  init,
  loading,
  success,
  fail,
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.init);

  void onLogin({
    required String phoneNumber,
    required String password,
  }) async {
    ///Notify
    emit(LoginState.loading);
    UserModel? result;
    try {
      var token = await UtilOther.getDeviceToken() ?? '';
      print(token);
      result = await UserRepository.login(
        phoneNumber: phoneNumber,
        password: password,
        token: token,
      );
      if (result != null) {
        ///Begin start Auth flow
        await AppBloc.authenticateCubit.onSave(result);

        ///Notify
        emit(LoginState.success);
      } else {
        ///Notify
        emit(LoginState.fail);
      }
    } catch (ex) {
      if (result != null) {
        ///Begin start Auth flow
        await AppBloc.authenticateCubit.onSave(result);

        ///Notify
        emit(LoginState.success);
      } else {
        ///Notify
        emit(LoginState.fail);
      }
    }
  }

  void onFetch() async {
    ///Notify
    emit(LoginState.loading);

    ///login via repository
    final result = await UserRepository.fetch();

    if (result != null) {
      ///Begin start Auth flow
      await AppBloc.authenticateCubit.onSave(result);

      ///Notify
      emit(LoginState.success);
    } else {
      ///Notify
      emit(LoginState.fail);
    }
  }

  void onLogout() async {
    ///Begin start auth flow
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic('subscribed');
      await FirebaseMessaging.instance.subscribeToTopic('unsubscribed');
    } catch (ex) {}
    emit(LoginState.init);
    AppBloc.authenticateCubit.onClear();
  }

  void onDeactivate(String? deactiveReason) async {
    final result = await UserRepository.deactivate(deactiveReason);
    if (result) {
      AppBloc.authenticateCubit.onClear();
    }
  }
}
