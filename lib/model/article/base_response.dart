import 'package:equatable/equatable.dart';

class BaseResponse extends Equatable {
  bool error;
  String message;

  BaseResponse({this.error, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> map) {
    return BaseResponse(
      error: map['error'],
      message: map['message'],
    );
  }

  BaseResponse.withError(String value)
      : error = true,
        message = value;

  @override
  List<Object> get props => [error, message];
}
