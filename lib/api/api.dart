import 'dart:async';
import 'dart:convert';
import 'package:supermarket/api/http_manager.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/utils/utils.dart';
import '../blocs/app_bloc.dart';
import 'package:uuid/uuid.dart';

class Api {
  static final httpManager = HTTPManager();

  ///URL API
  static const String loadNotification = "api/v1/notifications/list";
  static const String portalLoadNotification = "api/v1/notifications/_list";
  static const String portalAddNotification = "api/v1/notifications/_send";
  static const String login = "api/identity/token";
  static const String fetch = "/api/identity/user";
  static const String authValidate = "api/identity/token/validate_token";
  static const String user = "api/identity/user/get-current";
  static const String userDetails = "api/identity/user/details";
  static const String deliveryDetails = "api/identity/delivery/details";
  static const String unactiveUser = "api/identity/user/unactive";
  static const String unactiveDelivery = "api/identity/delivery/unactive";
  static const String activeUser = "api/identity/user/active";
  static const String activeDelivery = "api/identity/delivery/active";
  static const String userRoles = "api/identity/user/roles";
  static const String updateUserRoles = "api/identity/user/roles";
  static const String addUser = "api/identity/user/create";
  static const String userAuthentication =
      "api/identity/user/user-authentication";
  static const String addDelivery = "api/identity/delivery/create";
  static const String addAccount = "api/v1/accounts";
  static const String allAccount = "api/v1/accounts";
  static const String journalEntries = "api/v1/journalEntries";
  static const String addJournalEntry = "api/v1/journalEntries/create";
  static const String updateJournalEntry = "api/v1/journalEntries/update";
  static const String deleteJournalEntry = "api/v1/journalEntries";
  static const String journalEntryNewId = "api/v1/journalEntries/new-id";
  static const String accountById = "api/v1/accounts";
  static const String addAccountCurrency = "api/v1/accounts/add-currency";
  static const String deleteAccountCurrency = "api/v1/accounts/delete-currency";
  static const String currencies = "api/v1/currencies";
  static const String addEditCurrency = "api/v1/currencies";
  static const String deleteCurrency = "api/v1/currencies";
  static const String changeProductStatus = "api/v1/products/change-status";
  static const String changeCategory = "api/v1/products/move-from-category";
  static const String updateImage = "api/v1/products/update-image";
  static const String initProduct = "api/v1/products/init";
  static const String register = "api/identity/user/registercustomer";
  static const String confirmPhoneNumber =
      "api/identity/user/confirm-phone-number";
  static const String confirmForgotPassword =
      "api/identity/user/confirm-forgot-password";
  static const String sendVerificationPhoneNumber =
      "api/identity/user/send-verification-phone-number";
  static const String forgotPassword = "api/identity/user/forgot-password";
  static const String validationPhoneNumber =
      "api/identity/user/validation-phone-number";
  static const String changePassword = "api/identity/account/changePassword";
  static const String resetPassword = "api/identity/user/reset-password";
  static const String changeProfile = "api/identity/account/updateProfile";
  static const String getUserRating = "api/identity/user/get-user-rating";
  static const String listAddress = "api/v1/customerAddress/bycustomertoken";
  static const String submitAddress = "api/v1/customerAddress";
  static const String removeAddress = "api/v1/shippingAddresses";
  static const String setDefaultAddress = "api/v1/shippingAddresses";
  static const String setting = "api/v1/setting/general";
  // static const String setting = "api/v1/setting";
  static const String submitSetting = "api/v1/setting/submit-text";
  static const String homeSections = "api/v1/homeSections";
  static const String allHomeSections = "api/v1/homeSections/all";
  static const String deleteHomeSection = "api/v1/homeSections";
  static const String reorderHomeSection =
      "api/v1/homeSections/reorder-home-section";
  static const String addEditOfferCategory =
      "api/v1/homeSections/create-offer-category";
  static const String addEditOfferCategory2 =
      "api/v1/homeSections/create-offer-category2";
  static const String addEditOfferDiscount =
      "api/v1/homeSections/create-offer-discount";
  static const String addEditCategoryMenu =
      "api/v1/homeSections/create-category-menu";
  static const String addEditCategoryMenu2 =
      "api/v1/homeSections/create-category-menu2";
  static const String addEditSlider = "api/v1/homeSections/create-slider";
  static const String addEditSlider2 = "api/v1/homeSections/create-slider2";
  static const String addEditImage = "api/v1/homeSections/create-image";
  static const String addEditAds = "api/v1/homeSections/create-ads";
  static const String addEditVideo = "api/v1/homeSections/create-video";
  static const String addEditFeaturedSellers =
      "api/v1/homeSections/create-featured-sellers";
  static const String addOfferCategoryItem =
      "api/v1/homeSections/create-offer-category-item";
  static const String addOfferCategoryItem2 =
      "api/v1/homeSections/create-offer-category-item2";
  static const String addOfferDiscountItem =
      "api/v1/homeSections/create-offer-discount-item";
  static const String addCategoryMenuItem =
      "api/v1/homeSections/create-category-menu-item";
  static const String addCategoryMenuItem2 =
      "api/v1/homeSections/create-category-menu-item2";
  static const String addSliderItem = "api/v1/homeSections/create-slider-item";
  static const String addSliderItem2 =
      "api/v1/homeSections/create-slider-item2";
  static const String addImageItem = "api/v1/homeSections/create-image-item";
  static const String addAdsItem = "api/v1/homeSections/create-ads-item";
  static const String addVideoItem = "api/v1/homeSections/create-video-item";
  static const String addFeaturedSellersItem =
      "api/v1/homeSections/create-featured-sellers-item";
  static const String deleteOfferCategoryItem =
      "api/v1/homeSections/delete-offer-category-item";
  static const String deleteOfferCategoryItem2 =
      "api/v1/homeSections/delete-offer-category-item2";
  static const String deleteOfferDiscountItem =
      "api/v1/homeSections/delete-offer-discount-item";
  static const String deleteCategoryMenuItem =
      "api/v1/homeSections/delete-category-menu-item";
  static const String deleteCategoryMenuItem2 =
      "api/v1/homeSections/delete-category-menu-item2";
  static const String deleteSliderItem =
      "api/v1/homeSections/delete-slider-item";
  static const String deleteSliderItem2 =
      "api/v1/homeSections/delete-slider-item2";
  static const String deleteImageItem = "api/v1/homeSections/delete-image-item";
  static const String deleteAdsItem = "api/v1/homeSections/delete-ads-item";
  static const String deleteVideoItem = "api/v1/homeSections/delete-video-item";
  static const String deleteFeaturedSellersItem =
      "api/v1/homeSections/delete-featured-sellers-item";
  static const String reorderOfferCategoryItem =
      "api/v1/homeSections/reorder-offer-category-item";
  static const String reorderOfferCategoryItem2 =
      "api/v1/homeSections/reorder-offer-category-item2";
  static const String reorderOfferDiscountItem =
      "api/v1/homeSections/reorder-offer-discount-item";
  static const String reorderCategoryMenuItem =
      "api/v1/homeSections/reorder-category-menu-item";
  static const String reorderCategoryMenuItem2 =
      "api/v1/homeSections/reorder-category-menu-item2";
  static const String reorderSliderItem =
      "api/v1/homeSections/reorder-slider-item";
  static const String reorderSliderItem2 =
      "api/v1/homeSections/reorder-slider-item2";
  static const String reorderFeaturedSellersItem =
      "api/v1/homeSections/reorder-featured-sellers-item";
  static const String home = "api/v1/home";
  static const String categories = "api/v1/category";
  static const String getAllPagedCategories = "api/v1/categories/get-all-paged";
  static const String discovery = "";
  static const String withLists = "api/v1/wishs";
  static const String addWishList = "api/v1/wishs/";
  static const String removeWishList = "api/v1/wishs/";
  static const String clearWithList = "api/v1/wishs/clear";
  static const String list = "api/v1/products";
  static const String listByCategory = "api/v1/products/category";
  static const String listPromotion = "api/v1/promotions";
  static const String portalList = "api/v1/products/_list";
  static const String deleteProduct = "api/v1/products";
  static const String authorList = "api/v1/products/user-list";
  static const String authorReview = "api/v1/reviews/list";
  static const String tags = "/bisat/v1/place/terms";
  static const String reviews = "api/v1/reviews/get-all-paged";
  static const String reviewsById = "api/v1/reviews/";
  static const String rating = "api/v1/reviews/get-rating/";
  static const String saveReview = "api/v1/reviews";
  static const String removeReview = "api/v1/reviews/";
  static const String saveReplay = "api/v1/reviews/replay";
  static const String removeReplay = "api/v1/reviews/replay/";
  static const String product = "api/v1/products/get";
  // static const String addView = "api/v1/products/add-view";
  static const String totalViews = "api/identity/views/";
  static const String userProductsViewsByDays =
      "api/identity/views/products-by-days";
  static const String userProductsViewsByHours =
      "api/identity/views/products-by-hours";
  static const String userProfileViewsByDays =
      "api/identity/views/profile-by-days";
  static const String userProfileViewsByHours =
      "api/identity/views/profile-by-hours";
  static const String addProductView = "api/identity/views/add-product-view";
  static const String addProfileView = "api/identity/views/add-profile-view";
  static const String saveProduct = "api/v1/products";
  static const String countries = "api/v1/countries";
  static const String locations = "api/v1/locations";
  static const String locationsById = "api/v1/locations/get-all/";
  static const String uploadImage = "api/utilities/upload/upload-image";
  static const String protectedUpload = "api/utilities/upload/protected-file";
  static const String privateUpload = "api/utilities/upload/private-file";
  static const String uploadImageBytes = "api/utilities/upload/image";
  static const String paymentByJawali = "api/v1/payment/jawali-wallet";
  static const String createPaymentIntent =
      "api/v1/payment/create-payment-intent";
  static const String createPaypalLink = "api/v1/payment/create-paypal-link";
  static const String productsByList = "api/v1/Promotions/productspromotions";
  static const String orderForm = "api/v1/orders/addtrttr-test";
  static const String calcPrice = "api/v1/orders/cart";
  static const String order = "api/v1/orders/order";
  static const String newOrder = "api/v1/order";
  static const String addDeleteCart = "api/v1/orders/add-delete-cart";
  static const String setShippingAddress = "api/v1/orders/set-shipping-address";
  static const String initOrder = "api/v1/orders/init-order";
  static const String removeFromCart = "api/v1/orders/remove-from-cart";
  static const String shippingFeeCalc = "api/v1/orders/shipping-fee-calc";
  static const String orderDetail = "api/v1/order/getbyid";
  static const String portalOrderDetail = "api/v1/orders";
  static const String portalSettingsJson = "api/v1/setting/json";
  static const String checkOut = "api/v1/orders/check-out";
  static const String customerOrderAmount =
      "api/v1/customerOrders/customer-order-amount";
  static const String orderList = "api/v1/order";
  static const String portalOrderList = "api/v1/orders/_order-list";
  static const String portalDelivaryReviewList =
      "api/v1/orders/_delivary-review-list";
  static const String customerOrderList = "api/v1/customerOrders";
  static const String outStockOrder = "api/v1/customerOrders/out-stock-order";
  static const String portalOutStockOrder =
      "api/v1/customerOrders/_out-stock-order";
  static const String confirmCustomerOrder =
      "api/v1/customerOrders/confirm-customer-order";
  static const String portalConfirmCustomerOrder =
      "api/v1/customerOrders/_confirm-customer-order";
  static const String confirmRefuseRefund =
      "api/v1/customerOrders/refusal-to-refund";
  static const String orderReceipt = "api/v1/orders/order-receipt";
  static const String shippingFeedback = "api/v1/orders/shipping-feedback";
  static const String refundRequest = "api/v1/orders/refund-request";
  static const String cancelRefundRequest =
      "api/v1/orders/cancel-refund-request";
  static const String complaint = "api/v1/orders/complaint";
  static const String closeComplaint = "api/v1/orders/close-complaint";
  static const String orderCancel = "api/v1/order/cancell";
  static const String confirmOrderByCash =
      "api/v1/orders/confirm-order-by-cash";
  static const String orderItemCancel = "api/v1/order/removeItem";
  static const String portalOrderItemCancel =
      "api/v1/orders/_cancel-order-item";
  static const String portalOrderItemShipping =
      "api/v1/orders/_shipping-order-item";
  static const String portalOrderReceipt = "api/v1/orders/_receipt-order";
  static const String portalJournalEntriesStatement = "api/v1/statements";
  static const String orderItemReceipt = "api/v1/orders/receipt-order-item";
  static const String sendContactUs = "api/v1/contactUs";
  static const String blockUser = "api/identity/user/block-user";
  static const String unblockUser = "api/identity/user/unblock-user";
  static const String sendProductReport = "api/v1/products/send-report";
  static const String sendProfileReport = "api/identity/user/send-report";
  static const String sendReviewReport = "api/v1/reviews/send-report";
  static const String sendChatReport = "api/v1/chats/send-report";
  static const String chatLoadById = "api/chats/chat-by-id";
  static const String chatLoadByContact = "api/chats/chat-by-contact";
  static const String saveMessage = "api/chats";
  static const String setReaction = "api/chats/set-reaction";
  static const String confirmReceiptStatus = "api/chats/confirm-receipt-status";
  static const String sendReadStatus = "api/chats/send-read-status";
  static const String sendDeliveredStatus = "api/chats/send-delivered-status";
  static const String sendDeliveredStatusUsers =
      "api/chats/send-delivered-status-users";
  static const String blockedUsers = "api/chats/blocked-users";
  static const String unreadMessagesCount = "api/chats/unread-messages-count";
  static const String chatUsers = "api/chats/users";
  static const String profiles = "api/identity/user/get-all-paged";
  static const String getProfiles = "api/identity/user/get-all-profiles";
  static const String getDeliveres = "api/identity/delivery/get-all";
  static const String deactivate = "api/identity/account/deactive";
  static const String policyAndPrivacy = "api/v1/PolicyAndPrivacy";
  static const String termsAndConditions =
      "api/v1/PolicyAndPrivacy/terms-and-conditions";

  /// Load Notification
  static Future<ResultApiModel> requestLoadNotification(params) async {
    final result = await httpManager.get(
        url:
            '$loadNotification?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}');
    return ResultApiModel.fromJson(result);
  }

  /// Portal Load Notification
  static Future<ResultApiModel> requestPortalLoadNotification(params) async {
    final result = await httpManager.get(
        url:
            '$portalLoadNotification?userId=${params['userId']}&pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}');
    return ResultApiModel.fromJson(result);
  }

  /// Portal Add Notification
  static Future<ResultApiModel> requestPortalAddNotification(params) async {
    final result = await httpManager.post(
        url: portalAddNotification, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Login api
  static Future<ResultApiModel> requestLogin(params) async {
    final result = await httpManager.post(url: login, data: params);
    if (result['succeeded'] == true) {
      HTTPManager.key = const Uuid().v4();
    }
    return ResultApiModel.fromJson(result);
  }

  ///Fetch api
  static Future<ResultApiModel> requestFetch() async {
    final result = await httpManager.get(url: fetch);
    if (result['succeeded'] == true) {
      HTTPManager.key = const Uuid().v4();
    }
    return ResultApiModel.fromJson(result);
  }

  ///Validate token valid
  static Future<ResultApiModel> requestValidateToken() async {
    Map<String, dynamic> result = {};
    try {
      result = await httpManager.post(url: authValidate, loading: false);
      result['success'] = result['code'] == 'jwt_auth_valid_token';
      result['message'] = result['code'] ?? result['message'];
    } catch (Exception) {
      result['success'] = result['code'] == 'jwt_auth_no_valid_token';
      result['message'] = result['code'] ?? 'jwt_auth_no_valid_token';
    }
    return ResultApiModel.fromJson(result);
  }

  ///Validation phone number
  static Future<ResultApiModel> requestValidationPhoneNumber(params) async {
    Map<String, dynamic> result = await httpManager.post(
      url: validationPhoneNumber,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Forgot password
  static Future<ResultApiModel> requestSendVerifiyCodeForgotPassword(
      params) async {
    Map<String, dynamic> result = await httpManager.post(
      url: forgotPassword,
      data: params,
      loading: true,
    );
    result['message'] = result['code'] ?? result['msg'];
    return ResultApiModel.fromJson(result);
  }

  ///Confirm Forgot Password
  static Future<ResultApiModel> requestConfirmForgotPassword(params) async {
    final result = await httpManager.post(
      // url:
      //     "$confirmForgotPassword/${params['countryCode']}/${params['phoneNumber']}/${params['otp']}",
      url: confirmForgotPassword,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Register account
  static Future<ResultApiModel> requestRegister(params) async {
    final result = await httpManager.post(
      url: register,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Confirm PhoneNumber
  static Future<ResultApiModel> requestConfirmPhoneNumber(params) async {
    final result = await httpManager.post(
      url: "$confirmPhoneNumber/${params['userId']}/${params['otp']}",
      // data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Resend Verification PhoneNumber
  static Future<ResultApiModel> requestSendVerificationPhoneNumber(
      params) async {
    final result = await httpManager.post(
      url:
          "$sendVerificationPhoneNumber/${params['userId']}/${params['confirmType']}",
      // data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Change Profile
  static Future<ResultApiModel> requestChangeProfile(params) async {
    final result = await httpManager.put(
      url: changeProfile,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///change password
  static Future<ResultApiModel> requestChangePassword(params) async {
    final result = await httpManager.put(
      url: changePassword,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///change password
  static Future<ResultApiModel> requestResetPassword(params) async {
    final result = await httpManager.post(
      url: resetPassword,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get User
  static Future<ResultApiModel> requestUser() async {
    final result = await httpManager.get(url: user);
    return ResultApiModel.fromJson(result);
  }

  ///Get User Details
  static Future<ResultApiModel> requestUserDetails(params) async {
    final result =
        await httpManager.get(url: '$userDetails/${params['userId']}');
    return ResultApiModel.fromJson(result);
  }

  ///Get Delivery Details
  static Future<ResultApiModel> requestDeliveryDetails(params) async {
    final result =
        await httpManager.get(url: '$deliveryDetails/${params['deliveryId']}');
    return ResultApiModel.fromJson(result);
  }

  ///Unactive User
  static Future<ResultApiModel> requestUnactiveUser(params) async {
    final result = await httpManager.get(
        url: '$unactiveUser/${params['userId']}/${params['because']}',
        loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Unactive Delivery
  static Future<ResultApiModel> requestUnactiveDelivery(params) async {
    final result = await httpManager.get(
        url: '$unactiveDelivery/${params['deliveryId']}/${params['because']}',
        loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Active User
  static Future<ResultApiModel> requestActiveUser(params) async {
    final result = await httpManager.get(
        url: '$activeUser/${params['userId']}', loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Active Delivery
  static Future<ResultApiModel> requestActiveDelivery(params) async {
    final result = await httpManager.get(
        url: '$activeDelivery/${params['deliveryId']}', loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///User Roles
  static Future<ResultApiModel> requestUserRoles(params) async {
    final result = await httpManager.get(
        url: '$userRoles/${params['userId']}', loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Update User Roles
  static Future<ResultApiModel> requestUpdateUserRoles(params) async {
    final result = await httpManager.put(
        url: '$updateUserRoles/${params['userId']}',
        data: params,
        loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add User
  static Future<ResultApiModel> requestAddUser(params) async {
    final result = await httpManager.post(
      url: addUser,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///User Authentication
  static Future<ResultApiModel> requestUserAuthentication(params) async {
    final result = await httpManager.post(
      url: userAuthentication,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Add Delivery
  static Future<ResultApiModel> requestAddDelivery(params) async {
    final result = await httpManager.post(
      url: addDelivery,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Deliveres
  static Future<ResultApiModel> requestDeliveres(params) async {
    final result = await httpManager.post(url: getDeliveres, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Add Account
  static Future<ResultApiModel> requestAddAccount(params) async {
    final result = await httpManager.post(
      url: addAccount,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get All Paged Accounts
  static Future<ResultApiModel> requestLoadAccounts(params) async {
    String url = '$allAccount/${params['pageNumber']}/${params['pageSize']}';
    if (params['searchString'] != null && params['searchString'].isNotEmpty) {
      url += '/${params['searchString']}';
    }
    if (params['accountType'] != null) {
      url += '/${params['accountType']}';
    }
    final result = await httpManager.get(
      url: url,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Account By Id
  static Future<ResultApiModel> requestAccountById(params) async {
    final result = await httpManager.get(
      url: '$accountById/${params['accountId']}',
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Add Account Currency
  static Future<ResultApiModel> requestAddAccountCurrency(params) async {
    final result = await httpManager.post(
      url: addAccountCurrency,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Delete Account Currency
  static Future<ResultApiModel> requestDeleteAccountCurrency(params) async {
    final result = await httpManager.post(
      url: deleteAccountCurrency,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get All Accounts
  static Future<ResultApiModel> requestAllAccounts() async {
    final result = await httpManager.get(
      url: allAccount,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get All Paged Journal Entries
  static Future<ResultApiModel> requestLoadJournalEntry(params) async {
    String url =
        '$journalEntries/${params['pageNumber']}/${params['pageSize']}';
    if (params['searchString'] != null && params['searchString'].isNotEmpty) {
      url += '/${params['searchString']}';
    }
    if (params['entryType'] != null) {
      url += '/${params['entryType']}';
    }
    final result = await httpManager.get(
      url: url,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Add Journal Entry
  static Future<ResultApiModel> requestAddJournalEntry(params) async {
    final result = await httpManager.post(
      url: addJournalEntry,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Add Journal Entry
  static Future<ResultApiModel> requestUpdateJournalEntry(params) async {
    final result = await httpManager.post(
      url: updateJournalEntry,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Delete Journal Entry
  static Future<ResultApiModel> requestDeleteJournalEntry(params) async {
    final result = await httpManager.delete(
      url: '$deleteJournalEntry/${params['entryType']}/${params['entryId']}',
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Journal Entry New Id
  static Future<ResultApiModel> requestJournalEntryNewId(entryType) async {
    final result = await httpManager.get(
      url: '$journalEntryNewId/$entryType',
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get All Currencies
  static Future<ResultApiModel> requestLoadCurrencies() async {
    final result = await httpManager.get(
      url: currencies,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Add/Edit Currency
  static Future<ResultApiModel> requestAddEditCurrency(params) async {
    final result = await httpManager.post(
      url: addEditCurrency,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Delete Currency
  static Future<ResultApiModel> requestDeleteCurrency(params) async {
    final result = await httpManager.delete(
      url: '$deleteCurrency/${params['id']}',
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Change Product Status
  static Future<ResultApiModel> requestChangeProductStatus(params) async {
    final result = await httpManager.post(
        url: changeProductStatus, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Change Category
  static Future<ResultApiModel> requestChangeCategory(params) async {
    final result = await httpManager.post(
        url: changeCategory, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Update Image
  static Future<ResultApiModel> requestUpdateImage(params) async {
    final result =
        await httpManager.post(url: updateImage, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Init Product
  static Future<ResultApiModel> requestInitProduct(params) async {
    final result =
        await httpManager.post(url: initProduct, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  static Future<ResultApiModel> requestUserRating(String userId) async {
    final result =
        await httpManager.get(url: "$getUserRating/$userId", loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///All Address
  static Future<ResultApiModel> requestAllAddresses() async {
    final result = await httpManager.get(url: listAddress, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Submit Address
  static Future<ResultApiModel> requestSubmitAddress(param) async {
    final result =
        await httpManager.post(url: submitAddress, data: param, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Remove Address
  static Future<ResultApiModel> requestRemoveAddress(id) async {
    final result =
        await httpManager.delete(url: "$removeAddress/$id", loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Set The Default Address
  static Future<ResultApiModel> requestSetDefaultAddress(param) async {
    final result = await httpManager.put(
        url: setDefaultAddress, data: param, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Get Setting
  static Future<ResultApiModel> requestSetting() async {
    final result = await httpManager.get(url: setting);
    return ResultApiModel.fromJson(result);
  }

  ///Get Submit Setting
  static Future<ResultApiModel> requestSubmitSetting(
      int countryId, progress) async {
    final result = await httpManager.getText(
      url: "$submitSetting/$countryId",
      progress: progress,
      // params: params,
    );
    return ResultApiModel.fromJson(jsonDecode(result));
  }

  ///Get Countries
  static Future<ResultApiModel> requestCountries() async {
    final result = await httpManager.get(url: countries, loading: false);

    return ResultApiModel.fromJson(result);
  }

  ///Get Location
  static Future<ResultApiModel> requestLocation(LocationType? type) async {
    String url = locations;
    if (type != null) {
      url = "$locations?type=${type.index}";
    }
    final result = await httpManager.get(url: url);
    return ResultApiModel.fromJson(result);
  }

  ///Get Location
  static Future<ResultApiModel> requestLocationById(param) async {
    String url = "$locationsById${param['countryId']}";
    if (param['parentId'] != null) {
      url = "$url/${param['parentId']}";
    }
    final result = await httpManager.get(url: url, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Get Category
  static Future<ResultApiModel> requestCategory() async {
    final result = await httpManager.get(url: categories);
    return ResultApiModel.fromJson(result);
  }

  ///Get Category
  static Future<ResultApiModel> requestCategories() async {
    final result =
        await httpManager.get(url: getAllPagedCategories, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Get Category
  static Future<ResultApiModel> requestCategoryList() async {
    final result = await httpManager.get(url: categories);
    return ResultApiModel.fromJson(result);
  }

  ///Get Discovery
  static Future<ResultApiModel> requestDiscovery() async {
    final result = await httpManager.get(url: discovery);
    return ResultApiModel.fromJson(result);
  }

  ///Get Home
  static Future<ResultApiModel> requestHome() async {
    final result = await httpManager.get(url: home);
    return ResultApiModel.fromJson(result);
  }

  ///Get Home Sections
  static Future<ResultApiModel> requestHomeSections(params) async {
    String url;
    if (params['categoryId'] != null) {
      url =
          "$homeSections?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}&categoryId=${params['categoryId']}&withUnActive=${params['withUnActive']}&lang=${params['lang']}";
    } else {
      url =
          "$homeSections?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}&withUnActive=${params['withUnActive']}&lang=${params['lang']}";
    }
    final result = await httpManager.get(url: url, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Get All Home Sections
  static Future<ResultApiModel> requestAllHomeSections(params) async {
    String url =
        "$allHomeSections?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}";
    final result = await httpManager.get(url: url, loading: false);
    return ResultApiModel.fromJson(result);
  }

  // ///Get Home Sections
  // static Future<ResultApiModel> requestHomeSections(params) async {
  //   String url =
  //       "$homeSections?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}";
  //   final result = await httpManager.get(url: url, loading: false);
  //   return ResultApiModel.fromJson(result);
  // }

  ///Delete Home Section
  static Future<ResultApiModel> requestDeleteHomeSection(params) async {
    final result = await httpManager.delete(
        url: '$deleteHomeSection/${params['sectionId']}', loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Home Section
  static Future<ResultApiModel> requestReorderHomeSection(params) async {
    final result = await httpManager.post(
        url: reorderHomeSection, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Add Offer Category
  static Future<ResultApiModel> requestAddEditOfferCategory(params) async {
    final result = await httpManager.post(
        url: addEditOfferCategory, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Offer Category 2
  static Future<ResultApiModel> requestAddEditOfferCategory2(params) async {
    final result = await httpManager.post(
        url: addEditOfferCategory2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Offer Discount
  static Future<ResultApiModel> requestAddEditOfferDiscount(params) async {
    final result = await httpManager.post(
        url: addEditOfferDiscount, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Category Menu
  static Future<ResultApiModel> requestAddEditCategoryMenu(params) async {
    final result = await httpManager.post(
        url: addEditCategoryMenu, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Category Menu 2
  static Future<ResultApiModel> requestAddEditCategoryMenu2(params) async {
    final result = await httpManager.post(
        url: addEditCategoryMenu2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Slider
  static Future<ResultApiModel> requestAddEditSlider(params) async {
    final result =
        await httpManager.post(url: addEditSlider, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Slider 2
  static Future<ResultApiModel> requestAddEditSlider2(params) async {
    final result = await httpManager.post(
        url: addEditSlider2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Image
  static Future<ResultApiModel> requestAddEditImage(params) async {
    final result =
        await httpManager.post(url: addEditImage, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Ads
  static Future<ResultApiModel> requestAddEditAds(params) async {
    final result =
        await httpManager.post(url: addEditAds, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Video
  static Future<ResultApiModel> requestAddEditVideo(params) async {
    final result =
        await httpManager.post(url: addEditVideo, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Featured Sellers
  static Future<ResultApiModel> requestAddEditFeaturedSellers(params) async {
    final result = await httpManager.post(
        url: addEditFeaturedSellers, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Offer Category Item
  static Future<ResultApiModel> requestAddOfferCategoryItem(params) async {
    final result = await httpManager.post(
        url: addOfferCategoryItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Offer Category Item 2
  static Future<ResultApiModel> requestAddOfferCategoryItem2(params) async {
    final result = await httpManager.post(
        url: addOfferCategoryItem2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Offer Discount Item
  static Future<ResultApiModel> requestAddOfferDiscountItem(params) async {
    final result = await httpManager.post(
        url: addOfferDiscountItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Category Menu Item
  static Future<ResultApiModel> requestAddCategoryMenuItem(params) async {
    final result = await httpManager.post(
        url: addCategoryMenuItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Category Menu Item 2
  static Future<ResultApiModel> requestAddCategoryMenuItem2(params) async {
    final result = await httpManager.post(
        url: addCategoryMenuItem2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Slider Item
  static Future<ResultApiModel> requestAddSliderItem(params) async {
    final result =
        await httpManager.post(url: addSliderItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Slider Item 2
  static Future<ResultApiModel> requestAddSliderItem2(params) async {
    final result = await httpManager.post(
        url: addSliderItem2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Image Item
  static Future<ResultApiModel> requestAddImageItem(params) async {
    final result =
        await httpManager.post(url: addImageItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Ads Item
  static Future<ResultApiModel> requestAddAdsItem(params) async {
    final result =
        await httpManager.post(url: addAdsItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Video Item
  static Future<ResultApiModel> requestAddVideoItem(params) async {
    final result =
        await httpManager.post(url: addVideoItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Add Featured Sellers Item
  static Future<ResultApiModel> requestAddFeaturedSellersItem(params) async {
    final result = await httpManager.post(
        url: addFeaturedSellersItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Offer Category Item
  static Future<ResultApiModel> requestDeleteOfferCategoryItem(params) async {
    final result = await httpManager.delete(
        url: deleteOfferCategoryItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Offer Category Item 2
  static Future<ResultApiModel> requestDeleteOfferCategoryItem2(params) async {
    final result = await httpManager.delete(
        url: deleteOfferCategoryItem2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Offer Discount Item
  static Future<ResultApiModel> requestDeleteOfferDiscountItem(params) async {
    final result = await httpManager.delete(
        url: deleteOfferDiscountItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Category Menu Item
  static Future<ResultApiModel> requestDeleteCategoryMenuItem(params) async {
    final result = await httpManager.delete(
        url: deleteCategoryMenuItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Category Menu Item 2
  static Future<ResultApiModel> requestDeleteCategoryMenuItem2(params) async {
    final result = await httpManager.delete(
        url: deleteCategoryMenuItem2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Slider Item
  static Future<ResultApiModel> requestDeleteSliderItem(params) async {
    final result = await httpManager.delete(
        url: deleteSliderItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Slider Item 2
  static Future<ResultApiModel> requestDeleteSliderItem2(params) async {
    final result = await httpManager.delete(
        url: deleteSliderItem2, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Image Item
  static Future<ResultApiModel> requestDeleteImageItem(params) async {
    final result = await httpManager.delete(
        url: deleteImageItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Ads Item
  static Future<ResultApiModel> requestDeleteAdsItem(params) async {
    final result = await httpManager.delete(
        url: deleteAdsItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Video Item
  static Future<ResultApiModel> requestDeleteVideoItem(params) async {
    final result = await httpManager.delete(
        url: deleteVideoItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Delete Featured Sellers Item
  static Future<ResultApiModel> requestDeleteFeaturedSellersItem(params) async {
    final result = await httpManager.delete(
        url: deleteFeaturedSellersItem, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Offer Category Item
  static Future<ResultApiModel> requestReorderOfferCategoryItem(params) async {
    final result = await httpManager.post(
        url: reorderOfferCategoryItem, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Offer Category Item 2
  static Future<ResultApiModel> requestReorderOfferCategoryItem2(params) async {
    final result = await httpManager.post(
        url: reorderOfferCategoryItem2, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Offer Discount Item
  static Future<ResultApiModel> requestReorderOfferDiscountItem(params) async {
    final result = await httpManager.post(
        url: reorderOfferDiscountItem, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Category Menu Item
  static Future<ResultApiModel> requestReorderCategoryMenuItem(params) async {
    final result = await httpManager.post(
        url: reorderCategoryMenuItem, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Category Menu Item 2
  static Future<ResultApiModel> requestReorderCategoryMenuItem2(params) async {
    final result = await httpManager.post(
        url: reorderCategoryMenuItem2, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Slider Item
  static Future<ResultApiModel> requestReorderSliderItem(params) async {
    final result = await httpManager.post(
        url: reorderSliderItem, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Slider Item 2
  static Future<ResultApiModel> requestReorderSliderItem2(params) async {
    final result = await httpManager.post(
        url: reorderSliderItem2, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Reorder Featured Sellers Item
  static Future<ResultApiModel> requestReorderFeaturedSellersItem(
      params) async {
    final result = await httpManager.post(
        url: reorderFeaturedSellersItem, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Get User Products Views (By Days)
  static Future<ResultApiModel> requestProductsByDaysViews(params) async {
    final result = await httpManager.get(
        url:
            "$userProductsViewsByDays/${params['from']}/${params['to']}/${params['pageNumber']}/${params['pageSize']}");
    return ResultApiModel.fromJson(result);
  }

  ///Get Total Views
  static Future<ResultApiModel> requestTotalViews() async {
    final result = await httpManager.get(url: totalViews);
    return ResultApiModel.fromJson(result);
  }

  ///Get User Products Views (By Hours)
  static Future<ResultApiModel> requestProductsByHoursViews(params) async {
    final result = await httpManager.get(
        url:
            "$userProductsViewsByHours/${params['from']}/${params['to']}/${params['pageNumber']}/${params['pageSize']}");
    return ResultApiModel.fromJson(result);
  }

  ///Get User Profile Views (By Days)
  static Future<ResultApiModel> requestProfileByDaysViews(params) async {
    final result = await httpManager.get(
        url:
            "$userProfileViewsByDays/${params['from']}/${params['to']}/${params['pageNumber']}/${params['pageSize']}");
    return ResultApiModel.fromJson(result);
  }

  ///Get User Profile Views (By Hours)
  static Future<ResultApiModel> requestProfileByHoursViews(params) async {
    final result = await httpManager.get(
        url:
            "$userProfileViewsByHours/${params['from']}/${params['to']}/${params['pageNumber']}/${params['pageSize']}");
    return ResultApiModel.fromJson(result);
  }

  ///Get ProductDetail
  static Future<ResultApiModel> requestProduct(params) async {
    final result = await httpManager.get(
      url: "$product/${params['id']}",
    );
    if (result['succeeded'] == true) {
      httpManager.post(url: "$addProductView/${params['id']}").ignore();
      // httpManager.product(url: addView, data: params).ignore();
    }
    return ResultApiModel.fromJson(result);
  }

  ///Get Wish List
  static Future<ResultApiModel> requestWishList(params) async {
    final result =
        await httpManager.get(url: withLists, params: {'id': params});
    return ResultApiModel.fromJson(result);
  }

  ///Save Wish List
  static Future<ResultApiModel> requestAddWishList(params) async {
    final result = await httpManager.post(
        url: addWishList + params.toString(), loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Save Product
  static Future<ResultApiModel> requestSaveProduct(params) async {
    final result = await httpManager.post(
      url: saveProduct,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Remove Wish List
  static Future<ResultApiModel> requestRemoveWishList(params) async {
    final result = await httpManager.delete(
      url: removeWishList + params.toString(),
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Clear Wish List
  static Future<ResultApiModel> requestClearWishList() async {
    final result = await httpManager.delete(url: clearWithList, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Get Product List
  static Future<ResultApiModel> requestList(params, loading) async {
    String url =
        '${params['categoryId'] == null ? list : listByCategory}?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}';
    if (params['searchString'] != null && params['searchString'] != '') {
      url = '$url&searchString=${params['searchString']}';
    }
    final result = await httpManager.get(
      url: url,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Promotion List
  static Future<ResultApiModel> requestPromotionList(params) async {
    String url =
        '$listPromotion?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}';
    if (params['searchString'] != null && params['searchString'] != '') {
      url = '$url&searchString=${params['searchString']}';
    }
    final result = await httpManager.get(
      url: url,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Tags List
  static Future<ResultApiModel> requestTags(params) async {
    final result = await httpManager.get(url: tags, params: params);
    return ResultApiModel.fromJson(result);
  }

  ///Clear Wish List
  static Future<ResultApiModel> requestDeleteProduct(id) async {
    final result = await httpManager.delete(
      url: "$deleteProduct/$id",
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Author Product List
  static Future<ResultApiModel> requestAuthorList(params) async {
    final result = await httpManager.post(
      url: authorList,
      data: params,
      loading: true,
    );
    httpManager.post(url: "$addProfileView/${params['createdBy']}").ignore();
    return ResultApiModel.fromJson(result);
  }

  ///Get Author Review List
  static Future<ResultApiModel> requestAuthorReview(params) async {
    final result = await httpManager.post(
      url: authorReview,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Rating
  static Future<ResultApiModel> requestRating() async {
    final result = await httpManager.get(url: rating);
    return ResultApiModel.fromJson(result);
  }

  ///Get Review
  static Future<ResultApiModel> requestReview(params) async {
    final result = await httpManager.get(
        url:
            '$reviews?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}&searchString=${params['searchString']}');
    return ResultApiModel.fromJson(result);
  }

  ///Get Review For Product
  static Future<ResultApiModel> requestReviewById(params) async {
    final result = await httpManager.get(
        url: reviewsById + params["productId"].toString());
    return ResultApiModel.fromJson(result);
  }

  ///Save Review
  static Future<ResultApiModel> requestSaveReview(params) async {
    final result = await httpManager.post(
      url: saveReview,
      data: params,
      loading: true,
    );

    return ResultApiModel.fromJson(result);
  }

  ///Save Replay
  static Future<ResultApiModel> requestSaveReplay(params) async {
    final result = await httpManager.post(
      url: saveReplay,
      data: params,
      loading: true,
    );

    return ResultApiModel.fromJson(result);
  }

  ///Remove Review
  static Future<ResultApiModel> requestRemoveReview(id) async {
    final result = await httpManager.delete(
      url: removeReview + id.toString(),
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Remove Replay
  static Future<ResultApiModel> requestRemoveReplay(id) async {
    final result = await httpManager.delete(
      url: removeReplay + id.toString(),
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Profiles
  static Future<ResultApiModel> requestProfiles(params) async {
    final result = await httpManager.post(url: getProfiles, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Upload image
  static Future<ResultApiModel> requestUploadImage(formData, progress) async {
    var result = await httpManager.post(
      url: uploadImage,
      formData: formData,
      progress: progress,
    );

    final convertResponse = {"success": result['id'] != null, "data": result};
    return ResultApiModel.fromJson(convertResponse);
  }

  ///Upload image Bytes
  static Future<ResultApiModel> requestUploadImageBytes(
      params, progress) async {
    var result = await httpManager.post(
      url: uploadImageBytes,
      data: params,
      progress: progress,
    );

    // final convertResponse = {"success": result['id'] != null, "data": result};
    return ResultApiModel.fromJson(result);
  }

  ///Protected Upload
  static Future<ResultApiModel> requestProtectedUpload(params, progress) async {
    var result = await httpManager.post(
      url: protectedUpload,
      data: params,
      progress: progress,
    );

    // final convertResponse = {"success": result['id'] != null, "data": result};
    return ResultApiModel.fromJson(result);
  }

  ///Private Upload
  static Future<ResultApiModel> requestPrivateUpload(params, progress) async {
    var result = await httpManager.post(
      url: privateUpload,
      data: params,
      progress: progress,
    );

    // final convertResponse = {"success": result['id'] != null, "data": result};
    return ResultApiModel.fromJson(result);
  }

  ///Payment By Jawali
  static Future<ResultApiModel> requestPaymentByJawali(params) async {
    final result = await httpManager.post(
      url: paymentByJawali,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Create PaymentIntent
  static Future<ResultApiModel> requestCreatePaymentIntent(params) async {
    final result = await httpManager.post(
      url: createPaymentIntent,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Create PaymentIntent
  static Future<ResultApiModel> requestCreatePaypalLink(params) async {
    final result = await httpManager.post(
      url: createPaypalLink,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get order form
  static Future<ResultApiModel> requestOrderForm(params) async {
    final result = await httpManager.get(
      url: orderForm,
      // params: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Price
  static Future<ResultApiModel> requestPrice(params) async {
    final result = await httpManager.post(
      url: calcPrice,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Order
  static Future<ResultApiModel> requestOrder(params) async {
    final result = await httpManager.post(
      url: order,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Shipping Fee Calc
  static Future<ResultApiModel> requestShippingFeeCalc(
      id, latitude, longitude) async {
    final result =
        await httpManager.get(url: '$shippingFeeCalc/$id/$latitude/$longitude');
    return ResultApiModel.fromJson(result);
  }

  ///Get Order Detail
  static Future<ResultApiModel> requestOrderDetail(id) async {
    dynamic result;
    result = await httpManager.get(url: '$orderDetail?id=$id&isDetails=false');
    return ResultApiModel.fromJson(result);
  }

  ///Get Order Detail
  static Future<ResultApiModel> requestPortalOrderDetail(id) async {
    dynamic result;
    if (id == null) {
      result = await httpManager.get(url: '$portalOrderDetail/');
    } else {
      result = await httpManager.get(url: '$portalOrderDetail/$id');
    }
    return ResultApiModel.fromJson(result);
  }

  ///Get Settings Json
  static Future<ResultApiModel> requestPortalSettingsJson() async {
    final result =
        await httpManager.get(url: portalSettingsJson, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Post Settings Json
  static Future<ResultApiModel> requestPortalSaveSettingsJson(params) async {
    final result = await httpManager.post(
        url: portalSettingsJson, data: params, loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///New Order
  static Future<ResultApiModel> requestNewOrder(params) async {
    final result =
        await httpManager.post(url: newOrder, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Check Out
  static Future<ResultApiModel> requestCheckOut(params) async {
    String url = '$checkOut/${params['orderId']}';
    if (params['currencyId'] != null) {
      url += '/${params['currencyId']}';
    }
    final result = await httpManager.get(url: url);
    return ResultApiModel.fromJson(result);
  }

  static Future<ResultApiModel> requestProductsByList(params) async {
    final result = await httpManager.post(url: productsByList, data: params);
    return ResultApiModel.fromJson(result);
  }

  /// Customer Order Amount
  static Future<ResultApiModel> requestCustomerOrderAmount(id) async {
    final result =
        await httpManager.get(url: '$customerOrderAmount/$id', loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Get Customer Order List
  static Future<ResultApiModel> requestCustomerOrderList(params) async {
    final result = await httpManager.get(
        url:
            "$customerOrderList?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}&searchString=${params['searchString'] ?? ''}&orderStatus=${params['orderStatus'] ?? ''}&orderBy=${params['orderBy'] ?? ''}",
        loading: false);

    return ResultApiModel.fromJson(result);
  }

  ///Out Stock Order
  static Future<ResultApiModel> requestOutStockOrder(params) async {
    final result =
        await httpManager.post(url: outStockOrder, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Portal Get Product List
  static Future<ResultApiModel> requestPortalList(params, loading) async {
    final result = await httpManager.post(
      url: portalList,
      data: params,
      loading: false, //loading ?? false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Portal Out Stock Order
  static Future<ResultApiModel> requestPortalOutStockOrder(params) async {
    final result = await httpManager.post(
        url: portalOutStockOrder, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Confirm Customer Order
  static Future<ResultApiModel> requestConfirmCustomerOrder(params) async {
    final result = await httpManager.post(
        url: confirmCustomerOrder, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///PortalConfirm Customer Order
  static Future<ResultApiModel> requestPortalConfirmCustomerOrder(
      params) async {
    final result = await httpManager.post(
        url: portalConfirmCustomerOrder, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Confirm Refuse Refund
  static Future<ResultApiModel> requestConfirmRefuseRefund(params) async {
    final result = await httpManager.post(
        url: confirmRefuseRefund, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }

  ///Get Order List
  static Future<ResultApiModel> requestOrderList(params) async {
    final result = await httpManager.get(
        url:
            "$orderList?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}&searchString=${params['searchString'] ?? ''}&status=${params['status'] ?? ''}&orderBy=${params['orderBy'] ?? ''}&deliveryId=${params['deliveryId'] ?? ''}",
        loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Get Order List
  static Future<ResultApiModel> requestPortalOrderList(params) async {
    final result = await httpManager.get(
        url:
            "$portalOrderList?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}&searchString=${params['searchString'] ?? ''}&orderStatus=${params['orderStatus'] ?? ''}&orderBy=${params['orderBy'] ?? ''}&deliveryId=${params['deliveryId'] ?? ''}",
        loading: false);
    return ResultApiModel.fromJson(result);
  }

  ///Get Delivary Review List
  static Future<ResultApiModel> requestPortalDelivaryReviewList(params) async {
    final result = await httpManager.get(
        url:
            "$portalDelivaryReviewList?pageNumber=${params['pageNumber']}&pageSize=${params['pageSize']}&searchString=${params['searchString'] ?? ''}&deliveryId=${params['deliveryId'] ?? ''}",
        loading: false);
    return ResultApiModel.fromJson(result);
  }

  // ///Order Cancel
  // static Future<ResultApiModel> requestOrderCancel(params) async {
  //   final result = await httpManager.product(
  //     url: orderCancel,
  //     data: params,
  //     loading: true,
  //   );
  //   return ResultApiModel.fromJson(result);
  // }

  ///Order Receipt
  static Future<ResultApiModel> requestOrderReceipt(params) async {
    final result = await httpManager.post(
      url: orderReceipt,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Shipping Feedback
  static Future<ResultApiModel> requestShippingFeedback(params) async {
    final result = await httpManager.post(
      url: shippingFeedback,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Request Return
  static Future<ResultApiModel> requestRefundRequest(params) async {
    final result = await httpManager.post(
      url: refundRequest,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Cancel Request Return
  static Future<ResultApiModel> requestCancelRefundRequest(params) async {
    final result = await httpManager.post(
      url: cancelRefundRequest,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Complaint
  static Future<ResultApiModel> requestComplaint(params) async {
    final result = await httpManager.post(
      url: complaint,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Close Complaint
  static Future<ResultApiModel> requestCloseComplaint(params) async {
    final result = await httpManager.post(
      url: closeComplaint,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Order Cancel
  static Future<ResultApiModel> requestOrderCancel(params) async {
    final result = await httpManager.post(
      url: "$orderCancel/${params['id']}",
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Confirm Order By Cash
  static Future<ResultApiModel> requestConfirmOrderByCash(params) async {
    final result = await httpManager.post(
      url: confirmOrderByCash,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Order Cancel
  static Future<ResultApiModel> requestOrderItemCancel(params) async {
    // final result = await httpManager.delete(
    //   url: "$orderItemCancel/${params['orderId']}/${params['orderItemId']}",
    //   loading: true,
    // );
    final result = await httpManager.delete(
      url: '$orderItemCancel/${params['orderId']}/${params['orderItemId']}',
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Portal Order Cancel
  static Future<ResultApiModel> requestPortalOrderItemCancel(params) async {
    final result = await httpManager.post(
      url: portalOrderItemCancel,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Portal Order Shipping
  static Future<ResultApiModel> requestPortalOrderItemShipping(params) async {
    final result = await httpManager.post(
      url: portalOrderItemShipping,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Portal Order Receipt
  static Future<ResultApiModel> requestPortalOrderReceipt(params) async {
    final result = await httpManager.post(
      url: portalOrderReceipt,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Portal Journal Entries Statement
  static Future<dynamic> requestJournalEntriesStatement() async {
    final result = await httpManager.get(
      url: portalJournalEntriesStatement,
      loading: true,
    );
    return result;
  }

  ///Add Delete Cart
  static Future<ResultApiModel> requestAddDeleteCart(params) async {
    final result = await httpManager.post(url: addDeleteCart, data: params);
    return ResultApiModel.fromJson(result);
  }

  ///Set Shipping Address
  static Future<ResultApiModel> requestSetShippingAddress(params) async {
    final result = await httpManager.put(url: setShippingAddress, data: params);
    return ResultApiModel.fromJson(result);
  }

  /// Order Item Receipt
  static Future<ResultApiModel> requestOrderItemReceipt(params) async {
    final result = await httpManager.post(
      url: orderItemReceipt,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///CheckOut
  static Future<ResultApiModel> requestInitOrder(params) async {
    final result =
        await httpManager.post(url: initOrder, data: params, loading: true);
    return ResultApiModel.fromJson(result);
  }
  // static Future<ResultApiModel> requestCheckOut(params) async {
  //   final result =
  //       await httpManager.post(url: checkOut, data: params, loading: true);
  //   return ResultApiModel.fromJson(result);
  // }

  ///Download file
  static Future<ResultApiModel> requestDownloadFile({
    required FileModel file,
    required progress,
    String? directory,
  }) async {
    directory ??= await UtilFile.getFilePath();
    final filePath = '$directory/${file.name}.${file.type}';
    final result = await httpManager.download(
      url: file.url,
      filePath: filePath,
      progress: progress,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Deactivate account
  static Future<ResultApiModel> requestDeactivate(params) async {
    final result = await httpManager.post(
      url: "$deactivate/${params['deactiveReason']}",
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Block User
  static Future<ResultApiModel> requestBlockUser(params) async {
    final result = await httpManager.post(
      url: "$blockUser/${params['userId']}/${params['because']}",
      // data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///UnBlock User
  static Future<ResultApiModel> requestUnBlockUser(String userId) async {
    final result = await httpManager.post(
      url: "$unblockUser/$userId",
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Send Report
  static Future<ResultApiModel> requestSendReport(
      params, ReportType reportType) async {
    final result = await httpManager.post(
      url: reportType == ReportType.product
          ? sendProductReport
          : reportType == ReportType.profile
              ? sendProfileReport
              : reportType == ReportType.chat
                  ? sendChatReport
                  : sendReviewReport,
      data: params,
      loading: true,
    );
    if (result) {
      return ResultApiModel.fromJson({'succeeded': true, 'data': true});
    } else {
      return ResultApiModel.fromJson({'succeeded': true, 'data': false});
    }
  }

  ///Send Message Contact Us
  static Future<ResultApiModel> requestSendContactUs(params) async {
    final result = await httpManager.post(
      url: sendContactUs,
      data: params,
      loading: true,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Get Chat
  static Future<ResultApiModel> requestChat({
    required int chatId,
    required String contactId,
    required int pageNumber,
    required int pageSize,
    bool loading = false,
  }) async {
    dynamic result;
    if (chatId != 0) {
      result = await httpManager.get(
        url: "$chatLoadById/$chatId/$pageNumber/$pageSize",
        loading: loading,
      );
    } else {
      result = await httpManager.get(
        url: "$chatLoadByContact/$contactId/$pageNumber/$pageSize",
        loading: loading,
      );
    }
    return ResultApiModel.fromJson(result);
  }

  ///Save Message Chat
  static Future<ResultApiModel> requestSaveMessage(params, progress) async {
    final result = await httpManager.post(
      url: saveMessage,
      data: params,
      loading: false,
      progress: progress,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Set Reaction
  static Future<ResultApiModel> requestSetReaction(params) async {
    final result = await httpManager.post(
      url: setReaction,
      data: params,
      loading: false,
    );

    return ResultApiModel.fromJson(result);
  }

  ///Ping
  static Future requestConfirmReceiptStatus(statusType) async {
    await httpManager.post(
      url: "$confirmReceiptStatus/$statusType",
      loading: false,
    );
  }

  ///Send Read Status
  static Future<ResultApiModel> requestSendReadStatus(chatId) async {
    final result = await httpManager.post(
      url: "$sendReadStatus/$chatId",
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }
  // static Future<ResultApiModel> requestSendReadStatus(fromUserId) async {
  //   final result = await httpManager.post(
  //     url: "$sendReadStatus/$fromUserId",
  //     loading: false,
  //   );
  //   return ResultApiModel.fromJson(result);
  // }

  ///Send Delivered Status
  static Future<ResultApiModel> requestSendDeliveredStatus(chatId) async {
    final result = await httpManager.post(
      url: "$sendDeliveredStatus/$chatId",
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }
  // static Future<ResultApiModel> requestSendDeliveredStatus(fromUserId) async {
  //   final result = await httpManager.post(
  //     url: "$sendDeliveredStatus/$fromUserId",
  //     loading: false,
  //   );
  //   return ResultApiModel.fromJson(result);
  // }

  ///Send Delivered Status
  static Future<ResultApiModel> requestSendDeliveredStatusForUsers(
      List<int> chats) async {
    final result = await httpManager.post(
      url: sendDeliveredStatusUsers,
      data: chats,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }
  // static Future<ResultApiModel> requestSendDeliveredStatusForUsers(
  //     List<String> users) async {
  //   final result = await httpManager.post(
  //     url: sendDeliveredStatusUsers,
  //     data: users,
  //     loading: false,
  //   );
  //   return ResultApiModel.fromJson(result);
  // }

  ///Chat Unread Messages Count
  static Future<ResultApiModel> requestUnreadMessagesCount() async {
    final result = await httpManager.get(
      url: unreadMessagesCount,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Chat Users
  static Future<ResultApiModel> requestChatUsers({
    required String keyword,
    required int pageNumber,
    required int pageSize,
    bool loading = false,
  }) async {
    final result = await httpManager.get(
      url:
          "$chatUsers/${keyword.isNotEmpty ? keyword : "empty"}/$pageNumber/$pageSize",
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Blocked Users
  static Future<ResultApiModel> requestBlockedUsers({
    required String keyword,
    required int pageNumber,
    required int pageSize,
    bool loading = false,
  }) async {
    final result = await httpManager.get(
      url:
          "$blockedUsers/${keyword.isNotEmpty ? keyword : "empty"}/$pageNumber/$pageSize",
      loading: loading,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Blocked Users
  static Future<ResultApiModel> requestPolicyAndPrivacy() async {
    final result = await httpManager.get(
      url: policyAndPrivacy,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Blocked Users
  static Future<ResultApiModel> requestTermsAndConditions() async {
    final result = await httpManager.get(
      url: termsAndConditions,
      loading: false,
    );
    return ResultApiModel.fromJson(result);
  }

  ///Singleton factory
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();
}
