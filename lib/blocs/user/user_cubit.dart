import 'package:supermarket/configs/preferences.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';

import '../../configs/application.dart';
import 'package:supermarket/blocs/bloc.dart';
import '../app_bloc.dart';

class UserCubit extends Cubit<UserModel?> {
  UserCubit() : super(null);

  int pageCompanies = 1;
  List<UserModel> listCompanies = [];
  PaginationModel? paginationCompanies;

  ///Event load user
  Future<UserModel?> onLoadUser() async {
    UserModel? user = await UserRepository.loadUser();
    emit(user);
    return user;
  }

  ///Event fetch user
  Future<UserModel?> onFetchUser() async {
    UserModel? local = await UserRepository.loadUser();
    UserModel? remote = await UserRepository.fetchUser();
    if (local != null && remote != null) {
      final sync = local.updateUser(
        firstName: remote.firstName,
        lastName: remote.lastName,
        phoneNumber: remote.phoneNumber,
        email: remote.email,
        url: remote.url,
        description: remote.description,
        image: remote.profilePictureDataUrl,
        topics: remote.topics,
      );
      onSaveUser(sync);
      return sync;
    }
    return null;
  }

  ///Event save user
  Future<void> onSaveUser(UserModel user) async {
    await UserRepository.saveUser(user: user);
    emit(user);
  }

  ///Event delete user
  Future<void> onDeleteUser() async {
    FirebaseMessaging.instance.deleteToken();
    Preferences.remove("deviceToken");
    UserRepository.deleteUser();
    emit(null);
  }

  ///Event update user
  Future<bool> onUpdateUser({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String? email,
  }) async {
    ///Fetch change profile
    final result = await UserRepository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
    );

    ///Case success
    if (result) {
      await onFetchUser();
    }
    return result;
  }

  ///Event change password
  Future<bool> onChangePassword(
      String newPassword, String confirmNewPassword, String password) async {
    return await UserRepository.changePassword(
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
        password: password);
  }

  ///Event register
  Future<String?> onRegister({
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    return await UserRepository.register(
      firstName: firstName,
      lastName: lastName,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> onLoad(String searchString) async {
    pageCompanies = 1;

    ///Notify
    // emit(UserLoading());

    ///Fetch API
    final result = await UserRepository.loadProfiles(
        pageNumber: pageCompanies,
        pageSize: Application.pageSize,
        searchString: searchString);

    if (result != null) {
      listCompanies = result[0];
      paginationCompanies = result[1];

      ///Notify
      // emit(UserSuccess(
      //   list: listCompanies,
      //   canLoadMore: paginationCompanies!.currentPage < paginationCompanies!.totalPages,
      // ));
    }
  }
}
