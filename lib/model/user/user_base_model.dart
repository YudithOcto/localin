import 'package:localin/model/user/user_model.dart';

class UserBaseModel {
  String error;
  UserModel userModel;

  UserBaseModel({this.error, this.userModel});

  UserBaseModel.fromJson(Map<String, dynamic> body)
      : userModel = UserModel.fromJson(body['data']),
        error = '';

  UserBaseModel.withError(String value)
      : userModel = UserModel(),
        error = value;
}
