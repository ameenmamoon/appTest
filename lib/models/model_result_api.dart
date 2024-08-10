import 'package:supermarket/models/model.dart';

class ResultApiModel {
  final bool succeeded;
  final bool isDisplay;
  final dynamic data;
  final dynamic attr;
  final String? controller;
  final String? action;
  final PaginationModel? pagination;
  final UserModel? user;
  final String message;

  ResultApiModel({
    required this.succeeded,
    required this.isDisplay,
    this.data,
    this.attr,
    this.controller,
    this.action,
    this.pagination,
    this.user,
    required this.message,
  });

  factory ResultApiModel.fromJson(Map<String, dynamic> json) {
    UserModel? user;
    PaginationModel? pagination;
    String msg = '';
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);
    }
    if ((json['currentPage'] ?? json['CurrentPage']) != null) {
      pagination = PaginationModel.fromJson(json);
    }
    if (json['messages'] != null &&
        json['messages'] != '' &&
        (json['messages'] as List).isNotEmpty) {
      msg = json['messages'][0];
    }
    if (json['Messages'] != null &&
        json['Messages'] != '' &&
        (json['Messages'] as List).isNotEmpty) {
      msg = json['Messages'][0];
    }
    return ResultApiModel(
      succeeded: json['succeeded'] ?? json['Succeeded'] ?? false,
      isDisplay: json['isDisplay'] ?? json['IsDisplay'] ?? false,
      data: json['data'] ?? json['Data'],
      pagination: pagination,
      attr: json['attr'] ?? json['Attr'],
      controller: json['controller'] ?? json['Controller'],
      action: json['action'] ?? json['Action'],
      user: user,
      message: msg,
    );
  }
}
