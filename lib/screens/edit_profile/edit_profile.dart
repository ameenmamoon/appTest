import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:vibration/vibration.dart';

import '../../configs/application.dart';
import '../../configs/routes.dart';
import '../../notificationservice_.dart';
import '../../widgets/widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  final _textFirstNameController = TextEditingController();
  final _textLastNameController = TextEditingController();
  final _textPhoneNumberController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _focusFirstName = FocusNode();
  final _focusLastName = FocusNode();
  final _focusPhoneNumber = FocusNode();
  final _focusEmail = FocusNode();
  final picker = ImagePicker();

  String? _errorFirstName;
  String? _errorLastName;
  String? _errorPhoneNumber;
  String? _errorEmail;

  @override
  void initState() {
    super.initState();
    final user = AppBloc.userCubit.state!;
    _textFirstNameController.text = user.firstName;
    _textLastNameController.text = user.lastName;
    _textPhoneNumberController.text = user.phoneNumber;
    _textEmailController.text = user.email;
  }

  @override
  void dispose() {
    _textFirstNameController.dispose();
    _textLastNameController.dispose();
    _textPhoneNumberController.dispose();
    _textEmailController.dispose();
    super.dispose();
  }

  ///On update image
  void _updateProfile() async {
    UtilOther.hiddenKeyboard(context);

    if (!AppBloc.userCubit.state!.phoneNumberConfirmed) {
      UtilOther.showMessage(
        context: context,
        title: Translate.of(context).translate('confirm_phone_number'),
        message: Translate.of(context)
            .translate('the_phone_number_must_be_confirmed_first'),
        func: () {
          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            Routes.otp,
            arguments: {
              "userId": AppBloc.userCubit.state!.userId,
              "routeName": null
            },
          );
        },
        funcName: Translate.of(context).translate('confirm'),
      );
      return;
    }

    setState(() {
      _errorFirstName = UtilValidator.validate(_textFirstNameController.text);
      _errorLastName = UtilValidator.validate(_textLastNameController.text);
      _errorPhoneNumber = UtilValidator.validate(
        _textPhoneNumberController.text,
        type: ValidateType.number,
        allowEmpty: false,
      );
      _errorEmail = UtilValidator.validate(_textEmailController.text,
          type: ValidateType.email, allowEmpty: true);
    });
    if (_errorFirstName == null &&
        _errorLastName == null &&
        _errorPhoneNumber == null &&
        _errorEmail == null) {
      ///Fetch change profile
      final result = await AppBloc.userCubit.onUpdateUser(
          firstName: _textFirstNameController.text,
          lastName: _textLastNameController.text,
          phoneNumber: _textPhoneNumberController.text,
          email: _textEmailController.text);

      ///Case success
      if (result) {
        if (!mounted) return;
        Navigator.pop(context);
      }
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "homeScreen");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('edit_profile')),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  const SizedBox(height: 16),
                  Text(
                    Translate.of(context).translate('first_name'),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold, color: Color(0xff3a5ba0)),
                  ),
                  const SizedBox(height: 8),
                  AppTextInput(
                    hintText:
                        Translate.of(context).translate('input_first_name'),
                    errorText: _errorFirstName,
                    focusNode: _focusFirstName,
                    textInputAction: TextInputAction.next,
                    trailing: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        _textFirstNameController.clear();
                      },
                      child: const Icon(Icons.clear),
                    ),
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(
                        context,
                        _focusFirstName,
                        _focusLastName,
                      );
                    },
                    onChanged: (text) {
                      setState(() {
                        _errorFirstName = UtilValidator.validate(
                          _textFirstNameController.text,
                        );
                      });
                    },
                    controller: _textFirstNameController,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Translate.of(context).translate('last_name'),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold, color: Color(0xff3a5ba0)),
                  ),
                  const SizedBox(height: 8),
                  AppTextInput(
                    hintText:
                        Translate.of(context).translate('input_last_name'),
                    errorText: _errorLastName,
                    focusNode: _focusLastName,
                    textInputAction: TextInputAction.next,
                    trailing: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        _textLastNameController.clear();
                      },
                      child: const Icon(Icons.clear),
                    ),
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(
                        context,
                        _focusLastName,
                        _focusPhoneNumber,
                      );
                    },
                    onChanged: (text) {
                      setState(() {
                        _errorLastName = UtilValidator.validate(
                          _textLastNameController.text,
                        );
                      });
                    },
                    controller: _textLastNameController,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    Translate.of(context).translate('phone'),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold, color: Color(0xff3a5ba0)),
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
                          readOnly: true,
                          trailing: GestureDetector(
                            dragStartBehavior: DragStartBehavior.down,
                            onTap: () {},
                            child: const Icon(Icons.clear),
                          ),
                          onSubmitted: (text) {
                            UtilOther.fieldFocusChange(
                              context,
                              _focusPhoneNumber,
                              _focusEmail,
                            );
                          },
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
                  Text(
                    Translate.of(context).translate('email'),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold, color: Color(0xff3a5ba0)),
                  ),
                  const SizedBox(height: 8),
                  AppTextInput(
                    hintText: Translate.of(context).translate('input_email'),
                    errorText: _errorEmail,
                    focusNode: _focusEmail,
                    textInputAction: TextInputAction.done,
                    trailing: GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () {
                        _textEmailController.clear();
                      },
                      child: const Icon(Icons.clear),
                    ),
                    onSubmitted: (text) {
                      _updateProfile();
                    },
                    onChanged: (text) {
                      setState(() {
                        _errorEmail = UtilValidator.validate(
                          _textEmailController.text,
                          type: ValidateType.email,
                        );
                      });
                    },
                    controller: _textEmailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppButton(
                      Translate.of(context).translate('confirm'),
                      mainAxisSize: MainAxisSize.max,
                      onPressed: _updateProfile,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
