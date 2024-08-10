import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';
import 'package:flutter/services.dart';
import '../../configs/routes.dart';
import '../../repository/repository.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _textPhoneNumberController = TextEditingController();
  String? _errorPhoneNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textPhoneNumberController.dispose();
    super.dispose();
  }

  ///Fetch API
  void _forgotPassword() {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _errorPhoneNumber = UtilValidator.validate(
        _textPhoneNumberController.text,
        type: ValidateType.phone,
      );
    });
    if (_errorPhoneNumber == null) {
      UserRepository.validationPhoneNumber(
              countryCode: '', phoneNumber: _textPhoneNumberController.text)
          .then((value) {
        if (value) {
          Navigator.pushNamed(
            context,
            Routes.otpForgotPassword,
            arguments: {
              "countryCode": '',
              "phoneNumber": _textPhoneNumberController.text
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('forgot_password'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                        trailing: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          onTap: () {},
                          child: const Icon(Icons.clear),
                        ),
                        onSubmitted: (text) {
                          _forgotPassword();
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
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AppButton(
                    Translate.of(context).translate('reset_password'),
                    mainAxisSize: MainAxisSize.max,
                    onPressed: _forgotPassword,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
