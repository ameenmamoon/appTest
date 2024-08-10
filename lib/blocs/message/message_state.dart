import 'package:supermarket/models/model.dart';
import 'package:flutter/widgets.dart';

abstract class MessageState {}

class NewNotificationMessage extends MessageState {
  final String? title;
  final String? message;
  final NotificationMessageType type;
  final Widget? mainButton;
  final Widget? icon;
  final Color? messageTextColor;
  final Color? backgroundColor;
  final Color? fontTitleTextColor;
  final Color? fontMessageColor;

  NewNotificationMessage({
    required this.title,
    required this.message,
    required this.type,
    this.mainButton,
    this.icon,
    this.fontTitleTextColor,
    this.fontMessageColor,
    this.messageTextColor,
    this.backgroundColor,
  });
}

enum NotificationMessageType {
  public,
  message,
}
