import 'package:dio/dio.dart';
import 'package:localin/api/api_provider.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/community/community_base_response_category.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
import 'package:localin/model/community/community_join_response.dart';
import 'package:localin/model/community/community_member_response.dart';
import 'package:localin/model/user/update_profile_model.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/model/user/user_request.dart';

class Repository {
  ApiProvider apiProvider = ApiProvider();

  Future<UserBaseModel> getUserLogin(UserRequest userRequest) async {
    return apiProvider.getUserData(userRequest.toJson());
  }

  Future<String> userLogout() async {
    return apiProvider.userLogout();
  }

  Future<UserModel> getUserProfile() async {
    return apiProvider.getUserProfile();
  }

  Future<UpdateProfileModel> verifyUserAccount() async {
    return apiProvider.verifyUserAccount();
  }

  Future<ArticleBaseResponse> getUserArticle() async {
    return apiProvider.getUserArticle();
  }

  Future<ArticleBaseResponse> getArticleList() async {
    return apiProvider.getArticleList();
  }

  Future<CommunityDetailBaseResponse> getCommunityList(String keyword) async {
    return apiProvider.getCommunityList(keyword);
  }

  Future<CommunityDetailBaseResponse> createCommunity(FormData data) async {
    return apiProvider.createCommunity(data);
  }

  Future<CommunityDetailBaseResponse> editCommunity(
      FormData data, String communityId) async {
    return apiProvider.editCommunity(data, communityId);
  }

  Future<CommunityBaseResponseCategory> getCategoryListCommunity(
      String search) async {
    return apiProvider.getCategoryListCommunity(search);
  }

  Future<CommunityJoinResponse> joinCommunity(String id) async {
    return apiProvider.joinCommunity(id);
  }

  Future<CommunityMemberResponse> getCommunityMember(String communityId) async {
    return apiProvider.getMemberCommunity(communityId);
  }

  Future<CommunityDetailBaseResponse> getCommunityListByCategory(
      String categoryId) async {
    return apiProvider.getCommunityListByCategoryId(categoryId);
  }

  Future<CommunityDetailBaseResponse> getUserCommunityList() async {
    return apiProvider.getUserCommunityList();
  }

  Future<void> createCommunityEvent(String communityId, FormData formData) async {
    return apiProvider.createEventCommunity(communityId, formData);
  }
}
