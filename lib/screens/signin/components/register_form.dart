import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supermarket/blocs/app_bloc.dart';
import 'package:supermarket/blocs/login/login_cubit.dart';
import 'package:supermarket/configs/routes.dart';
import 'package:supermarket/repository/user_repository.dart';
import 'package:supermarket/utils/other.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/utils/validate.dart';
import 'package:supermarket/widgets/app_button.dart';
import 'package:supermarket/widgets/rounded_button.dart';
import 'package:supermarket/widgets/rounded_input.dart';
import 'package:supermarket/widgets/rounded_password_input.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
    required this.textFirstNameController,
    required this.textLastNameController,
    required this.textPassController,
    required this.textConfirmPassController,
    required this.textPhoneNumberController,
    required this.focusFirstName,
    required this.focusLastName,
    required this.focusPass,
    required this.focusConfirmPass,
    required this.focusPhoneNumber,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  final ValueNotifier<bool> _showPassword = ValueNotifier<bool>(false);

  final TextEditingController textFirstNameController;
  final TextEditingController textLastNameController;
  final TextEditingController textPassController;
  final TextEditingController textConfirmPassController;
  final TextEditingController textPhoneNumberController;
  final FocusNode focusFirstName;
  final FocusNode focusLastName;
  final FocusNode focusPass;
  final FocusNode focusConfirmPass;
  final FocusNode focusPhoneNumber;

  String? _errorFirstName;
  String? _errorLastName;
  String? _errorPass;
  String? _errorConfirmPass;
  String? _errorPhoneNumber;

  ///On sign up
  void _signUp(BuildContext context) async {
    UtilOther.hiddenKeyboard(context);
    _errorFirstName =
        UtilValidator.validate(textFirstNameController.text, min: 3);
    if (_errorFirstName != null) {
      AppBloc.messageCubit.onShow(
          Translate.of(context).translate(_errorFirstName!),
          title: Translate.of(context).translate('first_name'),
          icon: const Icon(Icons.error, color: Colors.red),
          fontMessageColor: Colors.black,
          fontTitleTextColor: Colors.black,
          backgroundColor: Colors.white);
    }

    _errorLastName =
        UtilValidator.validate(textLastNameController.text, min: 3);
    if (_errorLastName != null) {
      AppBloc.messageCubit.onShow(
          Translate.of(context).translate(_errorLastName!),
          title: Translate.of(context).translate('last_name'),
          icon: const Icon(Icons.error, color: Colors.red),
          fontMessageColor: Colors.black,
          fontTitleTextColor: Colors.black,
          backgroundColor: Colors.white);
    }

    _errorPass = UtilValidator.validate(
      textPassController.text,
      min: 6,
    );

    if (textPassController.text.isEmpty) {
      _errorPass = Translate.of(context).translate('please_enter_password');
    }
    if (_errorPass != null) {
      AppBloc.messageCubit.onShow(Translate.of(context).translate(_errorPass!),
          title: Translate.of(context).translate('password'),
          icon: const Icon(Icons.error, color: Colors.red),
          fontMessageColor: Colors.black,
          fontTitleTextColor: Colors.black,
          backgroundColor: Colors.white);
    }
    _errorConfirmPass = UtilValidator.validate(
      textConfirmPassController.text,
      match: textPassController.text,
    );
    if (_errorConfirmPass != null) {
      AppBloc.messageCubit.onShow(
          Translate.of(context).translate(_errorConfirmPass!),
          title: Translate.of(context).translate('confirm_password'),
          icon: const Icon(Icons.error, color: Colors.red),
          fontMessageColor: Colors.black,
          fontTitleTextColor: Colors.black,
          backgroundColor: Colors.white);
    }

    _errorPhoneNumber = UtilValidator.validate(
      textPhoneNumberController.text,
      type: ValidateType.phone,
    );
    if (_errorPhoneNumber != null) {
      AppBloc.messageCubit.onShow(
          Translate.of(context).translate(_errorPhoneNumber!),
          title: Translate.of(context).translate('phone_number'),
          icon: const Icon(Icons.error, color: Colors.red),
          fontMessageColor: Colors.black,
          fontTitleTextColor: Colors.black,
          backgroundColor: Colors.white);
    }

    if (_errorFirstName == null &&
        _errorLastName == null &&
        _errorPass == null &&
        _errorConfirmPass == null &&
        _errorPhoneNumber == null) {
      final result = await AppBloc.userCubit.onRegister(
        firstName: textFirstNameController.text,
        lastName: textLastNameController.text,
        password: textPassController.text,
        confirmPassword: textConfirmPassController.text,
        phoneNumber: textPhoneNumberController.text,
      );
      if (result != null) {
        await UserRepository.saveRegUserId(result);
        Navigator.pushReplacementNamed(
          context,
          Routes.otp,
          arguments: {"userId": result, "routeName": Routes.account},
        );
        // if (!mounted) return;
        // Navigator.pop(context);
      }
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
                  const Text(
                    'Welcome',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 40),
                  SvgPicture.asset('assets/images/register.svg'),
                  const SizedBox(height: 40),
                  RoundedInput(
                    controller: textFirstNameController,
                    icon: Icons.face_rounded,
                    hint: Translate.of(context).translate('first_name'),
                    focusNode: focusFirstName,
                    keyboardType: TextInputType.name,
                    trailing: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        textFirstNameController.clear();
                      },
                      child: const Icon(Icons.clear),
                    ),
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(
                        context,
                        focusFirstName,
                        focusLastName,
                      );
                    },
                  ),
                  RoundedInput(
                    controller: textLastNameController,
                    icon: Icons.face_rounded,
                    focusNode: focusLastName,
                    hint: Translate.of(context).translate('last_name'),
                    keyboardType: TextInputType.name,
                    trailing: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        textLastNameController.clear();
                      },
                      child: const Icon(Icons.clear),
                    ),
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(
                        context,
                        focusLastName,
                        focusPhoneNumber,
                      );
                    },
                  ),
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
                          hint: Translate.of(context).translate('password'),
                          obscureText: _showPassword.value,
                          onChanged: (value) {
                            textConfirmPassController.text = value;
                          },
                          trailing: GestureDetector(
                            dragStartBehavior: DragStartBehavior.down,
                            onTap: () {
                              _showPassword.value = !_showPassword.value;
                            },
                            child: Icon(_showPassword.value
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
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
                        child: AppButton(
                          Translate.of(context).translate('sign_up'),
                          mainAxisSize: MainAxisSize.max,
                          onPressed: () {
                            UtilOther.hiddenKeyboard(context);
                            _signUp(context);
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
