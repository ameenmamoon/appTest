import 'dart:core';

import 'package:supermarket/repository/location_repository.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'blocs/app_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/arma-soft-white.mp4')
      ..initialize().then((_) {
        _controller!.play();
        _controller!.setLooping(false);
        _controller!.setVolume(0.0);
        setState(() {});
        _controller!.addListener(checkVideo);
      });
  }

  void checkVideo() {
    if (_controller!.value.position == _controller!.value.duration) {
      try {
        _controller!.removeListener(checkVideo);

        AppBloc.applicationCubit.onSetup();
      } catch (ex) {
        AppBloc.applicationCubit.onSetup();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}
