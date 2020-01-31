import 'package:localin/model/user/user_model.dart';

class UserBaseModel {
  String error;
  String message;
  UserModel userModel;
  bool isError;

  UserBaseModel({this.error, this.userModel, this.isError, this.message});

  UserBaseModel.fromJson(Map<String, dynamic> body)
      : userModel = UserModel.fromJson(body['data']),
        error = '';

  UserBaseModel.withError(String value)
      : userModel = UserModel(),
        error = value;

  UserBaseModel.verificationPhoneFromJson(Map<String, dynamic> body)
      : message = body['message'],
        isError = body['error'];

  UserBaseModel.requestSmsCodeFromJson(Map<String, dynamic> body)
      : message = body['text'],
        error = null;
}
