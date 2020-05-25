import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:localin/api/api_constant.dart';
import 'package:localin/build_environment.dart';
import 'package:localin/main.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/model/article/article_tag_response.dart';
import 'package:localin/model/article/base_response.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_base_response_category.dart';
import 'package:localin/model/community/community_join_response.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/model/dana/dana_activate_base_response.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/hotel/booking_cancel_response.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/model/hotel/booking_history_base_response.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/room_base_response.dart';
import 'package:localin/model/location/search_location_response.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/model/user/update_profile_model.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/model/user/user_verification_category_model.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
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
        baseUrl: buildEnvironment.baseUrl,
        receiveTimeout: 20000,
        maxRedirects: 3,
        connectTimeout: 20000);
    _dio = Dio(options);
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<String> getFlutterTimezone() async {
    try {
      return await FlutterNativeTimezone.getLocalTimezone();
    } catch (error) {
      return DateTime.now().timeZoneName;
    }
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
        errorDescription = error.response.data != null &&
                !error.response.data.toString().contains('html')
            ? convertResponseErrorMessage(error.response.data)
            : 'Request failed with status code ${error.response.statusCode}';
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
    String message = body['message'];
    return message ?? 'There\'s an error on our side. Please try again later';
  }

  void setupLoggingInterceptor() async {
    _dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: false,
        responseBody: true));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          if (options.headers.containsKey("requiredToken")) {
            String token = await getToken();
            debugPrint('Token $token');
            options.headers.clear();
            var header = {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            };
            options.headers.addAll(header);
          }
        },
        onError: (DioError e) async {
          sharedPreferences = await SharedPreferences.getInstance();
          if (e.response.statusCode == 401) {
            sharedPreferences.clear();
            if (navigator != null && navigator.currentState != null) {
              navigator.currentState.pushNamedAndRemoveUntil(
                  LoginPage.routeName, (Route<dynamic> route) => false);
            }
          }
        },
      ),
    );
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final model = UserModel.fromJson(jsonDecode(prefs.getString(kUserCache)));
    return model.apiToken;
  }

  /// API RELATED

  Future<UserBaseModel> getUserData(var bodyRequest) async {
    try {
      final response =
          await _dio.post(ApiConstant.kLoginUrl, data: bodyRequest);
      final baseModel = UserBaseModel.fromJson(response.data);
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

  Future<UserVerificationCategoryModel> getUserVerificationCategory() async {
    try {
      final response = await _dio.get(ApiConstant.kUserVerificationCategory,
          options: Options(headers: {'requiredToken': true}));
      return UserVerificationCategoryModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return UserVerificationCategoryModel.withError(_handleError(error));
      } else {
        return UserVerificationCategoryModel(error: error);
      }
    }
  }

  Future<String> userLogout() async {
    try {
      final response = await _dio.get(ApiConstant.kLogoutUrl,
          options: Options(headers: {'requiredToken': true}));
      sharedPreferences.clear();
      return response.toString();
    } catch (error) {
      if (error is DioError) {
        String logout = error?.response?.data['message'];
        if (logout.contains('Success logout')) {
          sharedPreferences.clear();
          return logout;
        }
        return _handleError(error);
      } else {
        return error.toString();
      }
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final response = await _dio.get(ApiConstant.kProfile,
          options: Options(headers: {'requiredToken': true}));
      final model = UserModel.fromJson(response.data['data']);
      return model;
    } catch (error) {
      if (error is DioError) {
        return UserModel.withError(_handleError(error));
      } else {
        return UserModel.withError(error);
      }
    }
  }

  Future<UserModel> getOtherUserProfile(String userProfileId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kOtherUserProfile}/$userProfileId',
          options: Options(headers: {'requiredToken': true}));
      return UserModel.fromJson(response.data['data']);
    } catch (error) {
      if (error is DioError) {
        return UserModel.withError(_handleError(error));
      } else {
        return UserModel.withError(error);
      }
    }
  }

  Future<String> updateUserProfile(FormData formData) async {
    try {
      final response = await _dio.post('${ApiConstant.kUpdateProfile}',
          data: formData, options: Options(headers: {'requiredToken': true}));
      return response.data['message'];
    } catch (error) {
      return error.toString();
    }
  }

  Future<UpdateProfileModel> verifyUserAccount(FormData form) async {
    try {
      final response = await _dio.post(ApiConstant.kVerifyAccount,
          data: form, options: Options(headers: {'requiredToken': true}));
      final model = UpdateProfileModel.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        if (error.response.statusMessage != null &&
            error.response.statusMessage.contains('Large')) {
          return UpdateProfileModel.errorJson(error.response.statusMessage);
        }
        return UpdateProfileModel.errorJson(_handleError(error));
      } else {
        return UpdateProfileModel.errorJson(error);
      }
    }
  }

  Future<UserBaseModel> userPhoneRequestCode(String phone) async {
    try {
      final response = await _dio.post(ApiConstant.kVerifyPhoneNumberRequest,
          options: Options(headers: {'requiredToken': true}),
          data: FormData.fromMap({'handphone': phone}));
      return UserBaseModel.requestSmsCodeFromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return UserBaseModel.withError(_handleError(error));
      } else {
        return UserBaseModel(error: error);
      }
    }
  }

  Future<UserBaseModel> verifyPhoneCodeVerification(int smsCode) async {
    try {
      final response = await _dio.post(
          ApiConstant.kVerifyPhoneNumberInputCodeVerification,
          options: Options(headers: {'requiredToken': true}),
          data: FormData.fromMap({'kode': smsCode}));
      return UserBaseModel.verificationPhoneFromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return UserBaseModel.withError(_handleError(error));
      } else {
        return UserBaseModel(error: error);
      }
    }
  }

  /// Article

  Future<ArticleBaseResponse> getUserArticle(
      int isDraft, int isTrash, int offset) async {
    try {
      Map<String, dynamic> map = Map();
      map['page'] = offset;
      map['limit'] = 10;
      if (isDraft != null) {
        map['is_draft'] = isDraft;
      } else if (isTrash != null) {
        map['is_trash'] = isTrash;
      }
      final response = await _dio.get(ApiConstant.kUserArticle,
          options: Options(headers: {'requiredToken': true}),
          queryParameters: map);
      final model = ArticleBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error);
      }
    }
  }

  Future<ArticleBaseResponse> getOtherUserArticle(
      int offset, int limit, String userId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kOtherUserArticle}/$userId',
          queryParameters: {'limit': limit, 'page': offset},
          options: Options(headers: {'requiredToken': true}));
      final model = ArticleBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleBaseResponse> getRelatedArticle(String articleId) async {
    try {
      final response = await _dio.get(ApiConstant.kArticleList,
          queryParameters: {'is_releated': articleId},
          options: Options(headers: {'requiredToken': true}));
      return ArticleBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleBaseResponse> getArticleList(int offset, int limit, int isLiked,
      int isBookmark, String keyword) async {
    Map<String, dynamic> _articleRequest = {'limit': limit, 'page': offset};
    if (isLiked != null) {
      _articleRequest['is_like'] = isLiked;
    } else if (isBookmark != null) {
      _articleRequest['is_bookmark'] = isBookmark;
    } else if (keyword != null && keyword.isNotEmpty) {
      _articleRequest['search'] = keyword;
    }
    try {
      final response = await _dio.get(ApiConstant.kArticleList,
          queryParameters: _articleRequest,
          options: Options(headers: {'requiredToken': true}));
      final model = ArticleBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleBaseResponse> getArticleDetail(String articleId) async {
    try {
      final response = await _dio.get('${ApiConstant.kArticleList}/$articleId',
          options: Options(headers: {'requiredToken': true}));
      final model = ArticleBaseResponse.withJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleBaseResponse> unArchiveArticle(String slug) async {
    try {
      final response = await _dio.get('${ApiConstant.kArticleUnArchive}/$slug',
          options: Options(headers: {'requiredToken': true}));
      final model = ArticleBaseResponse.withJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleBaseResponse> createArticle(FormData form) async {
    try {
      final response = await _dio.post(ApiConstant.kCreateArticle,
          options: Options(headers: {'requiredToken': true}), data: form);
      print(jsonEncode(response.data));
      final model = ArticleBaseResponse.withJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        if (error.response.statusCode == 500) {
          return ArticleBaseResponse.withError(
              'Server unknown error. Please try again later');
        } else if (error.response.statusCode == 413) {
          return ArticleBaseResponse.withError('Image request too large');
        } else if (error.response.data['judul'] != null) {
          return ArticleBaseResponse.withError(error.response.data['judul'][0]);
        } else if (error.response.data['deskripsi'] != null) {
          return ArticleBaseResponse.withError(
              error.response.data['deskripsi'][0]);
        } else if (error.response.data['address'] != null) {
          return ArticleBaseResponse.withError(
              error.response.data['address'][0]);
        } else if (error.response.data['tag'] != null) {
          return ArticleBaseResponse.withError(error.response.data['tag'][0]);
        } else {
          for (int i = 0; i < form.files.length; i++) {
            if (error.response.data['gambar.$i'][0] != null) {
              return ArticleBaseResponse.withError(
                  error.response.data['gambar.$i'][0]);
            }
          }
          return ArticleBaseResponse.withError(error.response.data.toString());
        }
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<SearchLocationResponse> searchLocation(
      int offset, int limit, String search) async {
    try {
      final response = await _dio.get(ApiConstant.kSearchLocation,
          queryParameters: {
            'page': offset,
            'limit': limit,
            'search': '$search',
          },
          options: Options(headers: {'requiredToken': true}));
      return SearchLocationResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return SearchLocationResponse.withError(_handleError(error));
      } else {
        return SearchLocationResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleTagResponse> getArticleTags(
      String keyword, int offset, int limit) async {
    try {
      Map<String, dynamic> query = Map();
      query['page'] = offset;
      query['limit'] = limit;
      print(keyword);
      if (keyword != null && keyword.isNotEmpty) {
        query['keyword'] = keyword;
      }
      final response = await _dio.get(ApiConstant.kArticleTags,
          queryParameters: query,
          options: Options(headers: {'requiredToken': true}));
      final model = ArticleTagResponse.fromJson(response.data);
      return model;
    } catch (error) {
      return ArticleTagResponse.withError(error.toString());
    }
  }

  Future<ArticleBaseResponse> getArticleByTag(
      int offset, int limit, String tagId) async {
    Map<String, dynamic> _articleRequest = {'limit': limit, 'page': offset};
    try {
      final response = await _dio.get('${ApiConstant.kArticleByTag}/$tagId',
          queryParameters: _articleRequest,
          options: Options(headers: {'requiredToken': true}));
      final model = ArticleBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleCommentBaseResponse> getArticleComment(
      String articleId, int offset, int limit) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kArticleComment}/$articleId',
          queryParameters: {'limit': limit, 'page': offset},
          options: Options(headers: {'requiredToken': true}));
      return ArticleCommentBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ArticleCommentBaseResponse.withError(_handleError(error));
      } else {
        return ArticleCommentBaseResponse.withError(error.toString());
      }
    }
  }

  Future<BaseResponse> deleteArticle(String articleId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kArticleDelete}/$articleId',
          options: Options(headers: {'requiredToken': true}));
      return BaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return BaseResponse.withError(_handleError(error));
      } else {
        return BaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleCommentBaseResponse> publishArticleComment(
      String articleId, String message) async {
    FormData _formData = FormData.fromMap({'komentar': message});
    try {
      final response = await _dio.post(
          '${ApiConstant.kArticleComment}/$articleId',
          data: _formData,
          options: Options(headers: {'requiredToken': true}));
      return ArticleCommentBaseResponse.publishResponse(response.data);
    } catch (error) {
      if (error is DioError) {
        return ArticleCommentBaseResponse.withError(_handleError(error));
      } else {
        return ArticleCommentBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleCommentBaseResponse> replyOtherUserComment(
      String commentId, String message) async {
    FormData _formData = FormData.fromMap({'komentar': message});
    try {
      final response = await _dio.post(
          '${ApiConstant.kArticleReplyComment}/$commentId',
          data: _formData,
          options: Options(headers: {'requiredToken': true}));
      return ArticleCommentBaseResponse.publishResponse(response.data);
    } catch (error) {
      if (error is DioError) {
        final errorList = error.response.data;
        return ArticleCommentBaseResponse.withError(errorList['komentar'][0]);
      } else {
        return ArticleCommentBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleBaseResponse> likeArticle(String articleId) async {
    try {
      final response = await _dio.get('${ApiConstant.kArticleLike}/$articleId',
          options: Options(headers: {'requiredToken': true}));
      return ArticleBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleBaseResponse> bookmarkArticle(String articleId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kArticleBookmark}/$articleId',
          options: Options(headers: {'requiredToken': true}));
      return ArticleBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  /// COMMUNITY

  Future<CommunityDetailBaseResponse> getCommunityList(
      String search, int page, int limit) async {
    try {
      final response = await _dio.get(ApiConstant.kCommunity,
          queryParameters: {'search': '$search', 'limit': limit, 'page': page},
          options: Options(headers: {'requiredToken': true}));
      final model = CommunityDetailBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error);
      }
    }
  }

  Future<CommunityDetailBaseResponse> getCommunityDetail(
      String communityId) async {
    try {
      final response = await _dio.get('${ApiConstant.kCommunity}/$communityId',
          options: Options(headers: {'requiredToken': true}));
      final model =
          CommunityDetailBaseResponse.mapJsonCommunityDetail(response.data);
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
      final response = await _dio.get(ApiConstant.kUserCommunity,
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

  Future<CommunityDetailBaseResponse> getOtherUserCommunityList(
      String id) async {
    try {
      final response = await _dio.get('${ApiConstant.kUserCommunity}/$id',
          options: Options(headers: {'requiredToken': true}));
      final model = CommunityDetailBaseResponse.fromJson(response.data);
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
      final response = await _dio.get(ApiConstant.kSearchCategory,
          queryParameters: {'keyword': search},
          options: Options(headers: {'requiredToken': true}));
      var model = CommunityBaseResponseCategory.fromJson(response.data);
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
      final response = await _dio.post(ApiConstant.kCreateCommunity,
          data: form, options: Options(headers: {'requiredToken': true}));
      return CommunityDetailBaseResponse.uploadSuccess(
          response.data['message']);
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error.toString());
      }
    }
  }

  Future<CommunityDetailBaseResponse> editCommunity(
      FormData form, String communityID) async {
    try {
      final response = await _dio.post(
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
      final response = await _dio.get(
          '${ApiConstant.kJoinCommunity}$communityId',
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

  Future<CommunityMemberResponse> getMemberCommunity(String communityId) async {
    try {
      final response = await _dio.get(
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

  Future<CommunityMemberResponse> approveMemberCommunity(
      String communityId, String memberId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kMemberCommunity}$communityId/$memberId/approve',
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
      final response = await _dio.get(
          '${ApiConstant.kSearchCategory}/$categoryId',
          options: Options(headers: {'requiredToken': true}));
      return CommunityDetailBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error.toString());
      }
    }
  }

  Future<CommunityCommentBaseResponse> postComment(
      FormData data, String communityId) async {
    try {
      final response = await _dio.post(
          '${ApiConstant.kCommentCommunity}$communityId',
          data: data,
          options: Options(headers: {'requiredToken': true}));
      return CommunityCommentBaseResponse.addComment(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityCommentBaseResponse.withError(_handleError(error));
      } else {
        return CommunityCommentBaseResponse.withError(error.toString());
      }
    }
  }

  Future<CommunityCommentBaseResponse> getCommentList(
      String communityId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kCommentCommunity}$communityId',
          options: Options(headers: {'requiredToken': true}));
      return CommunityCommentBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityCommentBaseResponse.withError(_handleError(error));
      } else {
        return CommunityCommentBaseResponse.withError(error.toString());
      }
    }
  }

  Future<void> createEventCommunity(
      String communityId, FormData formData) async {
    try {
      final response = await _dio.post(
          '${ApiConstant.kCreateEventCommunity}/$communityId',
          data: formData,
          options: Options(headers: {'requiredToken': true}));
      return response;
    } catch (error) {
      print(error);
      return error;
    }
  }

  /// Hotel
  Future<HotelListBaseResponse> getHotelList(
      String latitude,
      String longitude,
      String search,
      int page,
      int limit,
      DateTime checkInDate,
      DateTime checkOutDate,
      int total) async {
    try {
      final response = await _dio.get(ApiConstant.kHotel,
          queryParameters: {
            'latitude': latitude,
            'longitude': longitude,
            'keyword': search,
            'page': page,
            'limit': limit,
            'checkin': DateHelper.formatDateRangeForOYO(checkInDate),
            'checkout': DateHelper.formatDateRangeForOYO(checkOutDate),
            'room': total,
          },
          options: Options(headers: {'requiredToken': true}));
      return HotelListBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return HotelListBaseResponse.withError(_handleError(error));
      } else {
        return HotelListBaseResponse.withError(error.toString());
      }
    }
  }

  Future<HotelListBaseResponse> getHotelDetail(int hotelId,
      DateTime checkInDate, DateTime checkOutDate, int roomTotal) async {
    try {
      final result = await _dio.get(
        '${ApiConstant.kHotelDetail}/$hotelId',
        queryParameters: {
          'checkin': DateHelper.formatDateRangeForOYO(checkInDate),
          'checkout': DateHelper.formatDateRangeForOYO(checkOutDate),
          'timezone': await getFlutterTimezone(),
          'room': roomTotal,
        },
        options: Options(headers: {'requiredToken': true}),
      );
      return HotelListBaseResponse.withJson(result.data);
    } catch (error) {
      if (error is DioError) {
        return HotelListBaseResponse.withError(_handleError(error));
      } else {
        return HotelListBaseResponse.withError(error.toString());
      }
    }
  }

  Future<RoomBaseResponse> getRoomAvailabilityDetail(
      int hotelId, DateTime checkIn, DateTime checkOut, int room) async {
    try {
      final result =
          await _dio.get('${ApiConstant.kHotelRoomAvailability}/$hotelId',
              queryParameters: {
                'checkin': DateHelper.formatDateRangeForOYO(checkIn),
                'checkout': DateHelper.formatDateRangeForOYO(checkOut),
                'timezone': await getFlutterTimezone(),
                'room': room,
              },
              options: Options(headers: {'requiredToken': true}));
      return RoomBaseResponse.fromJson(result.data);
    } catch (error) {
      if (error is DioError) {
        return RoomBaseResponse.withError(_handleError(error));
      } else {
        return RoomBaseResponse.withError(error.toString());
      }
    }
  }

  Future<BookingHistoryBaseResponse> getBookingHistoryList(
      int offset, int limit) async {
    try {
      final result = await _dio.get('${ApiConstant.kHotelHistory}',
          queryParameters: {'page': offset, 'limit': limit},
          options: Options(headers: {'requiredToken': true}));
      return BookingHistoryBaseResponse.fromJson(result.data);
    } catch (error) {
      if (error is DioError) {
        return BookingHistoryBaseResponse.withError();
      } else {
        return BookingHistoryBaseResponse.withError();
      }
    }
  }

  Future<BookingDetailResponse> getHotelBookingDetail(String bookingId) async {
    try {
      final response = await _dio.get('${ApiConstant.kHotelBooking}/$bookingId',
          options: Options(headers: {'requiredToken': true}));
      return BookingDetailResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return BookingDetailResponse.withError(_handleError(error));
      } else {
        return BookingDetailResponse.withError(error.toString());
      }
    }
  }

  Future<BookHotelResponse> bookHotel(
      int hotelId,
      int roomCategoryId,
      int totalAdult,
      int totalRoom,
      DateTime checkIn,
      DateTime checkOut,
      String roomName) async {
    FormData _formData = FormData.fromMap({
      'hotel_id': hotelId,
      'room_category': roomCategoryId,
      'count_room': totalRoom,
      'count_adult': totalAdult,
//      'checkin': incheck,
//      'checkout': outcheck,
      'checkin': DateHelper.formatDateRangeForOYO(checkIn),
      'checkout': DateHelper.formatDateRangeForOYO(checkOut),
      'timezone': await getFlutterTimezone(),
      'room_name': roomName,
    });
    try {
      final result = await _dio.post('${ApiConstant.kHotelBooking}',
          data: _formData, options: Options(headers: {'requiredToken': true}));
      return BookHotelResponse.fromJson(result.data);
    } catch (error) {
      if (error is DioError) {
        return BookHotelResponse.withError(_handleError(error));
      } else {
        return BookHotelResponse.withError(error.toString());
      }
    }
  }

  Future<BookingCancelResponse> cancelBooking(String bookingId) async {
    try {
      final result = await _dio.get(
          '${ApiConstant.kHotelBooking}/$bookingId/cancel',
          options: Options(headers: {'requiredToken': true}));
      return BookingCancelResponse.fromJson(result.data);
    } catch (error) {
      if (error is DioError) {
        return BookingCancelResponse.withError(_handleError(error));
      } else {
        return BookingCancelResponse.withError(error.toString());
      }
    }
  }

  /// DANA
  Future<DanaUserAccountResponse> getUserDanaStatus() async {
    try {
      final result = await _dio.get(ApiConstant.kDanaMe,
          options: Options(headers: {'requiredToken': true}));
      print(result);
      return DanaUserAccountResponse.fromJson(result.data);
    } catch (error) {
      return DanaUserAccountResponse.withError();
    }
  }

  Future<DanaActivateBaseResponse> activateDanaAccount(String phone) async {
    try {
      final response = await _dio.get(ApiConstant.kDanaPhoneActivate,
          options: Options(
              extra: {'handphone': phone}, headers: {'requiredToken': true}));
      return DanaActivateBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return DanaActivateBaseResponse.withError(_handleError(error));
      } else {
        return DanaActivateBaseResponse.withError(error.toString());
      }
    }
  }

  Future<BookingPaymentResponse> bookingPayment(String bookingId) async {
    try {
      final response = await _dio.get('${ApiConstant.kDanaPayment}/$bookingId',
          options: Options(headers: {'requiredToken': true}));
      return BookingPaymentResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return BookingPaymentResponse.withError(_handleError(error));
      } else {
        return BookingPaymentResponse.withError(error.toString());
      }
    }
  }

  Future<NotificationModelResponse> getNotificationList(
      int offset, int limit) async {
    try {
      final response = await _dio.get(ApiConstant.kNotificationList,
          queryParameters: {'page': offset, 'limit': limit},
          options: Options(headers: {'requiredToken': true}));
      return NotificationModelResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return NotificationModelResponse.withError(_handleError(error));
      } else {
        return NotificationModelResponse.withError(error.toString());
      }
    }
  }

  Future<bool> readNotificationUpdate(String notificationId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kNotificationList}/$notificationId',
          options: Options(headers: {'requiredToken': true}));
      return response.data['status'];
    } catch (error) {
      return false;
    }
  }

  Future<String> deleteAllNotification() async {
    try {
      final response = await _dio.get(ApiConstant.kNotificationDeleteAll,
          options: Options(headers: {'requiredToken': true}));
      return response.data['message'];
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> deleteNotificationById(String id) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kNotificationDeleteById}/$id',
          options: Options(headers: {'requiredToken': true}));
      return response.data['message'];
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> unDeleteNotificationById(String id) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kNotificationUnDeleteById}/$id',
          options: Options(headers: {'requiredToken': true}));
      return response.data['message'];
    } catch (error) {
      return error.toString();
    }
  }

  Future<UserBaseModel> updateUserLocation(
      String latitude, String longitude, String address) async {
    try {
      final response = await _dio.post(ApiConstant.kUpdateUserLocation,
          queryParameters: {
            'lat': latitude,
            'long': longitude,
            'address': address,
          },
          options: Options(headers: {'requiredToken': true}));
      final result = UserBaseModel.fromJson(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(kUserCache, jsonEncode(result.userModel.toJson()));
      return result;
    } catch (error) {
      if (error is DioError) {
        return UserBaseModel.withError(_handleError(error));
      } else {
        return UserBaseModel.withError(error.toString());
      }
    }
  }
}
