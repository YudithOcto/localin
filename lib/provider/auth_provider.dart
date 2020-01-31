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
    if (signInFacebookResult != null && signInFacebookResult.length > 1) {
      signInToApiResult =
          await getUserFromApi(UserRequest.fromJson(signInFacebookResult));
      errorMessage = signInToApiResult.error;
      userModel = signInToApiResult.userModel;
    } else {
      errorMessage = signInFacebookResult['error'];
    }
    setState(ViewState.Idle);
    return userModel;
  }

  Future<UserModel> signInWithGoogle() async {
    setState(ViewState.Busy);
    UserBaseModel signInToApiResult;
    var signInGoogleResult = await SocialSignIn().signInWithGoogle();
    if (signInGoogleResult != null && signInGoogleResult.length > 1) {
      signInToApiResult =
          await getUserFromApi(UserRequest.fromJson(signInGoogleResult));
      errorMessage = signInToApiResult.error;
      userModel = signInToApiResult.userModel;
    } else {
      errorMessage = signInGoogleResult['error'];
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
        notifyListeners();
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

  Future<void> clearUserCache() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.clear();
  }

  void setUserModel(UserModel model) {
    this.userModel = model;
    notifyListeners();
  }

  void updateUserModelAndCache(String phone) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    if (userModel != null) {
      userModel.handphone = phone;
      sf.remove(kUserCache);
      sf.setString(kUserCache, jsonEncode(userModel.toJson()));
    }
    notifyListeners();
  }

  Future<String> signOutFacebook() async {
    await SocialSignIn().facebookLogout();
    var result = await _repository.userLogout();
    return result;
  }

  Future<String> signOutGoogle() async {
    await SocialSignIn().signOutGoogle();
    var result = await _repository.userLogout();
    return result;
  }
}
