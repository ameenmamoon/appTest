import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../bloc.dart';

class MessageCubit extends Cubit<NewNotificationMessage?> {
  MessageCubit() : super(null);
  Timer? timer;

  void onShow(
    String message, {
    String? title,
    NotificationMessageType type = NotificationMessageType.public,
    Widget? mainButton,
    Widget? icon,
    Color? messageTextColor,
    Color? backgroundColor,
    Color? fontTitleTextColor,
    Color? fontMessageColor,
  }) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      emit(NewNotificationMessage(
          title: title,
          message: message,
          type: type,
          mainButton: mainButton,
          icon: icon,
          fontTitleTextColor: fontTitleTextColor,
          fontMessageColor: fontMessageColor,
          messageTextColor: messageTextColor,
          backgroundColor: backgroundColor));
      emit(null);
    });
  }
  // void onShow({required NotificationMessageType type,required String message}) {
  //   timer?.cancel();
  //   timer = Timer(const Duration(milliseconds: 500), () {
  //     emit(message);
  //     emit(null);
  //   });
  // }
}
