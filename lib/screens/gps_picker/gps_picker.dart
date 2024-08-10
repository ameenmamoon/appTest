import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

class GPSPicker extends StatefulWidget {
  final CoordinateModel? picked;

  const GPSPicker({Key? key, this.picked}) : super(key: key);

  @override
  _GPSPickerState createState() {
    return _GPSPickerState();
  }
}

class _GPSPickerState extends State<GPSPicker> {
  CameraPosition _initPosition = const CameraPosition(
    target: LatLng(15.279311, 44.227545),
    zoom: 16,
  );
  final _markers = <MarkerId, Marker>{};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _onCurrentLocation();
    if (widget.picked != null) {
      _onSetMarker(
        latitude: widget.picked!.latitude,
        longitude: widget.picked!.longitude,
      );
    }
  }

  ///On focus current location
  void _onCurrentLocation() {
    final currentLocation = AppBloc.locationCubit.state;
    if (currentLocation == null) {
      AppBloc.locationCubit.onLocationService();
    }
    if (currentLocation != null) {
      _initPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 16,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On Apply
  void _onApply() {
    if (_markers.values.isNotEmpty) {
      final position = _markers.values.first.position;
      final title = widget.picked?.name ?? 'location';
      final item = CoordinateModel(
        name: title,
        longitude: position.longitude,
        latitude: position.latitude,
      );
      Navigator.pop(context, item);
    }
  }

  ///On set marker
  void _onSetMarker({
    required double latitude,
    required double longitude,
  }) async {
    final title = widget.picked?.name ?? 'location';
    final markerId = MarkerId(title);
    final position = LatLng(latitude, longitude);
    final Marker marker = Marker(
      markerId: markerId,
      position: position,
      infoWindow: InfoWindow(title: title),
    );

    setState(() {
      _markers[markerId] = marker;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          tilt: 30.0,
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('location'),
        ),
        actions: [
          AppButton(
            Translate.of(context).translate('apply'),
            onPressed: _onApply,
            type: ButtonType.text,
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            initialCameraPosition: _initPosition,
            markers: Set<Marker>.of(_markers.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (item) {
              _onSetMarker(
                latitude: item.latitude,
                longitude: item.longitude,
              );
            },
          ),
          OpenContainer<bool>(
            openColor: Colors.transparent,
            closedColor: Colors.transparent,
            transitionType: ContainerTransitionType.fade,
            openBuilder: (context, closeContainer) {
              return GPSList(
                closeContainer: closeContainer,
                onSetMarker: _onSetMarker,
              );
            },
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            transitionDuration: const Duration(milliseconds: 500),
            closedElevation: 0.0,
            openElevation: 0.0,
            closedBuilder: (context, openContainer) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).dividerColor.withOpacity(
                            .05,
                          ),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(
                        0,
                        2,
                      ), // changes position of shadow
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(16),
                child: AppPickerItem(
                  leading: Icon(
                    Icons.search,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Translate.of(context).translate(
                    'search',
                  ),
                  onPressed: openContainer,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class GPSList extends StatefulWidget {
  final Function closeContainer;
  final void Function({
    required double latitude,
    required double longitude,
  }) onSetMarker;

  const GPSList({
    Key? key,
    required this.closeContainer,
    required this.onSetMarker,
  }) : super(key: key);

  @override
  _GPSListState createState() {
    return _GPSListState();
  }
}

class _GPSListState extends State<GPSList> {
  final _textSearchController = TextEditingController();
  final _focusSearch = FocusNode();

  Timer? _debounce;
  List<PlaceModel>? _result;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(_focusSearch);
    });
  }

  @override
  void dispose() {
    _focusSearch.dispose();
    _textSearchController.dispose();
    super.dispose();
  }

  ///On Search Place
  void _onSearch(String input) {
    _debounce?.cancel();
    if (input.isNotEmpty) {
      setState(() {
        _loading = true;
      });
      _debounce = Timer(const Duration(seconds: 2), () async {
        try {
          final response = await Dio().get(
            'https://maps.googleapis.com/maps/api/place/findplacefromtext/json',
            queryParameters: {
              "key": Platform.isIOS
                  ? Application.googleAPIIos
                  : Application.googleAPI,
              "inputtype": 'textquery',
              "fields": 'name,place_id,formatted_address',
              "input": _textSearchController.text,
            },
          );
          final data = response.data;
          if (response.data['error_message'] != null) {
            AppBloc.messageCubit.onShow(response.data['error_message']);
          }
          if (data['candidates'] != null) {
            setState(() {
              _result = (data['candidates'] as List).map((e) {
                return PlaceModel.fromJson(e);
              }).toList();
              _loading = false;
            });
          }
        } catch (e) {
          UtilLogger.log("ERROR", e);
        }
      });
    } else {
      setState(() {
        _result = null;
        _loading = false;
      });
    }
  }

  ///On Detail Place
  void _onPlaceDetail(String id) async {
    try {
      var response = await Dio().get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          "key":
              Platform.isIOS ? Application.googleAPIIos : Application.googleAPI,
          "place_id": id,
          "fields": "geometry",
        },
      );
      final data = response.data;
      if (response.data['error_message'] != null) {
        AppBloc.messageCubit.onShow(response.data['error_message']);
      }
      if (data['result'] != null && data['result']['geometry'] != null) {
        final item = data['result']['geometry']['location'];
        widget.onSetMarker(latitude: item['lat'], longitude: item['lng']);
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      UtilLogger.log("ERROR", e);
    }
  }

  ///Build Result
  Widget _buildResult() {
    if (_result == null) {
      return Container();
    }
    if (_result!.isEmpty) {
      return Center(
        child: Text(
          Translate.of(context).translate('can_not_found_data'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final item = _result![index];
        return InkWell(
          onTap: () {
            _onPlaceDetail(item.placeID);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                item.address,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: _result!.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget trailing = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      onTap: () {
        _textSearchController.clear();
      },
      child: const Icon(Icons.clear),
    );
    if (_loading) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
            ),
          ),
          SizedBox(width: 16),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Translate.of(context).translate('location'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AppTextInput(
                hintText: Translate.of(context).translate('search'),
                textInputAction: TextInputAction.done,
                focusNode: _focusSearch,
                controller: _textSearchController,
                onChanged: _onSearch,
                onSubmitted: _onSearch,
                leading: Icon(
                  Icons.search,
                  color: Theme.of(context).hintColor,
                ),
                trailing: trailing,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _buildResult(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
