import 'dart:async';
import 'dart:core';
import 'dart:math';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supermarket/app.dart';
import 'package:supermarket/payment_screen.dart';
import 'package:supermarket/utils/utils.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:workmanager/workmanager.dart';

import 'blocs/app_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    UtilLogger.log('BLOC ONCHANGE', change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    UtilLogger.log('BLOC EVENT', event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    UtilLogger.log('BLOC ERROR', error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    UtilLogger.log('BLOC TRANSITION', transition);
    super.onTransition(bloc, transition);
  }
}

// Future<void> initNotification() async {
//   tzl.initializeTimeZones();
//   await AwesomeNotifications().initialize(
//       // set the icon to null if you want to use the default app icon
//       null, //Images.alarm, // 'resource://drawable/mipmap/ic_launcher', //https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png
//       [
//         NotificationChannel(
//             channelGroupKey: 'basic_channel_group',
//             channelKey: 'basic_channel',
//             channelName: 'Basic notifications',
//             channelDescription: 'Notification channel for basic tests',
//             defaultColor: const Color(0xFF9D50DD),
//             ledColor: Colors.white)
//       ],
//       // Channel groups are only visual and are not required
//       channelGroups: [
//         NotificationChannelGroup(
//             channelGroupKey: 'basic_channel_group',
//             channelGroupName: 'Basic group')
//       ],
//       debug: false);
// }

// Future<bool> displayNotificationRationale() async {
//   bool userAuthorized = AppBloc.userCubit.state != null;
//   BuildContext context = App.navigatorKey.currentContext!;
//   await showDialog(
//       context: context,
//       builder: (BuildContext ctx) {
//         return AlertDialog(
//           title: Text('Get Notified!',
//               style: Theme.of(context).textTheme.titleLarge),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Image.asset(
//                       'assets/animated-bell.gif',
//                       height: MediaQuery.of(context).size.height * 0.3,
//                       fit: BoxFit.fitWidth,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                   'Allow Awesome Notifications to send you beautiful notifications!'),
//             ],
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text(
//                   'Deny',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge
//                       ?.copyWith(color: Colors.red),
//                 )),
//             TextButton(
//                 onPressed: () async {
//                   userAuthorized = true;
//                   Navigator.of(ctx).pop();
//                 },
//                 child: Text(
//                   'Allow',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge
//                       ?.copyWith(color: Colors.deepPurple),
//                 )),
//           ],
//         );
//       });
//   return userAuthorized &&
//       await AwesomeNotifications().requestPermissionToSendNotifications();
// }

// void showNotification({required models.NotificationModel notification}) async {
//   Random random = Random();
//   bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//   if (!isAllowed) isAllowed = await displayNotificationRationale();
//   if (!isAllowed) return;
//   AwesomeNotifications().cancelAll();
//   if (DateTime.parse(notification.expiryDate!).millisecondsSinceEpoch <=

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const App());
  // runApp(const PaymentScreen());
}
