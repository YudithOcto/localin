class ApiConstant {
  static const String kBaseUrl = 'https://api.localin.xyz/';
  static const String kLoginUrl = 'v1/login';
  static const String kLogoutUrl = 'v1/logout';
  static const String kUpdateProfile = 'v1/member/update';
  static const String kVerifyAccount = 'v1/member/update/identitas';
  static const String kVerifyPhoneNumberRequest = 'v1/member/update/handphone';
  static const String kVerifyPhoneNumberInputCodeVerification =
      'v1/member/update/handphone-verifikasi';
  static const String kProfile = 'v1/member/me';
  static const String kOtherUserProfile = 'v1/member/profile';
  static const String kUpdateUserLocation = 'v1/member/update/location';

  /// COMMUNITY
  static const String kCommunity = 'v1/komunitas';
  static const String kSearchCategory = 'v1/komunitas/kategori';
  static const String kCreateCommunity = 'v1/komunitas/create';
  static const String kEditCommunity = 'v1/komunitas/edit/';
  static const String kJoinCommunity = 'v1/komunitas/join/';
  static const String kMemberCommunity = 'v1/komunitas/anggota/';
  static const String kUserCommunity = 'v1/komunitas/me';
  static const String kCommentCommunity = 'v1/komunitas/komentar/';
  static const String kCreateEventCommunity = 'v1/komunitas/event/';
  static const String kEventCategory = 'v1/komunitas/event/kategori';

  /// ARTICLE
  static const String kUserArticle = 'v1/artikel/me';
  static const String kArticleList = 'v1/artikel';
  static const String kCreateArticle = 'v1/artikel/entri/';
  static const String kArticleTags = 'v1/artikel/tags';
  static const String kArticleComment = 'v1/artikel/komentar';
  static const String kArticleLike = 'v1/artikel/like';
  static const String kArticleBookmark = 'v1/artikel/bookmark';

  /// Hotel
  static const String kHotel = 'v1/hotel';
  static const String kHotelDetail = 'v1/hotel/detail';
  static const String kHotelRoomAvailability = 'v1/hotel/availability';
  static const String kHotelBooking = 'v1/hotel/booking';
  static const String kHotelHistory = 'v1/hotel/riwayat-booking';

  /// DANA
  static const String kDanaMe = 'payment/dana/me';
  static const String kDanaPhoneActivate = 'payment/dana/aktifasi';
  static const String kDanaAuth = 'payment/dana/auth';
  static const String kDanaPayment = 'payment/dana';

  /// NOTIFICATION
  static const String kNotificationList = 'v1/member/notifications';
}
