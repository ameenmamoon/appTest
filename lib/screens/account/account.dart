import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/payment_methods.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() {
    return _AccountState();
  }
}

class _AccountState extends State<Account> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On logout
  void _onLogout() async {
    AppBloc.loginCubit.onLogout();
  }

  ///On deactivate
  void _onDeactivate() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translate.of(context).translate('deactivate')),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Text(
                Translate.of(context).translate('would_you_like_deactivate'),
                style: Theme.of(context).textTheme.bodyMedium,
              );
            },
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('close'),
              onPressed: () {
                Navigator.pop(context, false);
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
    if (result == true) {
      _confirmDeactivation();
      // AppBloc.loginCubit.onDeactivate("");
    }
  }

  ///On show message deactivate reason
  Future<String?> _confirmDeactivation() async {
    return await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? reason;
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('deactive_account'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  Translate.of(context)
                      .translate('help_us_improve_service_quality'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                AppTextInput(
                  maxLines: 6,
                  hintText: Translate.of(context)
                      .translate('reason_for_account_deactivation'),
                  controller: TextEditingController(),
                  textInputAction: TextInputAction.done,
                  onChanged: (text) {
                    setState(() {
                      reason = text;
                      // _errorContent = UtilValidator.validate(
                      //   text,
                      //   allowEmpty: true
                      // );
                    });
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      // _textContentController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            AppButton(
              Translate.of(context).translate('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              type: ButtonType.text,
            ),
            AppButton(
              Translate.of(context).translate('confirm'),
              onPressed: () {
                Navigator.pop(context, reason);
                AppBloc.loginCubit.onDeactivate(reason);
              },
            ),
          ],
        );
      },
    );
  }

  ///On navigation
  void _onNavigate(String route, {Object? arg}) {
    Navigator.pushNamed(context, route, arguments: arg);
  }

  ///On Preview Profile
  void _onProfile(UserModel user) {
    Navigator.pushNamed(context, Routes.profile, arguments: user);
  }

  ///On Get Support
  void _onGetSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'service@passionui.com',
      queryParameters: {'subject': '[PassionUI][Support]'},
    );
    try {
      launchUrl(uri);
    } catch (error) {
      UtilLogger.log("ERROR", error);
    }
  }

  ///On Rate App
  void _rateApp() {
        // Navigator.push(context, MaterialApp(home: PaymentMethods()), arguments: null);

    
    // final inAppReview = InAppReview.instance;
    // inAppReview.openStoreListing(appStoreId: '1515149819');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('account'),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserModel?>(
          builder: (context, user) {
            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AppUserInfo(
                      user: user,
                      type: UserViewType.information,
                      onPressed: () {
                        _onProfile(user);
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withAlpha(15),
                            spreadRadius: 4,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.deepPurple.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.location_history,
                                color: Colors.deepPurple,
                              ),
                            ),
                            title: Translate.of(context).translate(
                              'addresses',
                            ),
                            onPressed: () {
                              _onNavigate(Routes.addressList);
                            },
                          ),
                          const SizedBox(height: 12),
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.grey,
                              ),
                            ),
                            title: Translate.of(context).translate(
                              'shopping_cart',
                            ),
                            onPressed: () {
                              // _onNavigate(Routes.checkOut, arg: 1);
                              _onNavigate(Routes.shoppingCart);
                            },
                          ),
                          const SizedBox(height: 12),
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.blue,
                              ),
                            ),
                            title: Translate.of(context).translate(
                              'orders',
                            ),
                            onPressed: () {
                              _onNavigate(Routes.orderList);
                            },
                          ),
                          const SizedBox(height: 12),
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF9A825).withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.account_circle_outlined,
                                color: Color(0xFFF9A825),
                              ),
                            ),
                            title: Translate.of(context).translate(
                              'edit_profile',
                            ),
                            onPressed: () {
                              _onNavigate(Routes.editProfile);
                            },
                          ),
                          const SizedBox(height: 12),
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.lock_outline,
                                color: Colors.purple,
                              ),
                            ),
                            title: Translate.of(context).translate(
                              'change_password',
                            ),
                            onPressed: () {
                              _onNavigate(Routes.changePassword);
                            },
                          ),
                          const SizedBox(height: 12),
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.indigo.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.settings,
                                color: Colors.indigo,
                              ),
                            ),
                            title: Translate.of(context).translate('setting'),
                            onPressed: () {
                              _onNavigate(Routes.setting);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withAlpha(15),
                            spreadRadius: 4,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF9A825).withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.star_border,
                                color: Color(0xFFF9A825),
                              ),
                            ),
                            title: Translate.of(context).translate(
                              'rate_for_us',
                            ),
                            onPressed: _rateApp,
                          ),
                          const SizedBox(height: 12),
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.blue,
                              ),
                            ),
                            title: Translate.of(context).translate(
                              'contact_us',
                            ),
                            onPressed: _onGetSupport,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withAlpha(15),
                            spreadRadius: 4,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.no_accounts_outlined,
                                color: Colors.black,
                              ),
                            ),
                            title:
                                Translate.of(context).translate('deactivate'),
                            onPressed: _onDeactivate,
                          ),
                          const SizedBox(height: 12),
                          AppListTitle(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withAlpha(50),
                              ),
                              child: const Icon(
                                Icons.output_outlined,
                                color: Colors.red,
                              ),
                            ),
                            title: Translate.of(context).translate(
                              'sign_out',
                            ),
                            onPressed: _onLogout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
