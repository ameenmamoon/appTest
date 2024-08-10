// import 'package:workmanager/workmanager.dart';

import 'dart:convert';
import 'dart:io';

import 'package:supermarket/splash_screen.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

import 'main.dart';
import 'notificationservice_.dart';
import 'widgets/widget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supermarket/app_container.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/screens/screen.dart';
import 'package:supermarket/utils/utils.dart';

import 'repository/location_repository.dart';
import 'package:timezone/data/latest.dart' as tz;

class App extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    configureFirebaseMessaging();

    tz.initializeTimeZones();
    onSetup();
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  Future<void> configureFirebaseMessaging() async {
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) {
    //   // _handleMessage(initialMessage);
    // }
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.subscribeToTopic('all');
    try {
      // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        var metaData = message.data['metaData'];
        if (metaData == null) return;
        var data = jsonDecode(metaData);
        if (data.controller == 'notify') {
          switch (data.action) {
            case 'ADS_PRODUCT':
              // emit(NotifyNewView());
              break;
            case 'ADS_PROMOTION':
              // emit(NotifyNewView());
              break;
            case 'ORDER_CONFIRM':

              // AppBloc.realTimeCubit.notify(jsonDecode(metaData));
              // emit(NotifyNewView());
              break;
          }
        }
        // print('Got a message whilst in the foreground!');
        // print('Message data: ${message.data}');
        if (message.notification != null) {
          // print('Message also contained a notification: ${message.notification}');
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('تم فتح التطبيق من خلال الإشعار:');
      });
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } catch (ex) {
      print(ex);
    }
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

  void onSetup() async {
    await Preferences.setPreferences();
    // AppBloc.applicationCubit.onSplash();
    AppBloc.applicationCubit.onSetup();
  }

  void onOrderConfirm(int id) async {
    Navigator.pushNamed(
      context,
      Routes.orderItemList,
      arguments: RouteArguments(
        item: id,
        callback: AppBloc.orderListCubit.onLoad,
      ),
    ).then((value) {
      AppBloc.orderListCubit.onLoad();
    });
  }

  void onShowProductAds(int id) async {
    Navigator.pushNamed(
      context,
      Routes.orderItemList,
      arguments: RouteArguments(
        item: id,
        callback: AppBloc.orderListCubit.onLoad,
      ),
    ).then((value) {
      AppBloc.orderListCubit.onLoad();
    });
  }

  void onShowPromotionAds(int id) async {
    Navigator.pushNamed(
      context,
      Routes.orderItemList,
      arguments: RouteArguments(
        item: id,
        callback: AppBloc.orderListCubit.onLoad,
      ),
    ).then((value) {
      AppBloc.orderListCubit.onLoad();
    });
  }

  // void _handleMessage(RemoteMessage message) {
  //   // if (message.data['deepLink'] == Routes.chat) {
  //   var metaData = message.data['metaData'];
  //   var sender = jsonDecode(metaData);
  //   Navigator.pushNamed(context, message.data['deepLink'],
  //       arguments: ChatUserModel(
  //           userId: sender['UserId'],
  //           chatId: sender['ChatId'],
  //           firstName: sender['AccountName'],
  //           userName: sender['UserName'],
  //           lastName: sender['FullName'],
  //           profilePictureDataUrl: sender['ProfilePictureDataUrl'] ?? ''));
  //   // }
  // }

  void showFloatingFlushbar(
      {required BuildContext? context,
      required String? title,
      required String? message,
      required Widget? mainButton,
      required Widget? icon,
      required Color? fontTitleTextColor,
      required Color? fontMessageColor,
      required Color? messageTextColor,
      required Color? backgroundColor,
      required bool? isError}) {
    try {
      Flushbar<bool?> flush = Flushbar<bool?>(
          title: title,
          titleColor: fontTitleTextColor,
          duration: const Duration(seconds: 3),
          // message: message,
          messageText: Container(
            color: messageTextColor,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context!).size.height * 0.2,
              minHeight: 1,
            ),
            child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical, //.horizontal
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: fontMessageColor),
                    ),
                  ],
                )),
          ),
          backgroundColor: backgroundColor ?? Colors.grey,
          // duration: const Duration(seconds: 3),
          // duration: const Duration(hours: 1),
          margin: const EdgeInsets.all(20),
          icon: icon,
          mainButton:
              mainButton) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
        ..show(context).then((result) {});
    } catch (ex) {}
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, lang) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, theme) {
              return MaterialApp(
                navigatorKey: App.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: theme.lightTheme,
                darkTheme: theme.darkTheme,
                onGenerateRoute: Routes.generateRoute,
                locale: lang,
                localizationsDelegates: const [
                  Translate.delegate,
                  CountryLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLanguage.supportLanguage,
                home: Scaffold(
                  // drawer: Application.mainDrawer,
                  key: Application.scaffoldKey,
                  body: BlocListener<MessageCubit, MessageState?>(
                    listener: (context, messageState) {
                      if (messageState != null &&
                          messageState is NewNotificationMessage) {
                        // final snackBar = SnackBar(
                        //   content: Text(
                        //     Translate.of(context)
                        //         .translate(messageState.message),
                        //   ),
                        // );
                        showFloatingFlushbar(
                            context: context,
                            title: messageState.title,
                            message: messageState.message,
                            mainButton: messageState.mainButton,
                            icon: messageState.icon,
                            fontTitleTextColor:
                                messageState.fontTitleTextColor ?? Colors.white,
                            fontMessageColor:
                                messageState.fontMessageColor ?? Colors.white,
                            messageTextColor: messageState.messageTextColor,
                            backgroundColor: messageState.backgroundColor,
                            isError: false);
                      }
                    },
                    child: BlocBuilder<ApplicationCubit, ApplicationState>(
                      builder: (context, application) {
                        if (application == ApplicationState.intro) {
                          return const Intro();
                        }
                        return const AppContainer();
                      },
                    ),
                  ),
                ),
                builder: (context, child) {
                  final data = MediaQuery.of(context).copyWith(
                    textScaleFactor: theme.textScaleFactor,
                  );
                  return MediaQuery(
                    data: data,
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
