import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:localin/api/api_constant.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/model/article/article_tag_response.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_base_response_category.dart';
import 'package:localin/model/community/community_join_response.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/model/dana/dana_activate_base_response.dart';
import 'package:localin/model/dana/dana_user_account_response.dart';
import 'package:localin/model/hotel/book_hotel_response.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/model/hotel/booking_history_base_response.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/room_base_response.dart';
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
        receiveTimeout: 15000,
        maxRedirects: 3,
        connectTimeout: 15000);
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
    String message = body['message'];
    String comment = body['komentar'] != null && body['komentar'][0] != null
        ? body['komentar'][0]
        : null;
    return comment != null ? comment : message;
  }

  void setupLoggingInterceptor() async {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      print('send request：path:${options.uri}');
      if (options.headers.containsKey("requiredToken")) {
        String token = await getToken();
        print(token);
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
      final model = UserModel.fromJson(response.data);
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
      final response = await _dio.get(ApiConstant.kVerifyAccount,
          options: Options(headers: {'requiredToken': true}));
      final model = UpdateProfileModel.fromJson(response.data);
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
      final response = await _dio.get(ApiConstant.kUserArticle,
          options: Options(headers: {'requiredToken': true}));
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

  Future<ArticleBaseResponse> getArticleList(int offset, int limit) async {
    try {
      final response = await _dio.get(ApiConstant.kArticleList,
          queryParameters: {'limit': limit, 'page': offset},
          options: Options(headers: {'requiredToken': true}));
      var model = ArticleBaseResponse.fromJson(response.data);
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
          options: Options(
            headers: {'requiredToken': true},
          ),
          data: form);
      var model = ArticleBaseResponse.fromJson(response.data);
      return model;
    } catch (error) {
      if (error is DioError) {
        return ArticleBaseResponse.withError(_handleError(error));
      } else {
        return ArticleBaseResponse.withError(error.toString());
      }
    }
  }

  Future<ArticleTagResponse> getArticleTags(String keyword) async {
    try {
      final response = await _dio.get(ApiConstant.kArticleTags,
          queryParameters: {'keyword': keyword},
          options: Options(headers: {'requiredToken': true}));
      List result = response.data;
      var model = ArticleTagResponse.fromJson(result[0]);
      return model;
    } catch (error) {
      return ArticleTagResponse.withError(error.toString());
    }
  }

  Future<ArticleCommentBaseResponse> getArticleComment(String articleId) async {
    try {
      final response = await _dio.get(
          '${ApiConstant.kArticleComment}/$articleId',
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

  /// COMMUNITY

  Future<CommunityDetailBaseResponse> getCommunityList(String search) async {
    try {
      final response = await _dio.get(ApiConstant.kCommunity,
          queryParameters: {'search': '$search'},
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
      String latitude, String longitude, String search) async {
    try {
      final response = await _dio.get(ApiConstant.kHotel,
          queryParameters: {
            'latitude': latitude,
            'longitude': longitude,
            'keyword': search,
            'page': 0,
            'limit': 6,
          },
          options: Options(headers: {'requiredToken': false}));
      return HotelListBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return HotelListBaseResponse.withError(_handleError(error));
      } else {
        return HotelListBaseResponse.withError(error.toString());
      }
    }
  }

  Future<HotelListBaseResponse> getHotelDetail(
      int hotelId, DateTime checkInDate, DateTime checkOutDate) async {
    try {
      final result = await _dio.get(
        '${ApiConstant.kHotelDetail}/$hotelId',
        queryParameters: {
          'checkin': checkInDate.millisecondsSinceEpoch,
          'checkout': checkOutDate.millisecondsSinceEpoch,
          'room': 1,
        },
        options: Options(headers: {'requiredToken': false}),
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
      int hotelId, int checkIn, int checkOut, int room) async {
    try {
      final result =
          await _dio.get('${ApiConstant.kHotelRoomAvailability}/$hotelId',
              queryParameters: {
                'checkin': checkIn
                    .toString()
                    .substring(0, checkIn.toString().length - 3),
                'checkout': checkOut
                    .toString()
                    .substring(0, checkOut.toString().length - 3),
                'room': room,
              },
              options: Options(headers: {'requiredToken': false}));
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

  Future<BookHotelResponse> bookHotel(int hotelId, int roomCategoryId,
      int totalAdult, int totalRoom, int checkIn, int checkOut) async {
    FormData _formData = FormData.fromMap({
      'hotel_id': hotelId,
      'room_category': roomCategoryId,
      'count_room': totalRoom,
      'count_adult': totalAdult,
      'checkin': checkIn.toString().substring(0, checkIn.toString().length - 3),
      'checkout':
          checkOut.toString().substring(0, checkOut.toString().length - 3),
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

  Future<DanaActivateBaseResponse> activateDanaAccount(FormData body) async {
    try {
      final response = await _dio.post(ApiConstant.kDanaPhoneActivate,
          data: body, options: Options(headers: {'requiredToken': true}));
      return DanaActivateBaseResponse.fromJson(response.data);
    } catch (error) {
      if (error is DioError) {
        return DanaActivateBaseResponse.withError(_handleError(error));
      } else {
        return DanaActivateBaseResponse.withError(error.toString());
      }
    }
  }
}
