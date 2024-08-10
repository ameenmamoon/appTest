import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/api/api.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../repository/location_repository.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationState.completed);

  String? progressText;
  Function(int, int)? progress;

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup(Application.host);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //connected
        return true;
      }
    } on SocketException catch (_) {
      //not connected
      return false;
    }
    return false;
  }

  ///On Loading Data Baisc
  void onLoading() async {
    var firstInit = Preferences.getBool(Preferences.firstInit);
    if (await checkInternet()) {
      //connected
      if (firstInit == true) {
        emit(ApplicationState.completed);
      } else {
        emit(ApplicationState.intro);
      }
    } else {}
  }

  ///On Setup Application
  void onSetup() async {
    progressText = '';

    ///Get old Theme & Font & Language & Dark Mode & Domain
    await Preferences.setPreferences();
    ListRepository.loadWishListProducts();
    ListRepository.loadWishListPromotions();
    ListRepository.loadShoppingCartProducts();
    ListRepository.loadShoppingCartPromotions();
    var firstInit = Preferences.getBool(Preferences.firstInit);

    final oldTheme = Preferences.getString(Preferences.theme);
    final oldFont = Preferences.getString(Preferences.font);
    final oldLanguage = Preferences.getString(Preferences.language);
    final oldDarkOption = Preferences.getString(Preferences.darkOption);
    final oldDomain = Preferences.getString(Preferences.domain);
    final oldTextScale = Preferences.getDouble(Preferences.textScaleFactor);

    DarkOption? darkOption;
    String? font;
    ThemeModel? theme;
    emit(ApplicationState.intro);

    ///Setup domain
    if (oldDomain != null) {
      Application.domain = oldDomain;
    }

    ///Setup Language
    if (oldLanguage != null) {
      AppBloc.languageCubit.onUpdate(Locale(oldLanguage));
    }

    ///Find font support available [Dart null safety issue]
    try {
      font = AppTheme.fontSupport.firstWhere((item) {
        return item == oldFont;
      });
    } catch (e) {
      UtilLogger.log("ERROR", e);
    }

    ///Setup theme
    if (oldTheme != null) {
      theme = ThemeModel.fromJson(jsonDecode(oldTheme));
    }

    ///check old dark option
    if (oldDarkOption != null) {
      switch (oldDarkOption) {
        case 'off':
          darkOption = DarkOption.alwaysOff;
          break;
        case 'on':
          darkOption = DarkOption.alwaysOn;
          break;
        default:
          darkOption = DarkOption.dynamic;
      }
    }

    ///Setup application & setting
    final results = await Future.wait([
      PackageInfo.fromPlatform(),
      UtilOther.getDeviceInfo(),
      // Firebase.initializeApp(),
    ]);
    Application.packageInfo = results[0] as PackageInfo;
    Application.device = results[1] as DeviceModel;

    ///Setup Theme & Font with dark Option
    AppBloc.themeCubit.onChangeTheme(
      theme: theme,
      font: font,
      darkOption: darkOption,
      textScaleFactor: oldTextScale,
    );

    // This is just a basic example. For real apps, you must show some
    // friendly dialog box before call the request method.
    // This is very important to not harm the user experience

    ///Start location service
    AppBloc.locationCubit.onLocationService();

    ///Authentication begin check
    await AppBloc.authenticateCubit.onCheck();

    // bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) {
    //   AwesomeNotifications().requestPermissionToSendNotifications();
    // }

    ///First or After upgrade version show intro preview app
    final hasReview = Preferences.containsKey(
      '${Preferences.reviewIntro}.${Application.packageInfo?.version}',
    );
    if (hasReview) {
      if (Preferences.get(Preferences.setting) != null &&
          Preferences.get(Preferences.submitSettingDate) != null) {
        var firstInit = Preferences.getBool(Preferences.firstInit);
        if (firstInit == null || firstInit == false) {
          try {} catch (ex) {}

          await Preferences.setBool(Preferences.firstInit, true);
        }
        emit(ApplicationState.completed);
      }
    } else {
      ///Notify
      emit(ApplicationState.intro);
    }
  }

  ///On Complete Intro
  void onCompletedIntro() async {
    await Preferences.setBool(
      '${Preferences.reviewIntro}.${Application.packageInfo?.version}',
      true,
    );

    ///Notify
    emit(ApplicationState.completed);
  }

  ///On Change Domain
  void onChangeDomain(String domain) async {
    emit(ApplicationState.intro);
    emit(ApplicationState.completed);
    final isDomain = Uri.tryParse(domain);
    if (isDomain != null) {
      Application.domain = domain;
      Api.httpManager.changeDomain(domain);
      await Preferences.setString(
        Preferences.domain,
        domain,
      );
      await Future.delayed(const Duration(milliseconds: 250));
      AppBloc.authenticateCubit.onClear();
      emit(ApplicationState.completed);
    } else {
      AppBloc.messageCubit.onShow('domain_not_correct');
    }
  }
}
