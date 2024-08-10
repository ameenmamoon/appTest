// import 'package:assets_audio_player/assets_audio_player.dart' as player;
import 'dart:convert';
import 'dart:io';

import 'package:supermarket/models/model.dart';
import 'package:supermarket/screens/home/home.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/screens/screen.dart';
import 'package:supermarket/screens/shopping_cart/shopping_cart.dart';
import 'package:supermarket/screens/wishlist/wishlist.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:vibration/vibration.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'screens/account/account2.dart';
import 'screens/promotion/promotion.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  _AppContainerState createState() {
    return _AppContainerState();
  }
}

class _AppContainerState extends State<AppContainer> {
  String _selected = Routes.home;
  String? _linkMessage;
  bool _isCreatingLink = false;
  final String dynamicLink = 'https://bisat.page.link';
  // final String Link = 'https://flutterfiretests.page.link/MEGs';

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages(
        AppLanguage.defaultLanguage.languageCode, timeago.ArMessages());
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  void handleLink(Uri uri) {
    List<String> seperatedLink = [];
    seperatedLink.addAll(uri.path.split("/")); // alsindbad.online and Arguments
    // uri.queryParameters
    if (seperatedLink[1] == 'product') {
      UtilOther.ShowProduct(
          context: context,
          productId: int.parse(seperatedLink[3]),
          categoryId: int.parse(seperatedLink[2]));
    } else if (seperatedLink[1] == 'profile') {
      Navigator.pushNamed(context, Routes.profile,
          arguments: {'userId': seperatedLink[2]});
    }
  }

  ///check route need auth
  bool _requireAuth(String route) {
    switch (route) {
      case Routes.home:
        return false;
      case Routes.promotion:
        return false;
      default:
        return true;
    }
  }

  ///Export index stack
  int _exportIndexed(String route) {
    switch (route) {
      case Routes.home:
        return 0;
      case Routes.promotion:
        return 1;
      case Routes.wishList:
        return 2;
      case Routes.shoppingCart:
        return 3;
      case Routes.account:
        return 4;
      default:
        return 0;
    }
  }

  ///Force switch home when authentication state change
  void _listenAuthenticateChange(AuthenticationState authentication) async {
    if (authentication == AuthenticationState.fail && _requireAuth(_selected)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: _selected,
      );
      if (result != null) {
        setState(() {
          _selected = result as String;
        });
      } else {
        setState(() {
          _selected = Routes.home;
        });
      }
    }
  }

  ///On change tab bottom menu and handle when not yet authenticate
  void _onItemTapped(String route) async {
    // AppBloc.discoveryCubit.onResetPagination();
    final signed = AppBloc.authenticateCubit.state != AuthenticationState.fail;
    if (!signed && _requireAuth(route)) {
      final result = await Navigator.pushNamed(
        context,
        Routes.signIn,
        arguments: route,
      );
      if (result == null) return;
    }
    setState(() {
      _selected = route;
    });
    // if (route == Routes.discovery) {
    //   AppBloc.discoveryCubit.onLoad(FilterModel.fromDefault());
    // }
  }

  ///Build Item Menu
  Widget _buildMenuItem(String route) {
    Color? color;
    String title = 'home';
    IconData iconData = Icons.help_outline;
    switch (route) {
      case Routes.home:
        iconData = Icons.home_outlined;
        title = 'home';
        break;
      case Routes.shoppingCart:
        iconData = Icons.shopping_cart;
        title = 'shopping_cart';
        break;
      case Routes.wishList:
        iconData = Icons.bookmark_outline;
        title = 'wish_list';
        break;
      case Routes.promotion:
        iconData = Icons.discount_outlined;
        title = 'promotions';
        break;
      case Routes.account:
        iconData = Icons.account_circle_outlined;
        title = 'account';
        break;
      default:
        iconData = Icons.home_outlined;
        title = 'home';
        break;
    }
    if (route == _selected) {
      color = Theme.of(context).primaryColor;
    }
    if (route == Routes.chatList) {
      return IconButton(
        onPressed: () {
          _onItemTapped(route);
        },
        padding: EdgeInsets.zero,
        icon: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: color,
                ),
                const SizedBox(height: 2),
                Text(
                  Translate.of(context).translate(title),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 10,
                        color: color,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ],
        ),
      );
    }
    return IconButton(
      onPressed: () {
        _onItemTapped(route);
      },
      padding: EdgeInsets.zero,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: color,
          ),
          const SizedBox(height: 2),
          Text(
            Translate.of(context).translate(title),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 10,
                  color: color,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  ///Build bottom menu
  Widget _buildBottomMenu() {
    return BottomAppBar(
      height: 70,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMenuItem(Routes.home),
            _buildMenuItem(Routes.promotion),
            _buildMenuItem(Routes.wishList),
            _buildMenuItem(Routes.shoppingCart),
            _buildMenuItem(Routes.account),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const submitPosition = FloatingActionButtonLocation.centerDocked;

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, authentication) async {
        _listenAuthenticateChange(authentication);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _exportIndexed(_selected),
          children: const <Widget>[
            Home(),
            Promotion(),
            WishList(),
            WishList(), //ShoppingCart(),
            Account()
          ],
        ),
        bottomNavigationBar: _buildBottomMenu(),
        // floatingActionButton: _buildSubmit(),
        floatingActionButtonLocation: submitPosition,
      ),
    );
  }
}
