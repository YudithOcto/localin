import 'package:equatable/equatable.dart';

class AdminFeeResponseModel with EquatableMixin {
  bool isError;
  String message;
  int adminFare;

  AdminFeeResponseModel({this.isError, this.message, this.adminFare});

  factory AdminFeeResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminFeeResponseModel(
        isError: false,
        message: json['message'],
        adminFare: json['data']['admin_fee'],
      );

  AdminFeeResponseModel.errorJson(String value)
      : message = value,
        isError = true;

  @override
  List<Object> get props => [isError, message, adminFare];
}
