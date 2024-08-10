import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supermarket/blocs/login/login_cubit.dart';
import 'package:supermarket/configs/routes.dart';
import 'package:supermarket/repository/user_repository.dart';
import 'package:supermarket/utils/other.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/widgets/app_button.dart';
import 'package:supermarket/widgets/rounded_input.dart';

class ForgotPassword2 extends StatelessWidget {
  ForgotPassword2({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
    required this.textPhoneNumberController,
    required this.focusPhoneNumber,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  final TextEditingController textPhoneNumberController;
  final FocusNode focusPhoneNumber;

  String? _errorPhoneNumber;

  ///On sign up
  ///Fetch API
  void _forgotPassword(BuildContext context) {
    if (_errorPhoneNumber == null) {
      UserRepository.validationPhoneNumber(
              countryCode: '', phoneNumber: textPhoneNumberController.text)
          .then((value) {
        if (value) {
          Navigator.pushNamed(
            context,
            Routes.otpForgotPassword,
            arguments: {
              "countryCode": '',
              "phoneNumber": textPhoneNumberController.text
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLogin ? 0.0 : 1.0,
      duration: animationDuration * 5,
      child: Visibility(
        visible: !isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    Translate.of(context).translate('forgot_password'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 40),
                  SvgPicture.asset('assets/images/register.svg'),
                  const SizedBox(height: 40),
                  RoundedInput(
                    controller: textPhoneNumberController,
                    icon: Icons.phone_enabled,
                    focusNode: focusPhoneNumber,
                    hint: Translate.of(context).translate('input_phone_number'),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    trailing: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        textPhoneNumberController.clear();
                      },
                      child: const Icon(Icons.clear),
                    ),
                    onSubmitted: (text) {},
                  ),
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
                        child: AppButton(
                          Translate.of(context).translate('reset_password'),
                          mainAxisSize: MainAxisSize.max,
                          onPressed: () {
                            UtilOther.hiddenKeyboard(context);
                            _forgotPassword(context);
                          },
                          loading: login == LoginState.loading,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
