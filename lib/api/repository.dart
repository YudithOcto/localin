import 'package:localin/api/api_provider.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/model/user/user_request.dart';

class Repository {
  ApiProvider apiProvider = ApiProvider();

  Future<UserBaseModel> getUserLogin(UserRequest userRequest) async {
    return apiProvider.getUserData(userRequest.toJson());
  }
}
