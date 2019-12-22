import 'dart:convert';
import 'package:localin/api/repository.dart';
import 'package:localin/api/social_sign_in.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/model/user/user_request.dart';
import 'package:localin/provider/base_model_provider.dart';
import 'package:localin/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends BaseModelProvider {
  final Repository _repository = Repository();
  UserModel userModel = UserModel();
  String errorMessage;

  Future<UserBaseModel> getUserFromApi(UserRequest userRequest) async {
    var result = await _repository.getUserLogin(userRequest);
    return result;
  }

  Future<UserModel> signInWithFacebook() async {
    setState(ViewState.Busy);
    UserBaseModel signInToApiResult;
    var signInFacebookResult = await SocialSignIn().signInFacebook();
    if (signInFacebookResult != null) {
      signInToApiResult =
          await getUserFromApi(UserRequest.fromJson(signInFacebookResult));
      errorMessage = signInToApiResult.error;
      userModel = signInToApiResult.userModel;
    }
    setState(ViewState.Idle);
    return userModel;
  }

  Future<UserModel> signInWithGoogle() async {
    setState(ViewState.Busy);
    UserBaseModel signInToApiResult;
    var signInGoogleResult = await SocialSignIn().signInWithGoogle();
    if (signInGoogleResult != null) {
      signInToApiResult =
          await getUserFromApi(UserRequest.fromJson(signInGoogleResult));
      errorMessage = signInToApiResult.error;
      userModel = signInToApiResult.userModel;
    }
    setState(ViewState.Idle);
    return userModel;
  }

  Future<UserModel> getUserFromCache() async {
    UserModel model;
    SharedPreferences sf = await SharedPreferences.getInstance();
    String facebookExpiredCache = sf.getString(kFacebookExpired);
    if (sf.getString(kUserCache) != null) {
      model = UserModel.fromJson(jsonDecode(sf.getString(kUserCache)));
      if (model != null) {
        userModel = model;
      }
    }
    if (facebookExpiredCache != null) {
      DateTime date = DateTime.parse(facebookExpiredCache);
      DateTime now = DateTime.now();
      if (date.isBefore(now)) {
        // if expired date before now then it is expired. otherwise we still can use the token
        return null;
      }
    }
    return model;
  }
}
