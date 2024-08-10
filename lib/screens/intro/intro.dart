import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:supermarket/blocs/bloc.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/utils/utils.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() {
    return _IntroState();
  }
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On complete preview intro
  void _onCompleted() {
    AppBloc.applicationCubit.onCompletedIntro();
  }

  @override
  Widget build(BuildContext context) {
    ///List Intro view page model
    final List<PageViewModel> pages = [
      PageViewModel(
        pageColor: const Color(0xff274e6f),
        bubble: const Icon(
          Icons.shop,
          color: Colors.white,
        ),
        body: Text(
          Translate.of(context).translate('intro1'),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
        ),
        mainImage: Container(),
        // mainImage: Image.asset(
        //   Images.intro1,
        //   fit: BoxFit.fitHeight,
        // ),
      ),
      PageViewModel(
        pageColor: const Color(0xff274e6f),
        bubble: const Icon(
          Icons.phonelink,
          color: Colors.white,
        ),
        body: Text(
          Translate.of(context).translate('intro2'),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        mainImage: Container(),
        // mainImage: Image.asset(
        //   Images.intro1,
        //   fit: BoxFit.fitHeight,
        // ),
      ),
      PageViewModel(
        pageColor: const Color(0xff274e6f),
        bubble: const Icon(
          Icons.home,
          color: Colors.white,
        ),
        body: Text(
          Translate.of(context).translate('intro3'),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        mainImage: Container(),
        // mainImage: Image.asset(
        //   Images.intro1,
        //   fit: BoxFit.fitHeight,
        // ),
      ),
    ];

    ///Build Page
    return Scaffold(
      body: IntroViewsFlutter(
        pages,
        onTapSkipButton: _onCompleted,
        onTapDoneButton: _onCompleted,
        // showSkipButton: false,
        doneText: Text(Translate.of(context).translate('done')),
        nextText: Text(Translate.of(context).translate('next')),
        skipText: Text(Translate.of(context).translate('skip')),
        backText: Text(Translate.of(context).translate('back')),
        pageButtonTextStyles: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
