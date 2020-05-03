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
import 'package:localin/model/hotel/booking_cancel_response.dart';
import 'package:localin/model/hotel/booking_detail_response.dart';
import 'package:localin/model/hotel/booking_history_base_response.dart';
import 'package:localin/model/hotel/booking_payment_response.dart';
import 'package:localin/model/hotel/hotel_list_base_response.dart';
import 'package:localin/model/hotel/room_base_response.dart';
import 'package:localin/model/notification/notification_model.dart';
import 'package:localin/model/user/update_profile_model.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/model/user/user_model.dart';
import 'package:localin/model/user/user_request.dart';
import 'package:localin/model/user/user_verification_category_model.dart';

class Repository {
  ApiProvider apiProvider = ApiProvider();

  Future<UserBaseModel> getUserLogin(UserRequest userRequest) async {
    return apiProvider.getUserData(userRequest.toJson());
  }

  Future<String> userLogout() async {
    return apiProvider.userLogout();
  }

  Future<String> updateUserProfile(FormData formData) async {
    return apiProvider.updateUserProfile(formData);
  }

  Future<UserModel> getUserProfile() async {
    return apiProvider.getUserProfile();
  }

  Future<UserVerificationCategoryModel> getUserVerificationCategory() async {
    return apiProvider.getUserVerificationCategory();
  }

  Future<UserModel> getOtherUserProfile(String profileId) async {
    return apiProvider.getOtherUserProfile(profileId);
  }

  Future<UpdateProfileModel> verifyUserAccount(FormData form) async {
    return apiProvider.verifyUserAccount(form);
  }

  Future<UserBaseModel> userPhoneRequestCode(String phoneNumber) async {
    return apiProvider.userPhoneRequestCode(phoneNumber);
  }

  Future<UserBaseModel> verifyPhoneVerificationCode(int smsCode) async {
    return apiProvider.verifyPhoneCodeVerification(smsCode);
  }

  Future<UserBaseModel> updateUserLoction(
      String latitude, String longitude, String address) async {
    return apiProvider.updateUserLocation(latitude, longitude, address);
  }

  Future<ArticleBaseResponse> likeArticle(String articleId) async {
    return apiProvider.likeArticle(articleId);
  }

  Future<ArticleBaseResponse> bookmarkArticle(String articleId) async {
    return apiProvider.bookmarkArticle(articleId);
  }

  Future<ArticleBaseResponse> getUserArticle() async {
    return apiProvider.getUserArticle();
  }

  Future<ArticleBaseResponse> getArticleList(int offset, int page,
      {int isLiked, int isBookmark, String keyword}) async {
    return apiProvider.getArticleList(
        offset, page, isLiked, isBookmark, keyword);
  }

  Future<ArticleBaseResponse> getRelatedArticle(String articleId) async {
    return apiProvider.getRelatedArticle(articleId);
  }

  Future<ArticleBaseResponse> getArticleByTag(
      int offset, int page, String tag) async {
    return apiProvider.getArticleByTag(offset, page, tag);
  }

  Future<ArticleBaseResponse> getOtherArticle(
      int offset, int page, String id) async {
    return apiProvider.getOtherUserArticle(offset, page, id);
  }

  Future<ArticleBaseResponse> createArticle(FormData form) async {
    return apiProvider.createArticle(form);
  }

  Future<ArticleTagResponse> getArticleTags(
      String keyword, offset, limit) async {
    return apiProvider.getArticleTags(keyword, offset, limit);
  }

  Future<ArticleCommentBaseResponse> getArticleComment(String articleId) {
    return apiProvider.getArticleComment(articleId);
  }

  Future<ArticleCommentBaseResponse> publishArticleComment(
      String articleId, String message) {
    return apiProvider.publishArticleComment(articleId, message);
  }

  Future<ArticleBaseResponse> getArticleDetail(String articleId) {
    return apiProvider.getArticleDetail(articleId);
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

  Future<CommunityDetailBaseResponse> getOtherCommunityList(String id) async {
    return apiProvider.getOtherUserCommunityList(id);
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
      String latitude,
      String longitude,
      String keyword,
      int page,
      int limit,
      DateTime checkIn,
      DateTime checkout,
      int total) {
    return apiProvider.getHotelList(
        latitude, longitude, keyword, page, limit, checkIn, checkout, total);
  }

  Future<HotelListBaseResponse> getHotelDetail(
      int hotelId, DateTime checkInDate, DateTime checkOutDate, int roomTotal) {
    return apiProvider.getHotelDetail(
        hotelId, checkInDate, checkOutDate, roomTotal);
  }

  Future<RoomBaseResponse> getRoomAvailability(
      int hotelID, DateTime checkIn, DateTime checkOut, int roomTotal) {
    return apiProvider.getRoomAvailabilityDetail(
        hotelID, checkIn, checkOut, roomTotal);
  }

  Future<BookingHistoryBaseResponse> getBookingHistoryList(
      int offset, int limit) {
    return apiProvider.getBookingHistoryList(offset, limit);
  }

  Future<BookHotelResponse> bookHotel(
      int hotelId,
      int roomCategoryId,
      int totalAdult,
      int totalRoom,
      DateTime checkIn,
      DateTime checkOut,
      String roomName) {
    return apiProvider.bookHotel(hotelId, roomCategoryId, totalAdult, totalRoom,
        checkIn, checkOut, roomName);
  }

  Future<BookingDetailResponse> getBookingDetail(String bookingDetailId) {
    return apiProvider.getHotelBookingDetail(bookingDetailId);
  }

  Future<BookingCancelResponse> cancelBooking(String bookingId) {
    return apiProvider.cancelBooking(bookingId);
  }

  ///Dana
  Future<DanaUserAccountResponse> getUserDanaStatus() {
    return apiProvider.getUserDanaStatus();
  }

  Future<DanaActivateBaseResponse> activateDana(String phone) {
    return apiProvider.activateDanaAccount(phone);
  }

  Future<BookingPaymentResponse> bookingPayment(String bookingId) {
    return apiProvider.bookingPayment(bookingId);
  }

  /// NOTIFICATION
  Future<NotificationModelResponse> getNotificationList(int offset, int limit) {
    return apiProvider.getNotificationList(offset, limit);
  }

  Future<bool> readNotificationUpdate(String notifId) async {
    return apiProvider.readNotificationUpdate(notifId);
  }

  Future<String> deleteAllNotification() async {
    return apiProvider.deleteAllNotification();
  }

  Future<String> deleteNotificationById(String id) async {
    return apiProvider.deleteNotificationById(id);
  }

  Future<String> undoNotificationDelete(String id) async {
    return apiProvider.unDeleteNotificationById(id);
  }
}
