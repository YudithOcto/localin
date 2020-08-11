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
import 'package:localin/model/community/community_event_member_response.dart';
import 'package:localin/model/community/community_event_response_model.dart';
import 'package:localin/model/community/community_join_response.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/model/community/community_my_group_response.dart';
import 'package:localin/model/community/community_price_model.dart';
import 'package:localin/model/dana/dana_activate_base_response.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:localin/model/explore/explore_available_event_dates_model.dart';
import 'package:localin/model/explore/explore_event_detail_model.dart';
import 'package:localin/model/explore/explore_event_response_model.dart';
import 'package:localin/model/explore/explore_filter_response_model.dart';
import 'package:localin/model/explore/explore_response_model.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/hotel/booking_cancel_response.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/model/hotel/booking_history_base_response.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/room_base_response.dart';
import 'package:localin/model/location/search_location_response.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/model/restaurant/restaurant_response_model.dart';
import 'package:localin/model/transaction/transaction_explore_detail_response.dart';
import 'package:localin/model/transaction/transaction_response_model.dart';
import 'package:localin/model/user/update_profile_model.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/model/user/user_verification_category_model.dart';
import 'package:localin/presentation/explore/utils/filter.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/utils/constants.dart';
import 'package:localin/utils/date_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String REQUIRED_TOKEN = 'required_token';

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
        baseUrl: buildEnvironment.baseApiUrl,
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
          if (options.headers.containsKey(REQUIRED_TOKEN)) {
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          data: formData, options: Options(headers: {REQUIRED_TOKEN: true}));
      return response.data['message'];
    } catch (error) {
      return error.toString();
    }
  }

  Future<UpdateProfileModel> verifyUserAccount(FormData form) async {
    try {
      final response = await _dio.post(ApiConstant.kVerifyAccount,
          data: form, options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}),
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
          options: Options(headers: {REQUIRED_TOKEN: true}),
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
          options: Options(headers: {REQUIRED_TOKEN: true}),
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}), data: form);
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
            return ArticleBaseResponse.withError(
                error.response.data['gambar'][i]);
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
      if (keyword != null && keyword.isNotEmpty) {
        query['keyword'] = keyword;
      }
      final response = await _dio.get(ApiConstant.kArticleTags,
          queryParameters: query,
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
      Map<String, dynamic> map = Map();
      if (search != null && search.isNotEmpty) {
        map['search'] = search;
      }
      map['page'] = page ?? 1;
      map['limit'] = limit ?? 10;
      final response = await _dio.get(ApiConstant.kCommunity,
          queryParameters: map,
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
      String id, int page) async {
    try {
      final response = await _dio.get('${ApiConstant.kOtherUserCommunity}/$id',
          options: Options(
              headers: {REQUIRED_TOKEN: true, 'limit': 10, 'page': page}));
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
      String search, int pageRequest, int byLocation) async {
    try {
      Map<String, dynamic> map = Map();
      if (search != null) {
        map['keyword'] = search;
      }
      map['byLocation'] = byLocation ?? 0;
      map['limit'] = 10;
      map['page'] = pageRequest;
      final response = await _dio.get(ApiConstant.kSearchCategory,
          queryParameters: map,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      final model = CommunityBaseResponseCategory.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return CommunityBaseResponseCategory.withError(_handleError(error));
      } else {
        return CommunityBaseResponseCategory.withError(error.toString());
      }
    }
  }

  Future<CommunityDetailBaseResponse> getPopularCommunity(
      {int offset, int limit, String categoryId}) async {
    try {
      final response = await _dio.get(ApiConstant.kPopularCommunity,
          queryParameters: {
            'limit': limit,
            'page': offset,
            'kategori_id': categoryId,
          },
          options: Options(headers: {REQUIRED_TOKEN: true}));
      final model = CommunityDetailBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return CommunityDetailBaseResponse.hasError(_handleError(error));
      } else {
        return CommunityDetailBaseResponse.hasError(error.toString());
      }
    }
  }

  Future<CommunityDetailBaseResponse> createCommunity(FormData form) async {
    try {
      final response = await _dio.post(ApiConstant.kCreateCommunity,
          data: form, options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityDetailBaseResponse.mapJsonCommunityDetail(response.data);
    } catch (error) {
      if (error is DioError) {
        if (error.response.statusCode == 500) {
          return CommunityDetailBaseResponse.hasError(
              'Server unknown error. Please try again later');
        } else if (error.response.statusCode == 422) {
          return CommunityDetailBaseResponse.hasError(
              error.response.data['logo'][0]);
        } else {
          return CommunityDetailBaseResponse.hasError(_handleError(error));
        }
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityDetailBaseResponse.mapJsonCommunityDetail(response.data);
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityJoinResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityJoinResponse.withError(_handleError(error));
      } else {
        return CommunityJoinResponse.withError(error);
      }
    }
  }

  Future<CommunityDetailBaseResponse> leaveCommunity(String communityId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kLeaveCommunity}/$communityId',
          options: Options(headers: {REQUIRED_TOKEN: true}));
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

  Future<CommunityCommentBaseResponse> createPostCommunity(
      FormData form, String communityId) async {
    try {
      final response = await _dio.post(
          '${ApiConstant.kCreatePostCommunity}/$communityId',
          options: Options(headers: {REQUIRED_TOKEN: true}),
          data: form);
      return CommunityCommentBaseResponse.addComment(response.data);
    } catch (error) {
      if (error is DioError) {
        if (error.response.statusCode == 500) {
          return CommunityCommentBaseResponse.withError(
              'Server unknown error. Please try again later');
        } else if (error.response.statusCode > 400 ||
            error.response.statusCode < 499) {
          return CommunityCommentBaseResponse.withError('Image request failed');
        } else if (error.response.data['tag'] != null) {
          return CommunityCommentBaseResponse.withError(
              error.response.data['tag'][0]);
        } else {
          return CommunityCommentBaseResponse.withError(error.toString());
        }
      } else {
        return CommunityCommentBaseResponse.withError(
            error.response.data.toString());
      }
    }
  }

  Future<CommunityMemberResponse> getMemberCommunity(
      String communityId, page, limit, String type,
      {String search, String sort}) async {
    try {
      Map<String, dynamic> map = Map();
      map['page'] = page;
      map['limit'] = limit;
      if (search != null && search.isNotEmpty) {
        map['search'] = search;
      }
      if (sort != null) {
        map['sort'] = sort;
      }
      final response = await _dio.get(
          '${ApiConstant.kMemberCommunity}$communityId/$type',
          queryParameters: map,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityMemberResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        if (error.response.statusCode == 500) {
          return CommunityMemberResponse.withError('Server Failure');
        }
        return CommunityMemberResponse.withError(_handleError(error));
      } else {
        return CommunityMemberResponse.withError(error);
      }
    }
  }

  Future<CommunityMyGroupResponse> getLatestPost(int offset, int limit) async {
    try {
      final response = await _dio.get(ApiConstant.kLatestPostCommunity,
          queryParameters: {'limit': limit, 'page': offset},
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityMyGroupResponse.withJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityMyGroupResponse.withError(_handleError(error));
      } else {
        return CommunityMyGroupResponse.withError(error);
      }
    }
  }

  /// status == approve || decline. this api to bulk insert/delete
  Future<CommunityMemberResponse> moderateAllCommunityMember(
      String communityId, String status) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kModerateMemberCommunity}/$communityId/$status',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityMemberResponse.moderateResponse(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityMemberResponse.withError(_handleError(error));
      } else {
        return CommunityMemberResponse.withError(error);
      }
    }
  }

  Future<CommunityMemberResponse> moderateSingleCommunityMember(
      String communityId, String memberId, String status) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kMemberCommunity}$communityId/$memberId/$status',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityMemberResponse.moderateResponse(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityMemberResponse.withError(_handleError(error));
      } else {
        return CommunityMemberResponse.withError(error.toString());
      }
    }
  }

  Future<CommunityDetailBaseResponse> getCommunityListByCategoryId(
      String categoryId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kSearchCategory}/$categoryId',
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityCommentBaseResponse.addComment(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityCommentBaseResponse.withError(_handleError(error));
      } else {
        return CommunityCommentBaseResponse.withError(error.toString());
      }
    }
  }

  Future<CommunityPriceModel> getPaidCommunityPrice() async {
    try {
      final response = await _dio.get(ApiConstant.kCommunityPrice,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityPriceModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityPriceModel.withError(_handleError(error));
      } else {
        return CommunityPriceModel.withError(error.toString());
      }
    }
  }

  Future<CommunityCommentBaseResponse> getCommentList(
      String communityId, int page, int limit,
      {String parentId}) async {
    try {
      Map<String, dynamic> map = Map();
      map['limit'] = limit;
      map['page'] = page;
      if (parentId != null && parentId.isNotEmpty) {
        map['parent'] = parentId;
      }
      final response = await _dio.get(
          '${ApiConstant.kCommentCommunity}$communityId',
          queryParameters: map,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityCommentBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityCommentBaseResponse.withError(_handleError(error));
      } else {
        return CommunityCommentBaseResponse.withError(error.toString());
      }
    }
  }

  Future<CommunityEventMemberResponse> getEventMemberByType(
      String type, String eventId, int page, int limit) async {
    //e: hadir / waiting / tentative
    try {
      //attendees/hadir
      final response = await _dio.get(
          '${ApiConstant.kEventCommunity}$eventId/attendees/$type',
          options: Options(headers: {REQUIRED_TOKEN: true}),
          queryParameters: {
            'page': page,
            'limit': limit,
          });
      return CommunityEventMemberResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityEventMemberResponse.withError(_handleError(error));
      } else {
        return CommunityEventMemberResponse.withError(error.toString());
      }
    }
  }

  Future<CommunityEventResponseModel> adminUpdateEventStatus(
      String status, String eventId) async {
    // status = hapus dan batal
    try {
      final response = await _dio.get(
          '${ApiConstant.kEventCommunity}$eventId/$status',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityEventResponseModel.fromMap(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityEventResponseModel.withError(_handleError(error));
      } else {
        return CommunityEventResponseModel.withError(error.toString());
      }
    }
  }

  Future<CommunityEventResponseModel> updateJoinEvent(
      String eventId, String status) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kJoinEvent}/$eventId/$status',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityEventResponseModel.fromMap(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityEventResponseModel.withError(_handleError(error));
      } else {
        return CommunityEventResponseModel.withError(error.toString());
      }
    }
  }

  Future<CommunityEventResponseModel> getEventDetail(String eventId) async {
    try {
      final response = await _dio.get('${ApiConstant.kEventCommunity}/$eventId',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityEventResponseModel.fromMap(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityEventResponseModel.withError(_handleError(error));
      } else {
        return CommunityEventResponseModel.withError(error.toString());
      }
    }
  }

  Future<CommunityEventResponseModel> createEventCommunity(
      String communityId, FormData formData) async {
    try {
      final response = await _dio.post(
          '${ApiConstant.kEventCommunity}/$communityId',
          data: formData,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityEventResponseModel.fromMap(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityEventResponseModel.withError(_handleError(error));
      } else {
        return CommunityEventResponseModel.withError(error.toString());
      }
    }
  }

  Future<String> communityLikeUnlike(String type, postId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kCommunity}/konten-$type/$postId',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return response.data['message'] ?? '';
    } catch (error) {
      return error.toString();
    }
  }

  Future<CommunityEventResponseModel> getUpComingList(
      String communityId, int page, int limit) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kUpcomingCommunityEvent}$communityId',
          queryParameters: {'page': page, 'limit': limit},
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityEventResponseModel.fromMapList(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityEventResponseModel.withError(_handleError(error));
      } else {
        return CommunityEventResponseModel.withError(error.toString());
      }
    }
  }

  Future<CommunityEventResponseModel> getPastCommunityEvent(
      String communityId, int page, int limit) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kPastCommunityEvent}$communityId',
          queryParameters: {'page': page, 'limit': limit},
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return CommunityEventResponseModel.fromMapList(response.data);
    } catch (error) {
      if (error is DioError) {
        return CommunityEventResponseModel.withError(_handleError(error));
      } else {
        return CommunityEventResponseModel.withError(error.toString());
      }
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
        options: Options(headers: {REQUIRED_TOKEN: true}),
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
              options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          data: _formData, options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return BookingCancelResponse.fromJson(result.data);
    } catch (error) {
      if (error is DioError) {
        return BookingCancelResponse.withError(_handleError(error));
      } else {
        return BookingCancelResponse.withError(error.toString());
      }
    }
  }

  Future<String> cancelTransaction(String transactionId) async {
    try {
      final result = await _dio.get(
          '${ApiConstant.kTransactionCancel}/$transactionId',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return result.data['message'];
    } catch (error) {
      if (error is DioError) {
        return _handleError(error);
      } else {
        return error.toString();
      }
    }
  }

  /// DANA
  Future<DanaUserAccountResponse> getUserDanaStatus() async {
    try {
      final result = await _dio.get(ApiConstant.kDanaMe,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return DanaUserAccountResponse.fromJson(result.data);
    } catch (error) {
      return DanaUserAccountResponse.withError();
    }
  }

  Future<DanaActivateBaseResponse> activateDanaAccount(String phone) async {
    try {
      final response = await _dio.get(ApiConstant.kDanaPhoneActivate,
          options: Options(
              extra: {'handphone': phone}, headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return response.data['status'];
    } catch (error) {
      return false;
    }
  }

  Future<String> deleteAllNotification() async {
    try {
      final response = await _dio.get(ApiConstant.kNotificationDeleteAll,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return response.data['message'];
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> deleteNotificationById(String id) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kNotificationDeleteById}/$id',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return response.data['message'];
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> unDeleteNotificationById(String id) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kNotificationUnDeleteById}/$id',
          options: Options(headers: {REQUIRED_TOKEN: true}));
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
          options: Options(headers: {REQUIRED_TOKEN: true}));
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

  Future<TransactionCommunityResponseModel> getCommunityTransactionList(
      int page, int limit, String transactionType) async {
    try {
      final response = await _dio.get(ApiConstant.kTransaction,
          queryParameters: {
            'limit': limit,
            'page': page,
            'type': transactionType
          },
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return TransactionCommunityResponseModel.getListJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return TransactionCommunityResponseModel.withError(_handleError(error));
      } else {
        return TransactionCommunityResponseModel.withError(error.toString());
      }
    }
  }

  getTransactionResponseModel(String type) {
    var model;
    switch (type) {
      case kTransactionTypeCommunity:
        model = TransactionCommunityResponseModel;
        break;
      case kTransactionTypeExplore:
        model = TransactionExploreDetailResponse;
        break;
    }
    return model;
  }

  Future<dynamic> getTransactionDetail(String transId, String type) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kTransactionDetail}/$transId',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      switch (type) {
        case kTransactionTypeCommunity:
          return TransactionCommunityResponseModel.fromJson(response.data);
          break;
        case kTransactionTypeExplore:
          return TransactionExploreDetailResponse.fromJson(response.data);
          break;
      }
    } catch (error) {
      switch (type) {
        case kTransactionTypeCommunity:
          if (error is DioError) {
            return TransactionCommunityResponseModel.withError(
                _handleError(error));
          } else {
            return TransactionCommunityResponseModel.withError(
                error.toString());
          }
          break;
        case kTransactionTypeExplore:
          if (error is DioError) {
            return TransactionExploreDetailResponse.withError(
                _handleError(error));
          } else {
            return TransactionExploreDetailResponse.withError(error.toString());
          }
          break;
      }
    }
  }

  Future<BookingPaymentResponse> payTransaction(String transId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kTransactionPayment}/$transId',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return BookingPaymentResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return BookingPaymentResponse.withError(_handleError(error));
      } else {
        return BookingPaymentResponse.withError(error.toString());
      }
    }
  }

  Future<ExploreEventResponseModel> getEventData(int pageRequest, String search,
      String sort, List<int> categoryId, String date) async {
    try {
      Map<String, dynamic> map = Map();
      map['page'] = pageRequest;
      map['limit'] = 10;
      if (search != null && search.isNotEmpty) {
        map['search'] = search;
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        map['kategori_id'] = categoryId.map((e) => e).toList();
      }
      if (sort != null && sort.isNotEmpty) {
        map['sort[]'] = getSorting(sort);
      }
      if (date != null && date.isNotEmpty) {
        map['date'] = date;
      }
      final response = await _dio.get(ApiConstant.kExploreEvent,
          options: Options(headers: {REQUIRED_TOKEN: true}),
          queryParameters: map);
      return ExploreEventResponseModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ExploreEventResponseModel.withError(_handleError(error));
      } else {
        return ExploreEventResponseModel.withError(error.toString());
      }
    }
  }

  Future<ExploreFilterResponseModel> getCategoryFilterEvent() async {
    try {
      final response = await _dio.get(ApiConstant.kCategoryFilterEvent,
          options: Options(headers: {REQUIRED_TOKEN: true}),
          queryParameters: {'limit': 20, 'page': 1});
      return ExploreFilterResponseModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ExploreFilterResponseModel.withError(_handleError(error));
      } else {
        return ExploreFilterResponseModel.withError(error.toString());
      }
    }
  }

  Future<ExploreEventDetailModel> getExploreEventDetail(int eventID) async {
    try {
      final response = await _dio.get('${ApiConstant.kExploreEvent}/$eventID',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return ExploreEventDetailModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ExploreEventDetailModel.withError(_handleError(error));
      } else {
        return ExploreEventDetailModel.withError(error.toString());
      }
    }
  }

  Future<ExploreAvailableEventDatesModel> getExploreAvailableDates(
      int eventID, int pageRequest) async {
    try {
      final response =
          await _dio.get('${ApiConstant.kExploreEventAvailableDate}/$eventID',
              queryParameters: ({
                'limit': 10,
                'page': pageRequest,
              }),
              options: Options(headers: {REQUIRED_TOKEN: true}));
      return ExploreAvailableEventDatesModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ExploreAvailableEventDatesModel.withError(_handleError(error));
      } else {
        return ExploreAvailableEventDatesModel.withError(error.toString());
      }
    }
  }

  Future<ExploreOrderResponseModel> orderTicket(
      String ticketRequestJson) async {
    try {
      final response = await _dio.post(ApiConstant.kExploreOrder,
          data: ticketRequestJson,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return ExploreOrderResponseModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return ExploreOrderResponseModel.withError(_handleError(error));
      } else {
        return ExploreOrderResponseModel.withError(error.toString());
      }
    }
  }

  /// RESTAURANT

  Future<RestaurantResponseModel> getRestaurantList(int page, String search,
      {int limit = 10, String sort, String order, int isLocation}) async {
    try {
      Map<String, dynamic> map = Map();
      if (sort != null && sort.isNotEmpty) {
        map['sort'] = sort;
      }
      if (search != null && search.isNotEmpty) {
        map['search'] = search;
      }
      map['limit'] = limit;
      map['page'] = page;
      if (order != null) {
        map['order'] = order;
      }
      if (isLocation != null) {
        map['is_location'] = isLocation;
      }
      final response = await _dio.get(ApiConstant.kSearchRestaurant,
          queryParameters: map,
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return RestaurantResponseModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return RestaurantResponseModel.withError(_handleError(error));
      } else {
        return RestaurantResponseModel.withError(error.toString());
      }
    }
  }

  Future<RestaurantResponseModel> getRestaurantDetail(
      String restaurantId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kSearchRestaurant}/$restaurantId',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return RestaurantResponseModel.fromSingleJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return RestaurantResponseModel.withError(_handleError(error));
      } else {
        return RestaurantResponseModel.withError(error.toString());
      }
    }
  }

  Future<RestaurantResponseModel> getBookmarkedRestaurants(int page) async {
    try {
      final response = await _dio.get(ApiConstant.kBookmarkedRestaurant,
          queryParameters: {'limit': 10, 'page': page},
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return RestaurantResponseModel.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return RestaurantResponseModel.withError(_handleError(error));
      } else {
        return RestaurantResponseModel.withError(error.toString());
      }
    }
  }

  Future<String> bookmarkRestaurant(int restaurantId,
      {bool isDelete = false}) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kBookmarkedRestaurant}/$restaurantId${isDelete ? '/delete' : ''}',
          options: Options(headers: {REQUIRED_TOKEN: true}));
      return response.data['message'];
    } catch (error) {
      if (error is DioError) {
        return _handleError(error);
      } else {
        return error.toString();
      }
    }
  }
}
