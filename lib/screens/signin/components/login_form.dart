import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supermarket/blocs/app_bloc.dart';
import 'package:supermarket/blocs/login/login_cubit.dart';
import 'package:supermarket/utils/other.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/widgets/app_button.dart';
import 'package:supermarket/widgets/rounded_button.dart';
import 'package:supermarket/widgets/rounded_input.dart';
import 'package:supermarket/widgets/rounded_password_input.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
    required this.textPhoneNumberController,
    required this.textPassController,
    required this.focusPhoneNumber,
    required this.focusPass,
    required this.forgotPassword,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  // final bool _showPassword = false;
  final ValueNotifier<bool> _showPassword = ValueNotifier<bool>(false);

  final TextEditingController textPhoneNumberController;
  final TextEditingController textPassController;
  final FocusNode focusPhoneNumber;
  final FocusNode focusPass;
  final Function() forgotPassword;

  String? _errorID;
  String? _errorPass;

  ///On login
  void _login() async {
    AppBloc.loginCubit.onLogin(
      phoneNumber: textPhoneNumberController.text,
      password: textPassController.text,
    );
    if (AppBloc.userCubit.state != null) {
      AppBloc.loginCubit.onFetch();
      AppBloc.homeCubit.onLoad();
    }

    if (AppBloc.userCubit.state != null) {
      // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      //   if (!isAllowed) {
      //     // This is just a basic example. For real apps, you must show some
      //     // friendly dialog box before call the request method.
      //     // This is very important to not harm the user experience
      //     AwesomeNotifications().requestPermissionToSendNotifications();
      //   }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLogin ? 1.0 : 0.0,
      duration: animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: size.width,
          height: defaultLoginSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Translate.of(context).translate('welcome_back'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 40),
                SvgPicture.asset('assets/images/login.svg'),
                const SizedBox(height: 40),
                RoundedInput(
                  controller: textPhoneNumberController,
                  icon: Icons.phone_enabled,
                  focusNode: focusPhoneNumber,
                  hint: Translate.of(context).translate('phone_number'),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      textPhoneNumberController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      focusPhoneNumber,
                      focusPass,
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: _showPassword,
                    builder: (context, value, child) {
                      return RoundedInput(
                        controller: textPassController,
                        icon: Icons.lock,
                        focusNode: focusPass,
                        hint: Translate.of(context).translate('password'),
                        obscureText: !_showPassword.value,
                        textInputAction: TextInputAction.done,
                        trailing: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          onTap: () {
                            _showPassword.value = !_showPassword.value;
                          },
                          child: Icon(_showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        onSubmitted: (text) {
                          UtilOther.hiddenKeyboard(context);
                          _login();
                        },
                      );
                    }),
                const SizedBox(height: 10),
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, login) {
                    // return RoundedButton(
                    //   title: Translate.of(context).translate('sign_in'),
                    //                       //   loading: login == LoginState.loading,
                    //   action: () {
                    //     UtilOther.hiddenKeyboard(context);
                    //     _login();
                    //   },
                    // );
                    return Container(
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        alignment: Alignment.center,
                        child: Column(children: [
                          AppButton(
                            Translate.of(context).translate('sign_in'),
                            mainAxisSize: MainAxisSize.max,
                            onPressed: () {
                              UtilOther.hiddenKeyboard(context);
                              _login();
                            },
                            loading: login == LoginState.loading,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              AppButton(
                                Translate.of(context)
                                    .translate('forgot_password'),
                                onPressed: forgotPassword,
                                type: ButtonType.text,
                                fontSize: 13,
                              ),
                            ],
                          )
                        ]));
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
