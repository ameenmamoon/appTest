import 'package:supermarket/models/model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Application {
  static bool debug = true;
  static String googleAPI = 'AIzaSyDAtS8sIe9asGlJx5daag_ctKKErHVvqns';
  static String googleAPIIos = 'AIzaSyD_T8QC8UCZIH0pNE947U2B3fb1eLOH6nU';
  // static String googleAPI = 'AIzaSyB5k4khJT_04dUA7lfk2RF98p65j6hMKnA';
  // static String host = '10.0.2.2';
  // static String domain = 'http://10.0.2.2:5000/';
  static String host = 'ghani2029-001-site40.dtempurl.com';
  static String domain = 'http://ghani2029-001-site40.dtempurl.com/';
  // static String reserveDomain = 'http://10.0.2.2:5000/';
  static String reserveDomain = 'http://ghani2029-001-site40.dtempurl.com/';
  static String dynamicLink = 'https://bisat.page.link';
  static String hostDynamicLink = 'http://bisat.co/short';
  static int pageSize = 20;
  static DeviceModel? device;
  static PackageInfo? packageInfo;
  static List<dynamic> shoppingCartProducts = [];
  static List<int> shoppingCartsPromotions = [];
  static List<int> wishListProducts = [];
  static List<int> wishListPromotions = [];
  static final scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: "appScreen");
  static bool isStartedSignalR = false;
  static int newMessagesCount = 0;
  static PendingDynamicLinkData? dynamicLinkData = null;

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
