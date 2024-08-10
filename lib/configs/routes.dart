import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/payment_screen.dart';
import 'package:supermarket/screens/check_out/check_out2.dart';
import 'package:supermarket/screens/home/home.dart';
import 'package:supermarket/screens/screen.dart' as screen;
import 'package:supermarket/screens/screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supermarket/screens/shopping_cart/shopping_cart.dart';
import 'package:supermarket/screens/signin/login.dart';
import 'package:supermarket/widgets/payment_methods.dart';

import '../models/model_feature.dart';
import '../models/model_location.dart';
import 'application.dart';

class RouteArguments<T> {
  final T? item;
  final bool hasOperations;
  final VoidCallback? callback;
  RouteArguments({
    this.item,
    this.hasOperations = true,
    this.callback,
  });
}

class Routes {
  static const String notifications = "/notifications";
  static const String userNotifications = "/userNotifications";
  static const String generalNotifications = "/generalNotifications";
  static const String addNotification = "/addUserNotification";
  static const String home = "/home";
  static const String promotion = "/promotion";
  static const String wishList = "/wishList";
  static const String account = "/account";
  static const String addressList = "/addressList";
  static const String addAddress = "/addAddress";
  static const String views = "/views";
  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String otp = "/confirmPhoneNumber";
  static const String forgotPassword = "/forgotPassword";
  static const String otpForgotPassword = "/otpForgotPassword";
  static const String productDetail = "/productDetail";
  static const String productScreen = "/productScreen";
  static const String searchHistory = "/searchHistory";
  static const String category = "/category";
  static const String brand = "/brand";
  static const String profile = "/profile";
  static const String listProfile = "/listProfile";
  static const String profileQRCode = "/profileQRCode";
  static const String colorPicker = "/colorPicker";
  static const String editProfile = "/editProfile";
  static const String changePassword = "/changePassword";
  static const String changeLanguage = "/changeLanguage";
  static const String contactUs = "/contactUs";
  static const String aboutUs = "/aboutUs";
  static const String themeSetting = "/themeSetting";
  static const String listProduct = "/listProduct";
  static const String filter = "/filter";
  static const String review = "/review";
  static const String productReview = "/productReview";
  static const String feedback = "/feedback";
  static const String payment = "/payment";
  static const String shippingFeedback = "/shippingFeedback";
  static const String location = "/location";
  static const String setting = "/setting";
  static const String chatterScreen = "/chatterScreen";
  static const String fontSetting = "/fontSetting";
  static const String picker = "/picker";
  static const String docsUpload = "/docsUpload";
  static const String fullScreenImage = "/fullScreenImage";
  static const String categoryPicker = "/categoryPicker";
  static const String gpsPicker = "/gpsPicker";
  static const String openTime = "/openTime";
  static const String socialNetwork = "/socialNetwork";
  static const String tagsPicker = "/tagsPicker";
  static const String sizesPicker = "/sizesPicker";
  static const String paypalPayment = "/paypalPayment";
  static const String customerOrderList = "/customerOrderList";
  // static const String order = "/order";
  static const String orderList = "/orderList";
  static const String incompleteOrderList = "/incompleteOrderList";
  static const String shoppingCart = "/shoppingCart";
  static const String orderSuccess = "/orderSuccess";
  static const String checkOut = "/checkOut";
  static const String checkOut2 = "/checkOut2";
  static const String checkOutRefund = "/checkOutRefund";
  static const String orderDetail = "/orderDetail";
  static const String orderItemList = "/orderItemList";
  static const String blockedUsersList = "/blocked_users_list";
  static const String chatList = "/chat_users_list";
  static const String chat = "/chat";
  static const String homePortal = "/homePortal";
  static const String listUser = "/listUser";
  static const String listDelivery = "/listDelivery";
  static const String listOrder = "/listOrder";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (context) {
            return LoginScreen(from: settings.arguments as String);
            // return SignIn(from: settings.arguments as String);
          },
          fullscreenDialog: true,
        );

      case signUp:
        return MaterialPageRoute(
          builder: (context) {
            return const SignUp();
          },
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (context) {
            return const ForgotPassword();
          },
        );

      case otpForgotPassword:
        return MaterialPageRoute(
          builder: (context) {
            return OtpForgotPassword(
              countryCode:
                  (settings.arguments as Map<String, dynamic>)['countryCode'],
              phoneNumber:
                  (settings.arguments as Map<String, dynamic>)['phoneNumber'],
            );
          },
        );

      case otp:
        return MaterialPageRoute(
          builder: (context) {
            return Otp(
              userId: (settings.arguments as Map<String, dynamic>)['userId'],
              routeName:
                  (settings.arguments as Map<String, dynamic>)['routeName'],
            );
          },
        );

      case contactUs:
        return MaterialPageRoute(
          builder: (context) {
            return const ColorPicker();
          },
        );

      case productDetail:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case productScreen:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case searchHistory:
        return MaterialPageRoute(
          builder: (context) {
            return SearchHistory(image: settings.arguments as XFile?);
          },
          fullscreenDialog: true,
        );

      case notifications:
        return MaterialPageRoute(
          builder: (context) {
            return const Notifications();
          },
          fullscreenDialog: true,
        );

      case addressList:
        return MaterialPageRoute(
          builder: (context) {
            if (settings.arguments == null) {
              return const AddressList();
            } else {
              return AddressList(
                isSelectable: settings.arguments as bool,
              );
            }
          },
          fullscreenDialog: true,
        );

      case addAddress:
        return MaterialPageRoute(
          builder: (context) {
            AddressModel? item;
            bool? isSelectable;
            if (settings.arguments != null) {
              item = (settings.arguments as Map<String, dynamic>)['item'];
              isSelectable =
                  (settings.arguments as Map<String, dynamic>)['isSelectable'];
            }
            return AddAddress(item: item, isSelectable: isSelectable);
          },
          fullscreenDialog: true,
        );

      case views:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
          fullscreenDialog: true,
        );

      // case category:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       if (settings.arguments is int) {
      //         return const Home();
      //       } else if (settings.arguments is Map) {
      //         return const Home();
      //       }
      //       return const Home();
      //     },
      //   );
      case category:
        return MaterialPageRoute(
          builder: (context) {
            return Category(item: settings.arguments as CategoryModel?);
          },
        );

      case brand:
        return MaterialPageRoute(
          builder: (context) {
            if (settings.arguments is int) {
              return const Home();
            }
            return const Home();
          },
        );

      case listProfile:
        return MaterialPageRoute(
          builder: (context) {
            // return const ListProfile();
            return const Home();
          },
        );

      case colorPicker:
        return MaterialPageRoute(
          builder: (context) {
            return const ColorPicker();
          },
          fullscreenDialog: true,
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return const EditProfile();
          },
        );

      case changePassword:
        return MaterialPageRoute(
          builder: (context) {
            return ChangePassword(
              token: settings.arguments is Map<String, dynamic>
                  ? (settings.arguments as Map<String, dynamic>)['token']
                  : null,
              countryCode: settings.arguments is Map<String, dynamic>
                  ? (settings.arguments as Map<String, dynamic>)['countryCode']
                  : null,
              phoneNumber: settings.arguments is Map<String, dynamic>
                  ? (settings.arguments as Map<String, dynamic>)['phoneNumber']
                  : null,
            );
          },
        );

      case changeLanguage:
        return MaterialPageRoute(
          builder: (context) {
            return const LanguageSetting();
          },
        );

      case themeSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const ThemeSetting();
          },
        );

      case filter:
        return MaterialPageRoute(
          builder: (context) {
            return Filter(filter: settings.arguments as FilterModel);
          },
          fullscreenDialog: true,
        );

      case review:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case productReview:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case blockedUsersList:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case chatList:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case setting:
        return MaterialPageRoute(
          builder: (context) {
            return const Setting();
          },
        );

      case fontSetting:
        return MaterialPageRoute(
          builder: (context) {
            return const FontSetting();
          },
        );

      case feedback:
        return MaterialPageRoute(builder: (context) => const Home());
      case payment:
        return MaterialPageRoute(
            builder: (context) => PaymentMethods(
                orderId: (settings.arguments as Map)['orderId'],
                amount: (settings.arguments as Map)['amount'],
                unitName: (settings.arguments as Map)['unitName']));

      case shippingFeedback:
        return MaterialPageRoute(builder: (context) => const Home());

      case location:
        return MaterialPageRoute(
          builder: (context) => Location(
            location: settings.arguments as CoordinateModel,
          ),
        );

      case listProduct:
        return MaterialPageRoute(
          builder: (context) {
            var categoryId = settings.arguments as int?;
            return ListProduct(categoryId: categoryId);
          },
        );

      case categoryPicker:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
          fullscreenDialog: true,
        );

      case gpsPicker:
        return MaterialPageRoute(
          builder: (context) {
            CoordinateModel? item;
            if (settings.arguments != null) {
              item = settings.arguments as CoordinateModel;
            }
            return GPSPicker(
              picked: item,
            );
          },
          fullscreenDialog: true,
        );

      case picker:
        return MaterialPageRoute(
          builder: (context) {
            return Picker(
              picker: settings.arguments as PickerModel,
            );
          },
          fullscreenDialog: true,
        );

      case openTime:
        return MaterialPageRoute(
          builder: (context) {
            List<OpenTimeModel>? arguments;
            if (settings.arguments != null) {
              arguments = settings.arguments as List<OpenTimeModel>;
            }
            return const Home();
          },
          fullscreenDialog: true,
        );
      case socialNetwork:
        return MaterialPageRoute(
          builder: (context) {
            return SocialNetwork(
              socials: settings.arguments as Map<String, dynamic>?,
            );
          },
          fullscreenDialog: true,
        );

      case tagsPicker:
        return MaterialPageRoute(
          builder: (context) {
            return TagsPicker(
              selected: settings.arguments as List<String>,
            );
          },
          fullscreenDialog: true,
        );

      case sizesPicker:
        return MaterialPageRoute(
          builder: (context) {
            return SizesPicker(
              selected: settings.arguments as List<String>,
            );
          },
          fullscreenDialog: true,
        );

      case paypalPayment:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case shoppingCart:
        return MaterialPageRoute(
          builder: (context) {
            return const ShoppingCart();
          },
        );

      case orderSuccess:
        return MaterialPageRoute(
          builder: (context) {
            return const OrderSuccess();
          },
          fullscreenDialog: true,
        );

      case checkOut:
        return MaterialPageRoute(
          builder: (context) {
            return CheckOut(
              id: settings.arguments as int,
            );
          },
        );
      case checkOut2:
        return MaterialPageRoute(
          builder: (context) {
            return CheckOut2(
              order: settings.arguments as OrderModel,
            );
          },
        );

      case checkOutRefund:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
            // return CheckOutRefund(
            //   id: settings.arguments as int,
            // );
          },
        );

      // case order:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return Order(
      //         id: settings.arguments as int,
      //       );
      //     },
      //   );

      case orderList:
        return MaterialPageRoute(
          builder: (context) {
            return const OrderList();
          },
        );

      case customerOrderList:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case incompleteOrderList:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case orderDetail:
        return MaterialPageRoute(
          builder: (context) {
            return const Home();
          },
        );

      case orderItemList:
        return MaterialPageRoute(
          builder: (context) {
            return OrderItemList(
              arguments: settings.arguments as RouteArguments,
            );
          },
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
