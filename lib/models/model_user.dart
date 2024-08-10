import '../configs/application.dart';
import '../configs/image.dart';
import 'model.dart';

enum UserType { owner, broker, office, company, admin, superAdmin, armaAdmin }

enum Gender { male, female }

class UserModel {
  late final String userId;
  late final num membershipNo;
  late String userName;
  // late String nickName;
  late String firstName;
  late Gender gender;
  late String lastName;
  late String countryCode;
  late String phoneNumber;
  late bool isAppearPhoneNumber;
  late String profilePictureDataUrl;
  late String url;
  late final int userLevel;
  late String description;
  late final String tag;
  late int? reports;
  late int views;
  late double ratingAvg;
  late double? totalOrders;
  late double? totalCustomerOrders;
  late final int totalComment;
  late int total;
  late final String token;
  // late final String refreshToken;
  late String email;
  late UserType userType;
  late bool phoneNumberConfirmed;
  late int addresses;
  late int shoppingCarts;
  late int customerOrders;
  late int orders;
  late bool isAuthentication;
  late String? administratorName;
  late String? authenticationNotes;
  late String? authenticationDocs;
  late bool isActive;
  late List<ExtendedAttributeModel>? extendedAttributes;
  late List<String>? roles;
  late List<String>? topics;

  UserModel({
    required this.userId,
    required this.membershipNo,
    required this.userName,
    // required this.nickName,
    required this.firstName,
    required this.lastName,
    this.gender = Gender.male,
    required this.countryCode,
    required this.phoneNumber,
    this.isAppearPhoneNumber = false,
    required this.profilePictureDataUrl,
    required this.url,
    required this.userLevel,
    required this.description,
    required this.tag,
    required this.views,
    this.reports,
    required this.ratingAvg,
    this.totalOrders,
    this.totalCustomerOrders,
    required this.totalComment,
    required this.total,
    required this.token,
    // required this.refreshToken,
    required this.email,
    required this.userType,
    required this.phoneNumberConfirmed,
    this.addresses = 0,
    this.shoppingCarts = 0,
    this.customerOrders = 0,
    this.orders = 0,
    this.isAuthentication = false,
    this.administratorName,
    this.authenticationNotes,
    this.authenticationDocs,
    this.isActive = false,
    this.extendedAttributes,
    this.roles,
    this.topics,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String>? roles = [];
    List<String>? topics = [];
    List<ExtendedAttributeModel>? extendedAttributes = [];
    var gender = Gender.male;
    if (json['gender'] != null) {
      gender = Gender.values[int.parse(json['gender'].toString())];
    }

    var userType = UserType.owner;
    if (json['userType'] != null) {
      userType = UserType.values[int.parse(json['userType'].toString())];
    }
    if (json['extendedAttributes'] != null) {
      extendedAttributes =
          List.from(json['extendedAttributes'] ?? []).map((item) {
        return ExtendedAttributeModel.fromJson(item);
      }).toList();
    }
    if (json['roles'] != null) {
      roles =
          List.from(json['roles'] ?? []).map((item) => item as String).toList();
    }
    if (json['topics'] != null && json['topics'] is List) {
      topics = List.from(json['topics'] ?? [])
          .map((item) => item as String)
          .toList();
    }
    if (json['topics'] != null && json['topics'] is String) {
      topics = List.from(json['topics'].split(',') ?? [])
          .map((item) => item as String)
          .toList();
    }
    return UserModel(
      userId: json['id'] ?? '',
      membershipNo: json['membershipNo'] ?? 0,
      userName: json['userName'] ?? '',
      // nickName: json['userName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: gender,
      countryCode: json['countryCode'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      isAppearPhoneNumber: json['isAppearPhoneNumber'] ?? false,
      profilePictureDataUrl: json['profilePictureDataUrl'] ?? '',
      url: json['url'] ?? '',
      userLevel: json['userLevel'] ?? 0,
      description: json['description'] ?? 'description',
      tag: json['tag'] ?? json['Tag'] ?? '',
      views: int.tryParse('${json['views']}') ?? 0,
      reports: int.tryParse('${json['reports']}'),
      ratingAvg: double.tryParse('${json['ratingAvg']}') ?? 0.0,
      totalOrders: double.tryParse('${json['totalOrders']}'),
      totalCustomerOrders: double.tryParse('${json['totalCustomerOrders']}'),
      totalComment: int.tryParse('${json['totalComment']}') ?? 0,
      total: json['total'] ?? 0,
      token: json['token'] ?? "",
      // refreshToken: json['refreshToken'] ?? "",
      email: json['email'] ?? '',
      userType: userType,
      phoneNumberConfirmed: json['phoneNumberConfirmed'] ?? false,
      addresses: json['addresses'] ?? 0,
      shoppingCarts: json['shoppingCarts'] ?? 0,
      customerOrders: json['customerOrders'] ?? 0,
      orders: json['orders'] ?? 0,
      isAuthentication: json['isAuthentication'] ?? false,
      administratorName: json['administratorName'],
      authenticationNotes: json['authenticationNotes'],
      authenticationDocs: json['authenticationDocs'],
      isActive: json['isActive'] ?? false,
      extendedAttributes: extendedAttributes,
      roles: roles,
      topics: topics,
    );
  }

  UserModel updateUser({
    // String? nickname,
    String? firstName,
    String? lastName,
    Gender? gender,
    String? countryCode,
    String? phoneNumber,
    bool? isAppearPhoneNumber,
    String? email,
    String? url,
    String? description,
    String? image,
    int? total,
    bool? phoneNumberConfirmed,
    int? views,
    int? reports,
    double? ratingAvg,
    double? totalOrders,
    double? totalCustomerOrders,
    int? addresses,
    int? shoppingCarts,
    int? customerOrders,
    int? orders,
    bool? isAuthentication,
    String? administratorName,
    String? authenticationDocs,
    String? authenticationNotes,
    bool? isActive,
    List<ExtendedAttributeModel>? extendedAttributes,
    List<String>? roles,
    List<String>? topics,
  }) {
    // this.nickName = userName ?? this.userName;
    this.firstName = firstName ?? this.firstName;
    this.lastName = lastName ?? this.lastName;
    this.gender = gender ?? this.gender;
    this.countryCode = countryCode ?? this.countryCode;
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.isAppearPhoneNumber = isAppearPhoneNumber ?? this.isAppearPhoneNumber;
    this.email = email ?? this.email;
    this.url = url ?? this.url;
    this.description = description ?? this.description;
    profilePictureDataUrl = image ?? profilePictureDataUrl;
    this.total = total ?? this.total;
    this.phoneNumberConfirmed =
        phoneNumberConfirmed ?? this.phoneNumberConfirmed;
    this.views = views ?? this.views;
    this.reports = reports ?? this.reports;
    this.ratingAvg = ratingAvg ?? this.ratingAvg;
    this.totalOrders = totalOrders ?? this.totalOrders;
    this.totalCustomerOrders = totalCustomerOrders ?? this.totalCustomerOrders;
    this.addresses = addresses ?? this.addresses;
    this.shoppingCarts = shoppingCarts ?? this.shoppingCarts;
    this.orders = orders ?? this.orders;
    this.customerOrders = customerOrders ?? this.customerOrders;
    this.isAuthentication = isAuthentication ?? this.isAuthentication;
    this.administratorName = this.administratorName;
    this.authenticationNotes = this.authenticationNotes;
    this.authenticationDocs = this.authenticationDocs;
    this.isActive = isActive ?? this.isActive;
    this.extendedAttributes = extendedAttributes ?? this.extendedAttributes;
    this.roles = roles ?? this.roles;
    this.topics = topics ?? this.topics;
    return clone();
  }

  UserModel.fromSource(source) {
    userId = source.userId;
    membershipNo = source.membershipNo;
    userName = source.userName;
    // nickName = source.nickName;
    firstName = source.firstName;
    lastName = source.lastName;
    gender = source.gender;
    countryCode = source.countryCode;
    phoneNumber = source.phoneNumber;
    isAppearPhoneNumber = source.isAppearPhoneNumber;
    profilePictureDataUrl = source.profilePictureDataUrl;
    url = source.url;
    userLevel = source.userLevel;
    description = source.description;
    tag = source.tag;
    views = source.views;
    reports = source.reports;
    ratingAvg = source.ratingAvg;
    totalOrders = source.totalOrders;
    totalCustomerOrders = source.totalCustomerOrders;
    totalComment = source.totalComment;
    total = source.total;
    token = source.token;
    email = source.email;
    phoneNumberConfirmed = source.phoneNumberConfirmed;
    addresses = source.addresses;
    shoppingCarts = source.shoppingCarts;
    customerOrders = source.customerOrders;
    orders = source.orders;
    isAuthentication = source.isAuthentication;
    administratorName = source.administratorName;
    administratorName = source.administratorName;
    authenticationNotes = source.authenticationNotes;
    authenticationDocs = source.authenticationDocs;
    isActive = source.isActive;
    extendedAttributes = source.extendedAttributes;
    roles = source.roles;
    topics = source.topics;
    // refreshToken = source.refreshToken;
  }

  UserModel clone() {
    return UserModel.fromSource(this);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'membershipNo': membershipNo,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.index,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'isAppearPhoneNumber': isAppearPhoneNumber,
      'image': profilePictureDataUrl,
      'url': url,
      'userLevel': userLevel,
      'description': description,
      'tag': tag,
      'views': views,
      'reports': reports,
      'ratingAvg': ratingAvg,
      'totalOrders': totalOrders,
      'totalCustomerOrders': totalCustomerOrders,
      'totalComment': totalComment,
      'total': total,
      'token': token,
      'email': email,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'addresses': addresses,
      'shoppingCarts': shoppingCarts,
      'customerOrders': customerOrders,
      'orders': orders,
      'isAuthentication': isAuthentication,
      'administratorName': administratorName,
      'administratorName': administratorName,
      'authenticationNotes': authenticationNotes,
      'authenticationDocs': authenticationDocs,
      'isActive': isActive,
      'extendedAttributes': extendedAttributes?.map((e) => e.toJson()).toList(),
      'roles': roles,
      'topics': topics,
      // 'refreshToken': refreshToken,
    };
  }

  String getProfileImage({String? imageType}) {
    if (profilePictureDataUrl.isNotEmpty) {
      return "${Application.domain}$profilePictureDataUrl"
          .replaceAll("\\", "/")
          .replaceAll("TYPE", imageType ?? "thumb");
    }
    return '';
  }
}
