import 'package:dio/dio.dart';
import 'package:localin/api/api_provider.dart';
import 'package:localin/model/article/article_base_response.dart';
import 'package:localin/model/article/article_comment_base_response.dart';
import 'package:localin/model/article/article_tag_response.dart';
import 'package:localin/model/community/community_base_response_category.dart';
import 'package:localin/model/community/community_comment_base_response.dart';
import 'package:localin/model/community/community_detail_base_response.dart';
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

  Future<ArticleBaseResponse> getArticleList(int offset, int page) async {
    return apiProvider.getArticleList(page, offset);
  }

  Future<ArticleBaseResponse> createArticle(FormData form) async {
    return apiProvider.createArticle(form);
  }

  Future<ArticleTagResponse> getArticleTags(String keyword) async {
    return apiProvider.getArticleTags(keyword);
  }

  Future<ArticleCommentBaseResponse> getArticleComment(String articleId) {
    return apiProvider.getArticleComment(articleId);
  }

  Future<ArticleCommentBaseResponse> publishArticleComment(
      String articleId, String message) {
    return apiProvider.publishArticleComment(articleId, message);
  }

  /// COMMUNITY

  Future<CommunityDetailBaseResponse> getCommunityList(String keyword) async {
    return apiProvider.getCommunityList(keyword);
  }

  Future<CommunityDetailBaseResponse> getCommunityDetail(
      String communityId) async {
    return apiProvider.getCommunityDetail(communityId);
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

  Future<CommunityMemberResponse> approveMember(
      String communityId, String memberId) async {
    return apiProvider.approveMemberCommunity(communityId, memberId);
  }

  Future<CommunityDetailBaseResponse> getCommunityListByCategory(
      String categoryId) async {
    return apiProvider.getCommunityListByCategoryId(categoryId);
  }

  Future<CommunityDetailBaseResponse> getUserCommunityList() async {
    return apiProvider.getUserCommunityList();
  }

  Future<CommunityCommentBaseResponse> getCommunityCommentList(
      String communityId) async {
    return apiProvider.getCommentList(communityId);
  }

  Future<void> createCommunityEvent(
      String communityId, FormData formData) async {
    return apiProvider.createEventCommunity(communityId, formData);
  }

  Future<CommunityCommentBaseResponse> postComment(
      String communityId, FormData formData) {
    return apiProvider.postComment(formData, communityId);
  }

  ///Hotel
  Future<HotelListBaseResponse> getHotelList(
      String latitude, String longitude, String keyword, int page, int limit) {
    return apiProvider.getHotelList(latitude, longitude, keyword, page, limit);
  }

  Future<HotelListBaseResponse> getHotelDetail(
      int hotelId, DateTime checkInDate, DateTime checkOutDate) {
    return apiProvider.getHotelDetail(hotelId, checkInDate, checkOutDate);
  }

  Future<RoomBaseResponse> getRoomAvailability(
      int hotelID, int checkIn, int checkOut, int roomTotal) {
    return apiProvider.getRoomAvailabilityDetail(
        hotelID, checkIn, checkOut, roomTotal);
  }

  Future<BookingHistoryBaseResponse> getBookingHistoryList(
      int offset, int limit) {
    return apiProvider.getBookingHistoryList(offset, limit);
  }

  Future<BookHotelResponse> bookHotel(int hotelId, int roomCategoryId,
      int totalAdult, int totalRoom, int checkIn, int checkOut) {
    return apiProvider.bookHotel(
        hotelId, roomCategoryId, totalAdult, totalRoom, checkIn, checkOut);
  }

  Future<BookingDetailResponse> getBookingDetail(String bookingDetailId) {
    return apiProvider.getHotelBookingDetail(bookingDetailId);
  }

  ///Dana
  Future<DanaUserAccountResponse> getUserDanaStatus() {
    return apiProvider.getUserDanaStatus();
  }

  Future<DanaActivateBaseResponse> activateDana(FormData data) {
    return apiProvider.activateDanaAccount(data);
  }
}
