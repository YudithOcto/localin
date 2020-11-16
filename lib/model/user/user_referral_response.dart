import 'package:localin/model/explore/explore_base_model.dart';

class UserReferralResponse extends BaseModel {
  @override
  bool error;

  @override
  String message;

  UserReferralResponse({this.error, this.message});

  factory UserReferralResponse.fromJson(Map<String, dynamic> json) =>
      UserReferralResponse(
        error: json['error'],
        message: json['message'],
      );

  factory UserReferralResponse.errorJson(String value) => UserReferralResponse(
        error: true,
        message: value,
      );
}
