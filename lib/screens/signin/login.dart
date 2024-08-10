import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/blocs/app_bloc.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/application.dart';
import 'package:supermarket/configs/routes.dart';

import 'package:supermarket/screens/signin/components/cancel_button.dart';
import 'package:supermarket/screens/signin/components/login_form.dart';
import 'package:supermarket/screens/signin/components/register_form.dart';
import 'package:supermarket/utils/other.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:supermarket/utils/validate.dart';

import '../forgot_password/forgot_password2.dart';

class LoginScreen extends StatefulWidget {
  final String from;
  const LoginScreen({Key? key, required this.from}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _textPhoneNumberController = TextEditingController();
  final _textPassController = TextEditingController();
  final _focusPhoneNumber = FocusNode();
  final _focusPass = FocusNode();
  final _rtextFirstNameController = TextEditingController();
  final _rtextLastNameController = TextEditingController();
  final _rtextPassController = TextEditingController();
  final _rtextConfirmPassController = TextEditingController();
  final _rtextPhoneNumberController = TextEditingController();
  final _rfocusFirstName = FocusNode();
  final _rfocusLastName = FocusNode();
  final _rfocusPass = FocusNode();
  final _rfocusConfirmPass = FocusNode();
  final _rfocusPhoneNumber = FocusNode();

  bool isLogin = true;
  bool isForgetPass = false;
  late Animation<double> containerSize;
  AnimationController? animationController;
  Duration animationDuration = Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    _textPhoneNumberController.dispose();
    _textPassController.dispose();
    _focusPhoneNumber.dispose();
    _focusPass.dispose();
    _rtextFirstNameController.dispose();
    _rtextLastNameController.dispose();
    _rtextPassController.dispose();
    _rtextConfirmPassController.dispose();
    _rtextPhoneNumberController.dispose();
    _rfocusFirstName.dispose();
    _rfocusLastName.dispose();
    _rfocusPass.dispose();
    _rfocusConfirmPass.dispose();
    _rfocusPhoneNumber.dispose();
    animationController!.dispose();
    super.dispose();
  }

  ///On navigate forgot password
  void _forgotPassword() {
    setState(() {
      isForgetPass = true;
      isLogin = !isLogin;
      animationController!.forward();
    });
    // Navigator.pushNamed(context, Routes.forgotPassword);
  }

  ///On navigate sign up
  void _signUp() {
    Navigator.pushNamed(context, Routes.signUp);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context)
        .viewInsets
        .bottom; // we are using this to determine Keyboard is opened or not
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize =
        Tween<double>(begin: size.height * 0.08, end: defaultRegisterSize)
            .animate(CurvedAnimation(
                parent: animationController!, curve: Curves.linear));

    return Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
      listener: (context, login) {
        if (login == LoginState.success) {
          Navigator.pop(context, widget.from);
        }
      },
      child: Stack(
        children: [
          // Lets add some decorations
          Positioned(
              top: 100,
              right: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).primaryColor),
              )),

          Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).primaryColor),
              )),

          // Cancel Button
          CancelButton(
            isLogin: isLogin,
            animationDuration: animationDuration,
            size: size,
            animationController: animationController,
            tapEvent: isLogin
                ? null
                : () {
                    _rtextPhoneNumberController.text = '';
                    // returning null to disable the button
                    animationController!.reverse();
                    setState(() {
                      isLogin = !isLogin;
                      isForgetPass = false;
                    });
                  },
          ),

          // Login Form
          LoginForm(
              isLogin: isLogin,
              animationDuration: animationDuration,
              size: size,
              defaultLoginSize: defaultLoginSize,
              textPhoneNumberController: _textPhoneNumberController,
              textPassController: _textPassController,
              focusPhoneNumber: _focusPhoneNumber,
              focusPass: _focusPass,
              forgotPassword: _forgotPassword),

          // Register Container
          AnimatedBuilder(
            animation: animationController!,
            builder: (context, child) {
              if (viewInset == 0 && isLogin) {
                return buildRegisterContainer();
              } else if (!isLogin) {
                return buildRegisterContainer();
              }
              // Returning empty container to hide the widget
              return Container();
            },
          ),

          // Register Form
          if (!isForgetPass)
            RegisterForm(
              isLogin: isLogin,
              animationDuration: animationDuration,
              size: size,
              defaultLoginSize: defaultRegisterSize,
              textPhoneNumberController: _rtextPhoneNumberController,
              textFirstNameController: _rtextFirstNameController,
              textLastNameController: _rtextLastNameController,
              textPassController: _rtextPassController,
              textConfirmPassController: _rtextConfirmPassController,
              focusPhoneNumber: _rfocusPhoneNumber,
              focusFirstName: _rfocusFirstName,
              focusLastName: _rfocusLastName,
              focusPass: _rfocusPass,
              focusConfirmPass: _rfocusConfirmPass,
            ),
          if (isForgetPass)
            ForgotPassword2(
              isLogin: isLogin,
              animationDuration: animationDuration,
              size: size,
              defaultLoginSize: defaultRegisterSize,
              textPhoneNumberController: _rtextPhoneNumberController,
              focusPhoneNumber: _rfocusPhoneNumber,
            ),
        ],
      ),
    ));
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: Theme.of(context).colorScheme.tertiaryContainer),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController!.forward();

                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? Text(
                  Translate.of(context)
                      .translate('dont_have_an_account_sign_up'),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                )
              : null,
        ),
      ),
    );
  }
}
