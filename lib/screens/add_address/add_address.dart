import 'package:supermarket/app_properties.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/repository/repository.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';
import "package:flutter/services.dart";
import 'package:toggle_switch/toggle_switch.dart';

import '../../repository/location_repository.dart';

class AddAddress extends StatefulWidget {
  final AddressModel? item;
  final bool? isSelectable;
  const AddAddress({
    Key? key,
    this.item,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  _AddAddressState createState() {
    return _AddAddressState();
  }
}

class _AddAddressState extends State<AddAddress> {
  final regInt = RegExp('[^0-9]');

  final _textAddressNameController = TextEditingController();
  final _textPhoneController = TextEditingController();

  final _focusAddressName = FocusNode();
  final _focusPhone = FocusNode();

  bool _processing = false;

  String? _errorAddressName;
  String? _errorGps;
  String? _errorPhone;

  /// Data
  List<LocationModel>? _listState;
  List<LocationModel>? _listCity;
  bool _loadingState = false;
  bool _loadingCity = false;

  ///Data Params
  bool isDefault = false;
  CoordinateModel? _gps;

  @override
  void initState() {
    super.initState();
    _onProcess();
  }

  @override
  void dispose() {
    _textAddressNameController.dispose();
    _textPhoneController.dispose();
    _focusAddressName.dispose();
    _focusPhone.dispose();
    super.dispose();
  }

  ///On Load Edit Address
  void _onProcess() async {
    setState(() {
      _processing = true;
    });
    Map<String, dynamic> params = {};
    if (widget.item != null) {
      params['id'] = widget.item!.id;
    }

    if (widget.item != null) {
      isDefault = widget.item!.isDefault;
      _textAddressNameController.text = widget.item!.address;
      _textPhoneController.text = widget.item!.phoneNumber;
      // _state = LocationModel(
      //     id: 1,
      //     countryId: Application.currentCountry!.id,
      //     parentId: 0,
      //     name: widget.item!.state);
      // _city = LocationModel(
      //     id: 1,
      //     countryId: Application.currentCountry!.id,
      //     parentId: 0,
      //     name: widget.item!.city);
      _gps = CoordinateModel(
          name: widget.item!.address,
          longitude: double.parse(widget.item!.longitude),
          latitude: double.parse(widget.item!.latitude));
    }
    setState(() {
      _processing = false;
    });
  }

  ///On Select Address
  void _onSelectAddress() async {
    final selected = await Navigator.pushNamed(
      context,
      Routes.gpsPicker,
      arguments: _gps,
    );
    if (selected != null && selected is CoordinateModel) {
      setState(() {
        _gps = selected;
      });
    }
  }

  ///On Submit
  void _onSubmit() async {
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

    final success = _validData();
    if (success) {
      int? result;
      final address = await AddressRepository.loadDefault();
      result = await AddressRepository.submitAddress(
        id: widget.item?.id ?? 0,
        name: _textAddressNameController.text,
        isDefault: isDefault,
        latitude: _gps!.latitude.toString(),
        longitude: _gps!.longitude.toString(),
        phoneNumber: _textPhoneController.text,
        type: AddressType.home,
      );
      if (result != null) {
        if (!isDefault && address != null && result == address.id) {
          AddressRepository.removeDefault();
        }
        _onSuccess(result);
      }
    }
  }

  ///On Success
  Future<void> _onSuccess(int id) async {
    if (isDefault) {
      await AddressRepository.saveDefault(
          address: AddressModel(
        id: id,
        address: _textAddressNameController.text,
        isDefault: isDefault,
        latitude: _gps!.latitude.toString(),
        longitude: _gps!.longitude.toString(),
        phoneNumber: _textPhoneController.text,
        type: AddressType.home,
      ));
    }
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, Routes.addressList,
        arguments: widget.isSelectable);
  }

  ///valid data
  bool _validData() {
    ///Address Name
    _errorAddressName = UtilValidator.validate(
      _textAddressNameController.text,
    );

    ///Gps
    _errorGps = _gps == null
        ? "${Translate.of(context).translate('location_coordinates')} ${Translate.of(context).translate('must_be_selected')}"
        : null;

    ///Phone
    _errorPhone = UtilValidator.validate(
      _textPhoneController.text,
      type: ValidateType.phone,
      allowEmpty: false,
    );

    if (_errorAddressName != null || _errorGps != null || _errorPhone != null) {
      setState(() {});
      return false;
    }

    return true;
  }

  ///Build content
  Widget _buildContent() {
    if (_processing) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              Translate.of(context).translate('address_name'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppTextInput(
              hintText: Translate.of(context).translate('input_address_name'),
              errorText: _errorAddressName,
              controller: _textAddressNameController,
              focusNode: _focusAddressName,
              textInputAction: TextInputAction.next,
              onChanged: (text) {
                setState(() {
                  _errorAddressName = UtilValidator.validate(
                    _textAddressNameController.text,
                  );
                });
              },
              trailing: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  _textAddressNameController.clear();
                },
                child: const Icon(Icons.clear),
              ),
            ),
            const SizedBox(height: 16),
            AppPickerItem(
              leading: Icon(
                Icons.location_on_outlined,
                color: Theme.of(context).hintColor,
              ),
              title: _errorGps ??
                  Translate.of(context).translate(
                    'choose_gps_location',
                  ),
              value: _gps != null
                  ? '${_gps!.latitude.toStringAsFixed(3)},${_gps!.longitude.toStringAsFixed(3)}'
                  : null,
              color: _errorGps != null
                  ? Theme.of(context).colorScheme.error
                  : null,
              onPressed: _onSelectAddress,
            ),
            const SizedBox(height: 8),
            AppTextInput(
              hintText: Translate.of(context).translate('input_phone'),
              errorText: _errorPhone,
              controller: _textPhoneController,
              focusNode: _focusPhone,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {
                  _errorPhone = UtilValidator.validate(
                    _textPhoneController.text,
                    type: ValidateType.phone,
                    min: null,
                    max: null,
                    allowEmpty: false,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  isDefault = !isDefault;
                });
              },
              child: Row(
                children: [
                  Text(
                    Translate.of(context).translate('default_delivery_address'),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                    value: isDefault,
                    onChanged: (value) {
                      setState(() {
                        isDefault = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Center(
              child: InkWell(
                onTap: _onSubmit,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      gradient: mainButton,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(0, 5),
                          blurRadius: 10.0,
                        )
                      ],
                      borderRadius: BorderRadius.circular(9.0)),
                  child: Center(
                    child: Text(
                        Translate.of(context)
                            .translate(widget.item != null ? 'update' : 'add'),
                        style: const TextStyle(
                            color: Color(0xfffefefe),
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String textTitle = Translate.of(context).translate('add_new_address');
    if (widget.item != null) {
      textTitle = Translate.of(context).translate('update_address');
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(textTitle),
        ),
        body: SafeArea(
          child: _buildContent(),
        ),
      ),
    );
  }
}
