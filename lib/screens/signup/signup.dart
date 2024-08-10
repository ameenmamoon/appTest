import 'package:supermarket/repository/repository.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

import '../../configs/application.dart';
import '../../configs/routes.dart';
import '../../models/model.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final _textFirstNameController = TextEditingController();
  final _textLastNameController = TextEditingController();
  final _textPassController = TextEditingController();
  final _textConfirmPassController = TextEditingController();
  final _textPhoneNumberController = TextEditingController();
  final _focusFirstName = FocusNode();
  final _focusLastName = FocusNode();
  final _focusPass = FocusNode();
  final _focusConfirmPass = FocusNode();
  final _focusPhoneNumber = FocusNode();

  bool _showPassword = false;
  String? _errorFirstName;
  String? _errorLastName;
  String? _errorPass;
  String? _errorConfirmPass;
  String? _errorPhoneNumber;

  @override
  void initState() {
    super.initState();
    UserRepository.loadRegUserId().then((value) {
      if (value != null) {
        Navigator.pushReplacementNamed(
          context,
          Routes.otp,
          arguments: {"userId": value, "routeName": Routes.signIn},
        );
      }
    });
  }

  @override
  void dispose() {
    _textFirstNameController.dispose();
    _textLastNameController.dispose();
    _textPassController.dispose();
    _textConfirmPassController.dispose();
    _textPhoneNumberController.dispose();
    _focusFirstName.dispose();
    _focusLastName.dispose();
    _focusPass.dispose();
    _focusConfirmPass.dispose();
    _focusPhoneNumber.dispose();
    super.dispose();
  }

  ///On sign up
  void _signUp() async {
    UtilOther.hiddenKeyboard(context);
    // Navigator.pushNamed(context, Routes.otp, arguments: "result");
    setState(() {
      _errorFirstName =
          UtilValidator.validate(_textFirstNameController.text, min: 6);
      if (_errorFirstName != null) {
        AppBloc.messageCubit.onShow(
            Translate.of(context).translate(_errorFirstName!),
            title: Translate.of(context).translate('account_name'),
            icon: const Icon(Icons.error, color: Colors.red),
            fontMessageColor: Colors.black,
            fontTitleTextColor: Colors.black,
            backgroundColor: Colors.white);
      }

      _errorLastName =
          UtilValidator.validate(_textLastNameController.text, min: 10);
      if (_errorLastName != null) {
        AppBloc.messageCubit.onShow(
            Translate.of(context).translate(_errorLastName!),
            title: Translate.of(context).translate('full_name'),
            icon: const Icon(Icons.error, color: Colors.red),
            fontMessageColor: Colors.black,
            fontTitleTextColor: Colors.black,
            backgroundColor: Colors.white);
      }

      _errorPass = UtilValidator.validate(
        _textPassController.text,
        min: 6,
      );

      if (_textPassController.text.isEmpty) {
        _errorPass = Translate.of(context).translate('please_enter_password');
      }
      if (_errorPass != null) {
        AppBloc.messageCubit.onShow(
            Translate.of(context).translate(_errorPass!),
            title: Translate.of(context).translate('password'),
            icon: const Icon(Icons.error, color: Colors.red),
            fontMessageColor: Colors.black,
            fontTitleTextColor: Colors.black,
            backgroundColor: Colors.white);
      }
      _errorConfirmPass = UtilValidator.validate(
        _textConfirmPassController.text,
        match: _textPassController.text,
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
        _textPhoneNumberController.text,
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
    });

    if (_errorFirstName == null &&
        _errorLastName == null &&
        _errorPass == null &&
        _errorConfirmPass == null &&
        _errorPhoneNumber == null) {
      final result = await AppBloc.userCubit.onRegister(
        firstName: _textFirstNameController.text,
        lastName: _textLastNameController.text,
        password: _textPassController.text,
        confirmPassword: _textConfirmPassController.text,
        phoneNumber: _textPhoneNumberController.text,
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('sign_up'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Translate.of(context).translate('account_name'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_id'),
                  errorText: _errorFirstName,
                  controller: _textFirstNameController,
                  focusNode: _focusFirstName,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    setState(() {
                      _errorFirstName =
                          UtilValidator.validate(_textFirstNameController.text);
                    });
                  },
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                        context, _focusFirstName, _focusLastName);
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textFirstNameController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('full_name'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_full_name'),
                  errorText: _errorLastName,
                  controller: _textLastNameController,
                  focusNode: _focusLastName,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    setState(() {
                      _errorLastName =
                          UtilValidator.validate(_textLastNameController.text);
                    });
                  },
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                        context, _focusLastName, _focusPass);
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textLastNameController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('password'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_your_password',
                  ),
                  errorText: _errorPass,
                  onChanged: (text) {
                    setState(() {
                      _errorPass = UtilValidator.validate(
                        _textPassController.text,
                      );
                    });
                  },
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusPass,
                      _focusConfirmPass,
                    );
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    child: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  obscureText: !_showPassword,
                  controller: _textPassController,
                  focusNode: _focusPass,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('confirm_password'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_confirm_password',
                  ),
                  errorText: _errorConfirmPass,
                  onChanged: (text) {
                    setState(() {
                      _errorConfirmPass = UtilValidator.validate(
                        _textConfirmPassController.text,
                      );
                    });
                  },
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                      context,
                      _focusConfirmPass,
                      _focusPhoneNumber,
                    );
                  },
                  trailing: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      _textPhoneNumberController.clear();
                    },
                    child: const Icon(Icons.clear),
                  ),
                  obscureText: true,
                  controller: _textConfirmPassController,
                  focusNode: _focusConfirmPass,
                ),
                const SizedBox(height: 16),
                Text(
                  Translate.of(context).translate('phone_number'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: AppTextInput(
                        hintText: Translate.of(context)
                            .translate('input_phone_number'),
                        errorText: _errorPhoneNumber,
                        focusNode: _focusPhoneNumber,
                        trailing: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          onTap: () {
                            _textPhoneNumberController.clear();
                          },
                          child: const Icon(Icons.clear),
                        ),
                        onSubmitted: (text) {},
                        onChanged: (text) {
                          setState(() {
                            _errorPhoneNumber = UtilValidator.validate(
                              _textPhoneNumberController.text,
                              type: ValidateType.phone,
                            );
                          });
                        },
                        controller: _textPhoneNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  Translate.of(context).translate('sign_up'),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: _signUp,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
