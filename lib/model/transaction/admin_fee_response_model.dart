import 'package:equatable/equatable.dart';

class AdminFeeResponseModel with EquatableMixin {
  bool isError;
  String message;
  int baseFee;
  int adminFee;

  AdminFeeResponseModel(
      {this.isError, this.message, this.baseFee, this.adminFee});

  factory AdminFeeResponseModel.fromJson(Map<String, dynamic> json) =>
      AdminFeeResponseModel(
        isError: false,
        message: json['message'],
        baseFee: int.parse(json['data']['harga_dasar']),
        adminFee: json['data']['admin_fee'],
      );

  AdminFeeResponseModel.errorJson(String value)
      : message = value,
        isError = true;

  @override
  List<Object> get props => [isError, message, baseFee];
}
