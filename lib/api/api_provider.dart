import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:localin/api/api_constant.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  Dio _dio;
  SharedPreferences sharedPreferences;

  ApiProvider() {
    getOptionRequest();
    setupLoggingInterceptor();
  }

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
        errorDescription =
            "Received invalid status code: ${error.response.statusCode}";
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

  void setupLoggingInterceptor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) {
      if (options.headers.containsKey("requiredToken")) {
        String token = prefs.getString('kUserCache');
        var header = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };
        options.headers.addAll(header);
      }
    }));
  }

  Future<UserBaseModel> getUserData(var bodyRequest) async {
    try {
      var response = await _dio.post(ApiConstant.kLoginUrl,
          data: bodyRequest,
          options: Options(headers: {'requiredToken': false}));
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
}
