// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:supermarket/blocs/app_bloc.dart';
// import 'package:supermarket/blocs/bloc.dart';
// import 'package:supermarket/configs/application.dart';
// import 'package:supermarket/configs/routes.dart';
// 
// import 'package:supermarket/screens/signin/components/cancel_button.dart';
// import 'package:supermarket/screens/signin/components/login_form.dart';
// import 'package:supermarket/screens/signin/components/register_form.dart';
// import 'package:supermarket/utils/other.dart';
// import 'package:supermarket/utils/translate.dart';
// import 'package:supermarket/utils/validate.dart';

// class LoginScreen extends StatefulWidget {
//   final String from;
//   const LoginScreen({Key? key, required this.from}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   final _textFirstNameController = TextEditingController();
//   final _textLastNameController = TextEditingController();
//   final _textPhoneNumberController = TextEditingController();
//   final _textEmailController = TextEditingController();
//   final _focusFirstName = FocusNode();
//   final _focusLastName = FocusNode();
//   final _focusPhoneNumber = FocusNode();
//   final _focusEmail = FocusNode();
//   final picker = ImagePicker();

//   String? _image;
//   String? _errorFirstName;
//   String? _errorLastName;
//   String? _errorPhoneNumber;
//   String? _errorEmail;
//   bool _isAppearPhoneNumber = false;

//   late Animation<double> containerSize;
//   AnimationController? animationController;
//   Duration animationDuration = Duration(milliseconds: 270);

//   @override
//   void initState() {
//     super.initState();
//     animationController =
//         AnimationController(vsync: this, duration: animationDuration);
//   }

//   @override
//   void dispose() {
//     _textFirstNameController.dispose();
//     _textLastNameController.dispose();
//     _textPhoneNumberController.dispose();
//     _textEmailController.dispose();
//     super.dispose();
//   }

//   ///On update image
//   void _updateProfile() async {
//     UtilOther.hiddenKeyboard(context);

//     if (!AppBloc.userCubit.state!.phoneNumberConfirmed) {
//       UtilOther.showMessage(
//         context: context,
//         title: Translate.of(context).translate('confirm_phone_number'),
//         message: Translate.of(context)
//             .translate('the_phone_number_must_be_confirmed_first'),
//         func: () {
//           Navigator.of(context).pop();
//           Navigator.pushNamed(
//             context,
//             Routes.otp,
//             arguments: {
//               "userId": AppBloc.userCubit.state!.userId,
//               "routeName": null
//             },
//           );
//         },
//         funcName: Translate.of(context).translate('confirm'),
//       );
//       return;
//     }

//     setState(() {
//       _errorFirstName = UtilValidator.validate(_textFirstNameController.text);
//       _errorLastName = UtilValidator.validate(_textLastNameController.text);
//       _errorPhoneNumber = UtilValidator.validate(
//         _textPhoneNumberController.text,
//         type: ValidateType.number,
//         allowEmpty: false,
//       );
//       _errorEmail = UtilValidator.validate(
//         _textEmailController.text,
//         type: ValidateType.email,
//       );
//     });
//     if (_errorFirstName == null &&
//         _errorLastName == null &&
//         _errorPhoneNumber == null &&
//         _errorEmail == null) {
//       ///Fetch change profile
//       final result = await AppBloc.userCubit.onUpdateUser(
//           firstName: _textFirstNameController.text,
//           lastName: _textLastNameController.text,
//           phoneNumber: _textPhoneNumberController.text,
//           isAppearPhoneNumber: _isAppearPhoneNumber,
//           email: _textEmailController.text,
//           image: _image);

//       ///Case success
//       if (result) {
//         if (!mounted) return;
//         Navigator.pop(context);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     double viewInset = MediaQuery.of(context)
//         .viewInsets
//         .bottom; // we are using this to determine Keyboard is opened or not
//     double defaultLoginSize = size.height - (size.height * 0.2);
//     double defaultRegisterSize = size.height - (size.height * 0.1);

//     containerSize =
//         Tween<double>(begin: size.height * 0.1, end: defaultRegisterSize)
//             .animate(CurvedAnimation(
//                 parent: animationController!, curve: Curves.linear));

//     return Scaffold(
//         body: BlocListener<LoginCubit, LoginState>(
//       listener: (context, login) {
//         if (login == LoginState.success) {
//           Navigator.pop(context, widget.from);
//         }
//       },
//       child: Stack(
//         children: [
//           // Lets add some decorations
//           Positioned(
//               top: 100,
//               right: -50,
//               child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50),
//                     color: Theme.of(context).primaryColor),
//               )),

//           Positioned(
//               top: -50,
//               left: -50,
//               child: Container(
//                 width: 200,
//                 height: 200,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(100),
//                     color: Theme.of(context).primaryColor),
//               )),

//           // Cancel Button
//           CancelButton(
//             isLogin: isLogin,
//             animationDuration: animationDuration,
//             size: size,
//             animationController: animationController,
//             tapEvent: isLogin
//                 ? null
//                 : () {
//                     // returning null to disable the button
//                     animationController!.reverse();
//                     setState(() {
//                       isLogin = !isLogin;
//                     });
//                   },
//           ),

//           // Login Form
//           LoginForm(
//             isLogin: isLogin,
//             animationDuration: animationDuration,
//             size: size,
//             defaultLoginSize: defaultLoginSize,
//             textPhoneNumberController: _textPhoneNumberController,
//             textPassController: _textPassController,
//             focusPhoneNumber: _focusPhoneNumber,
//             focusPass: _focusPass,
//           ),

//           // Register Container
//           AnimatedBuilder(
//             animation: animationController!,
//             builder: (context, child) {
//               if (viewInset == 0 && isLogin) {
//                 return buildRegisterContainer();
//               } else if (!isLogin) {
//                 return buildRegisterContainer();
//               }

//               // Returning empty container to hide the widget
//               return Container();
//             },
//           ),

//           // Register Form
//           RegisterForm(
//             isLogin: isLogin,
//             animationDuration: animationDuration,
//             size: size,
//             defaultLoginSize: defaultRegisterSize,
//             textPhoneNumberController: _rtextPhoneNumberController,
//             textFirstNameController: _rtextFirstNameController,
//             textLastNameController: _rtextLastNameController,
//             textPassController: _rtextPassController,
//             textConfirmPassController: _rtextConfirmPassController,
//             focusPhoneNumber: _rfocusPhoneNumber,
//             focusFirstName: _rfocusFirstName,
//             focusLastName: _rfocusLastName,
//             focusPass: _rfocusPass,
//             focusConfirmPass: _rfocusConfirmPass,
//           ),
//         ],
//       ),
//     ));
//   }

//   Widget buildRegisterContainer() {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: double.infinity,
//         height: containerSize.value,
//         decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(100),
//               topRight: Radius.circular(100),
//             ),
//             color: kBackgroundColor),
//         alignment: Alignment.center,
//         child: GestureDetector(
//           onTap: !isLogin
//               ? null
//               : () {
//                   animationController!.forward();

//                   setState(() {
//                     isLogin = !isLogin;
//                   });
//                 },
//           child: isLogin
//               ? Text(
//                   Translate.of(context)
//                       .translate('dont_have_an_account_sign_up'),
//                   style: TextStyle(
//                       color: Theme.of(context).primaryColor, fontSize: 18),
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
// }
