import 'dart:convert';
import 'package:localin/api/repository.dart';
import 'package:localin/api/social_sign_in.dart';
import 'package:localin/model/dana/dana_activate_base_response.dart';
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

  /// DO CALL LOCALIN LOGIN API
  Future<UserBaseModel> getUserFromApi(
      UserRequest userRequest, String token) async {
    userRequest.fcmToken = token;
    final result = await _repository.getUserLogin(userRequest);
    return result;
  }

  /// DO CALL FACEBOOK API
  Future<UserModel> signInWithFacebook() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setBool(kUserVerify, false);
    UserBaseModel signInToApiResult;
    final signInFacebookResult = await SocialSignIn().signInFacebook();
    if (signInFacebookResult != null && signInFacebookResult.length > 1) {
      signInToApiResult = await getUserFromApi(
          UserRequest.fromJson(signInFacebookResult),
          sf.getString('tokenFirebase'));
      errorMessage = signInToApiResult.error;
      userModel = signInToApiResult.userModel;
      updateUserModelAndCache(userModel?.handphone);
    } else {
      errorMessage = signInFacebookResult['error'];
    }
    return userModel;
  }

  ///DO CALL GOOGLE API
  Future<UserModel> signInWithGoogle() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setBool(kUserVerify, false);
    UserBaseModel signInToApiResult;
    var signInGoogleResult = await SocialSignIn().signInWithGoogle();
    if (signInGoogleResult != null && signInGoogleResult.length > 1) {
      signInToApiResult = await getUserFromApi(
          UserRequest.fromJson(signInGoogleResult),
          sf.getString('tokenFirebase'));
      errorMessage = signInToApiResult.error;
      userModel = signInToApiResult.userModel;
      updateUserModelAndCache(userModel?.handphone);
    } else {
      errorMessage = signInGoogleResult['error'];
    }
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

  void updateUserIdentityVerification(UserModel model) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    if (userModel != null && userModel.status != model.status) {
      userModel.status = model.status;
      userModel.identityNo = model.identityNo;
      userModel.imageIdentity = model.imageIdentity;
      sf.setString(kUserCache, jsonEncode(userModel.toJson()));
      notifyListeners();
    }
  }

  void updateUserModelVerifyStatus(String phone) async {
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

  Future<DanaActivateBaseResponse> authenticateUserDanaAccount(
      String phone) async {
    final result = await _repository.activateDana(phone);
    return result;
  }
}
