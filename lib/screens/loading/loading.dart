import 'dart:async';

import 'package:supermarket/blocs/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/configs/config.dart';

import '../../main.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    AppBloc.applicationCubit.onCompletedIntro();
    // AppBloc.applicationCubit.onSetup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<int, Color> color = {
    50: const Color.fromRGBO(4, 131, 184, .1),
    100: const Color.fromRGBO(4, 131, 184, .2),
    200: const Color.fromRGBO(4, 131, 184, .3),
    300: const Color.fromRGBO(4, 131, 184, .4),
    400: const Color.fromRGBO(4, 131, 184, .5),
    500: const Color.fromRGBO(4, 131, 184, .6),
    600: const Color.fromRGBO(4, 131, 184, .7),
    700: const Color.fromRGBO(4, 131, 184, .8),
    800: const Color.fromRGBO(4, 131, 184, .9),
    900: const Color.fromRGBO(4, 131, 184, 1),
  };

  @override
  Widget build(BuildContext context) {
    // MaterialColor myColor = MaterialColor(0xFF880E4F, color);

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(seconds: 2),
      child: Scaffold(
        // backgroundColor: myColor,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 180, 180, 180),
                Color.fromARGB(255, 255, 255, 255),
              ],
              begin: Alignment(-0.7, 12),
              end: Alignment(1, -2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(Images.logo, width: 200, height: 200),
                  ],
                ),
              ),
              // Positioned(
              //   top: 5,
              //   child:
              const SizedBox(height: 8),
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      // semanticsLabel: 'saw sedv wesd sed',
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
