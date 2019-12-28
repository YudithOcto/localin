import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:localin/api/api_constant.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_base_response_category.dart';
import 'package:localin/model/community/community_join_response.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/model/user/update_profile_model.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  Dio _dio;
  SharedPreferences sharedPreferences;

  ApiProvider() {
    getOptionRequest();
    setupLoggingInterceptor();
  }

  /// BASE REQUEST RELATED

  getOptionRequest() async {
    BaseOptions options = BaseOptions(
        baseUrl: ApiConstant.kBaseUrl,
        receiveTimeout: 5000,
        connectTimeout: 5000);
    _dio = Dio(options);
    sharedPreferences = await SharedPreferences.getInstance();
  }

  String _handleError(DioError error) {
    String errorDescription = "";
    switch (error.type) {
      case DioErrorType.CANCEL:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        errorDescription = "Connection timeout with API server";
        break;
      case DioErrorType.DEFAULT:
        errorDescription =
            "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioErrorType.RESPONSE:
        errorDescription = error.response.data != null
            ? convertResponseErrorMessage(error.response.data)
            : 'Request failed with status cide ${error.response.statusCode}';
        break;
      case DioErrorType.SEND_TIMEOUT:
        errorDescription = "Request to API Timeout";
        break;
      default:
        errorDescription = "Unexpected Error";
        break;
    }
    return errorDescription;
  }

  String convertResponseErrorMessage(Map<String, dynamic> body) {
    return body['message'];
  }

  void setupLoggingInterceptor() async {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options) async {
      if (options.headers.containsKey("requiredToken")) {
        String token = await getToken();
        options.headers.clear();
        var header = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };
        options.headers.addAll(header);
      }
    }));
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var model = UserModel.fromJson(jsonDecode(prefs.getString(kUserCache)));
    return model.apiToken;
  }

  /// API RELATED

  Future<UserBaseModel> getUserData(var bodyRequest) async {
    try {
      var response = await _dio.post(ApiConstant.kLoginUrl, data: bodyRequest);
      var baseModel = UserBaseModel.fromJson(response.data);
      sharedPreferences.setString(
          kUserCache, jsonEncode(baseModel.userModel.toJson()));
      return baseModel;
    } catch (error) {
      if (error is DioError) {
        return UserBaseModel.withError(_handleError(error));
      } else {
        return UserBaseModel(error: error);
      }
    }
  }

  Future<String> userLogout() async {
    try {
      var response = await _dio.get(ApiConstant.kLogoutUrl,
          options: Options(headers: {'requiredToken': true}));
      sharedPreferences.clear();
      return response.toString();
    } catch (error) {
      if (error is DioError) {
        String logout = convertResponseErrorMessage(error.response.data);
        if (logout.contains('Success logout')) {
          sharedPreferences.clear();
        }
        return _handleError(error);
      } else {
        return error.toString();
      }
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      var response = await _dio.get(ApiConstant.kProfile,
          options: Options(headers: {'requiredToken': true}));
      var model = UserModel.fromJson(response.data);
      sharedPreferences.setString(kUserCache, jsonEncode(model.toJson()));
      return model;
    } catch (error) {
      if (error is DioError) {
        return UserModel.withError(_handleError(error));
      } else {
        return UserModel.withError(error);
      }
    }
  }

  Future<UpdateProfileModel> verifyUserAccount() async {
    try {
      var response = await _dio.get(ApiConstant.kVerifyAccount,
          options: Options(headers: {'requiredToken': true}));
      var model = UpdateProfileModel.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return UpdateProfileModel.errorJson(_handleError(error));
      } else {
        return UpdateProfileModel.errorJson(error);
      }
    }
  }

  Future<ArticleBaseResponse> getUserArticle() async {
    try {
      var response = await _dio.get(ApiConstant.kUserArticle,
          options: Options(headers: {'requiredToken': true}));
      var model = ArticleBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error);
      }
    }
  }

  Future<ArticleBaseResponse> getArticleList() async {
    try {
      var response = await _dio.get(ApiConstant.kArticleList,
          options: Options(headers: {'requiredToken': true}));
      var model = ArticleBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error);
      }
    }
  }

  /// COMMUNITY

  Future<CommunityDetailBaseResponse> getCommunityList(String search) async {
    try {
      var response = await _dio.get(ApiConstant.kCommunity,
          queryParameters: {'search': '$search'},
          options: Options(headers: {'requiredToken': true}));
      var model = CommunityDetailBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error);
      }
    }
  }

  Future<CommunityDetailBaseResponse> getUserCommunityList() async {
    try {
      var response = await _dio.get(ApiConstant.kUserCommunity,
          options: Options(headers: {'requiredToken': true}));
      var model = CommunityDetailBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error);
      }
    }
  }

  Future<CommunityBaseResponseCategory> getCategoryListCommunity(
      String search) async {
    try {
      var response = await _dio.get(ApiConstant.kSearchCategory,
          queryParameters: {'keyword': search},
          options: Options(headers: {'requiredToken': true}));
      var data = response.data;
      var model = CommunityBaseResponseCategory.fromJson(data[0]);
      return model;
    } catch (error) {
      if (error is DioError) {
        return CommunityBaseResponseCategory.withError(_handleError(error));
      } else {
        return CommunityBaseResponseCategory.withError(error.toString());
      }
    }
  }

  Future<CommunityDetailBaseResponse> createCommunity(FormData form) async {
    try {
      var response = await _dio.post(ApiConstant.kCreateCommunity,
          data: form, options: Options(headers: {'requiredToken': true}));
      return CommunityDetailBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error);
      }
    }
  }

  Future<CommunityDetailBaseResponse> editCommunity(
      FormData form, String communityID) async {
    try {
      var response = await _dio.post(
          '${ApiConstant.kEditCommunity}$communityID',
          data: form,
          options: Options(headers: {'requiredToken': true}));
      return CommunityDetailBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error);
      }
    }
  }

  Future<CommunityJoinResponse> joinCommunity(String communityId) async {
    try {
      var response = await _dio.get('${ApiConstant.kJoinCommunity}$communityId',
          options: Options(headers: {'requiredToken': true}));
      return CommunityJoinResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityJoinResponse.withError(_handleError(error));
      } else {
        return CommunityJoinResponse.withError(error);
      }
    }
  }

  Future<CommunityMemberResponse> memberCommunity(String communityId) async {
    try {
      var response = await _dio.get(
          '${ApiConstant.kMemberCommunity}$communityId',
          options: Options(headers: {'requiredToken': true}));
      return CommunityMemberResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityMemberResponse.withError(_handleError(error));
      } else {
        return CommunityMemberResponse.withError(error);
      }
    }
  }

  Future<CommunityDetailBaseResponse> getCommunityListByCategoryId(
      String categoryId) async {
    try {
      var response = await _dio.get(
          '${ApiConstant.kSearchCategory}/$categoryId',
          options: Options(headers: {'requiredToken': true}));
      return CommunityDetailBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error);
      }
    }
  }

  Future<String> postComment(FormData data, String communityId) async {
    try {
      var response = await _dio.post(
          '${ApiConstant.kCommentCommunity}$communityId',
          data: data,
          options: Options(headers: {'requiredToken': true}));
      return response.toString();
    } catch (error) {
      print(error);
      return error;
    }
  }
}
