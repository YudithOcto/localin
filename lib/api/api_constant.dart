class ApiConstant {
  static const String kBaseUrl = 'https://api.localin.xyz/';
  static const String kLoginUrl = 'v1/login';
  static const String kLogoutUrl = 'v1/logout';
  static const String kUpdateProfile = 'v1/member/update';
  static const String kVerifyAccount = 'v1/member/update/identitas';
  static const String kProfile = 'v1/member/me';

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

  /// ARTICLE
  static const String kUserArticle = 'v1/artikel/me';
  static const String kArticleList = 'v1/artikel';
  static const String kCreateArticle = 'v1/artikel/entri/';
  static const String kArticleTags = 'v1/artikel/tags';
}
