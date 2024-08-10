import 'dart:io';

import 'package:supermarket/configs/application.dart';
import 'package:supermarket/configs/preferences.dart';
import 'package:supermarket/widgets/app_button.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';

import '../configs/routes.dart';

class UtilOther {
  static fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode next,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static hiddenKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<DeviceModel?> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final android = await deviceInfoPlugin.androidInfo;
        return DeviceModel(
          uuid: android.id,
          model: "Android",
          version: android.version.sdkInt.toString(),
          type: android.model,
        );
      } else if (Platform.isIOS) {
        final IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;
        return DeviceModel(
          uuid: ios.identifierForVendor ?? '',
          name: ios.name,
          model: ios.systemName,
          version: ios.systemVersion,
          type: ios.utsname.machine,
        );
      }
    } catch (e) {
      UtilLogger.log("ERROR", e);
    }
    return null;
  }

  static Future<String?> getDeviceToken() async {
    // await FirebaseMessaging.instance.requestPermission();
    // await FirebaseMessaging.instance.subscribeToTopic('all');
    try {
      //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //     // استقبال الإشعار عندما يتم استلامه أثناء فتح التطبيق
      //     print('تم استلام إشعار: ${message.notification!.title}');
      //     // يمكنك استخدام message.notification!.body للوصول إلى نص الإشعار
      //   });
      //   FirebaseMessaging.onBackgroundMessage((message) async {
      //     //استلام الإشعارات في الخلفية أو عندما تكون تطبيقك في وضع السكون
      //     print('تم استلام إشعار: ${message.notification!.title}');
      //     // يمكنك استخدام message.notification!.body للوصول إلى نص الإشعار
      //   });
      //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //     Navigator.pushNamed(context, routeName)
      //     // استقبال الإشعار عندما يتم فتح التطبيق من الإشعار المنبثق
      //     print('تم فتح التطبيق من خلال الإشعار: ${message.notification!.title}');
      //     // يمكنك استخدام message.notification!.body للوصول إلى نص الإشعار
      //     message.data['deepLink'];
      //   });

      //   FirebaseMessaging.onBackgroundMessage(
      //       _firebaseMessagingBackgroundHandler);
      if (Preferences.getString("deviceToken") == null) {
        FirebaseMessaging.instance.deleteToken();
        try {
          await FirebaseMessaging.instance.subscribeToTopic('unsubscribed');
          await FirebaseMessaging.instance.unsubscribeFromTopic('subscribed');
        } catch (ex) {}
        var token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          print('تم استلام توكن الجهاز: $token');
          Preferences.setString("deviceToken", token);
          return token;
        }
      }

      return Preferences.getString("deviceToken");
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  // static Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // استقبال الإشعار عندما يتم استئناف التطبيق من الخلفية بالإشعار المنبثق
  //   print(
  //       'استئناف التطبيق من الخلفية بواسطة الإشعار: ${message.notification!.title}');
  //   // يمكنك استخدام message.notification!.body للوصول إلى نص الإشعار
  // }

  static Map<String, dynamic> buildFilterParams(FilterModel filter) {
    Map<String, dynamic> params = {
      "searchString": filter.searchString,
      "category": filter.category?.id,
      "byImage": filter.byImage,
    };
    if (filter.minPriceFilter != null) {
      params['priceMin'] = filter.minPriceFilter!.toInt();
    }
    if (filter.maxPriceFilter != null) {
      params['priceMax'] = filter.maxPriceFilter!.toInt();
    }
    if (filter.containsList != null && filter.containsList!.isNotEmpty) {
      params['containsList'] =
          filter.containsList!.map((item) => item).toList();
    }
    if (filter.sortOptions != null) {
      params['orderby'] = filter.sortOptions!.field;
      params['order'] = filter.sortOptions!.value;
    }
    return params;
  }

  ///On show message
  static void showMessage(
      {required BuildContext context,
      required String title,
      required String message,
      VoidCallback? func,
      String? funcName}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            if (func != null)
              AppButton(
                funcName!,
                onPressed: func,
                type: ButtonType.text,
              ),
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
          ],
        );
      },
    );
  }

  static void ShowProduct(
      {required BuildContext context,
      required int productId,
      required int categoryId}) {
    Navigator.pushNamed(
      context,
      Routes.productDetail,
      arguments: {
        "id": productId,
        "categoryId": categoryId,
      },
    );
  }

  static Future<String> createDynamicLink(
      String dynamicLink, bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bisat.page.link',
      longDynamicLink: Uri.parse(
        dynamicLink,
      ),
      link: Uri.parse(dynamicLink),
      androidParameters: const AndroidParameters(
        packageName: 'com.arma.supermarket',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.arma.supermarket',
        minimumVersion: '0',
      ),
      // socialMetaTagParameters: SocialMetaTagParameters(title: )
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    }

    return url.toString();
  }

  ///Singleton factory
  static final UtilOther _instance = UtilOther._internal();

  factory UtilOther() {
    return _instance;
  }

  UtilOther._internal();
}
