import 'package:flutter/material.dart';
import 'package:localin/presentation/community/community_category_search_page.dart';
import 'package:localin/presentation/community/community_create/widgets/community_payment_successful_page.dart';
import 'package:localin/presentation/community/community_detail/community_comment_page.dart';
import 'package:localin/presentation/community/community_detail/create_post_page.dart';
import 'package:localin/presentation/community/community_discovery/community_category_list_page.dart';
import 'package:localin/presentation/community/community_create/community_create_page.dart';
import 'package:localin/presentation/community/community_discovery/community_discover_my_group_page.dart';
import 'package:localin/presentation/community/community_discovery/community_discover_page.dart';
import 'package:localin/presentation/community/community_create/community_type_page.dart';
import 'package:localin/presentation/community/community_event/community_create_event_page.dart';
import 'package:localin/presentation/community/community_event/community_event_detail_page.dart';
import 'package:localin/presentation/community/community_event/community_event_member_page.dart';
import 'package:localin/presentation/community/community_event/community_event_tab_list_page.dart';
import 'package:localin/presentation/community/community_event/widgets/search_google_page.dart';
import 'package:localin/presentation/community/community_members/community_members_page.dart';
import 'package:localin/presentation/community/community_search/search_community_page.dart';
import 'package:localin/presentation/calendar_page/calendar_page.dart';
import 'package:localin/presentation/explore/book_ticket/book_ticket_list_selection_page.dart';
import 'package:localin/presentation/explore/detail_page/explore_detail_page.dart';
import 'package:localin/presentation/explore/detail_page/explore_operational_hours_page.dart';
import 'package:localin/presentation/explore/filter_page/explore_filter_page.dart';
import 'package:localin/presentation/explore/explore_main_page.dart';
import 'package:localin/presentation/explore/shared_widgets/row_ticket_selection_quantity_widget.dart';
import 'package:localin/presentation/explore/submit_form/submit_form_page.dart';
import 'package:localin/presentation/explore/submit_form/widgets/order_successful_page.dart';
import 'package:localin/presentation/gallery/multi_picker_gallery_page.dart';
import 'package:localin/presentation/hotel/booking_detail_page.dart';
import 'package:localin/presentation/hotel/booking_history_page.dart';
import 'package:localin/presentation/hotel/hotel_detail_page.dart';
import 'package:localin/presentation/hotel/success_booking_page.dart';
import 'package:localin/presentation/bottom_navigation/main_bottom_navigation.dart';
import 'package:localin/presentation/community/community_detail/community_detail_page.dart';
import 'package:localin/presentation/login/input_phone_number_page.dart';
import 'package:localin/presentation/map/google_maps_full_screen.dart';
import 'package:localin/presentation/error_page/empty_page.dart';
import 'package:localin/presentation/login/login_page.dart';
import 'package:localin/presentation/news/pages/news_comment_page.dart';
import 'package:localin/presentation/news/pages/news_create_article_page.dart';
import 'package:localin/presentation/news/pages/news_detail_page.dart';
import 'package:localin/presentation/news/pages/news_main_page.dart';
import 'package:localin/presentation/onboarding/onboarding_page.dart';
import 'package:localin/presentation/others_profile/revamp_others_profile_page.dart';
import 'package:localin/presentation/profile/user_profile/revamp_edit_profile_page.dart';
import 'package:localin/presentation/profile/user_profile/revamp_profile_page.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_page.dart';
import 'package:localin/presentation/profile/user_profile_verification/revamp_user_verification_success_page.dart';
import 'package:localin/presentation/search/generic_search/search_explore_event_page.dart';
import 'package:localin/presentation/search/search_article/search_article_page.dart';
import 'package:localin/presentation/search/search_location/search_location_page.dart';
import 'package:localin/presentation/search/tag_page/tags_detail_list_page.dart';
import 'package:localin/presentation/transaction/community/transaction_community_detail_page.dart';
import 'package:localin/splash_screen.dart';
import 'package:localin/presentation/inbox/notification_list_page.dart';
import 'package:localin/presentation/webview/article_webview.dart';
import 'package:localin/presentation/webview/revamp_webview.dart';
import 'package:localin/presentation/webview/webview_page.dart';

import 'presentation/explore/submit_form/confirmation_ticket_details_page.dart';

Map<String, WidgetBuilder> get generalRoutes {
  return {
    'SplashScreenPage': (_) => SplashScreen(),
    LoginPage.routeName: (_) => LoginPage(),
    MainBottomNavigation.routeName: (_) => MainBottomNavigation(),
    EmptyPage.routeName: (_) => EmptyPage(),
    CommunityDetailPage.routeName: (_) => CommunityDetailPage(),
    NotificationListPage.routeName: (_) => NotificationListPage(),
    SuccessBookingPage.routeName: (_) => SuccessBookingPage(),
    BookingDetailPage.routeName: (_) => BookingDetailPage(),
    BookingHistoryPage.routeName: (_) => BookingHistoryPage(),
    HotelDetailPage.routeName: (_) => HotelDetailPage(),
    GoogleMapFullScreen.routeName: (_) => GoogleMapFullScreen(),
    WebViewPage.routeName: (_) => WebViewPage(),
    InputPhoneNumberPage.routeName: (_) => InputPhoneNumberPage(),
    CommunityDiscoverPage.routeName: (_) => CommunityDiscoverPage(),
    OnBoardingPage.routeName: (_) => OnBoardingPage(),
    RevampProfilePage.routeName: (_) => RevampProfilePage(),
    RevampEditProfilePage.routeName: (_) => RevampEditProfilePage(),
    RevampUserVerificationPage.routeName: (_) => RevampUserVerificationPage(),
    RevampUserVerificationSuccessPage.routeName: (_) =>
        RevampUserVerificationSuccessPage(),
    RevampOthersProfilePage.routeName: (_) => RevampOthersProfilePage(),
    RevampWebview.routeName: (_) => RevampWebview(),
    ArticleWebView.routeName: (_) => ArticleWebView(),
    NewsMainPage.routeName: (_) => NewsMainPage(),
    SearchArticlePage.routeName: (_) => SearchArticlePage(),
    TagsDetailListPage.routeName: (_) => TagsDetailListPage(),
    NewsDetailPage.routeName: (_) => NewsDetailPage(),
    NewsCommentPage.routeName: (_) => NewsCommentPage(),
    NewsCreateArticlePage.routeName: (_) => NewsCreateArticlePage(),
    MultiPickerGalleryPage.routeName: (_) => MultiPickerGalleryPage(),
    SearchLocationPage.routeName: (_) => SearchLocationPage(),
    SearchCommunity.routeName: (_) => SearchCommunity(),
    CommunityCreatePage.routeName: (_) => CommunityCreatePage(),
    CommunityTypePage.routeName: (_) => CommunityTypePage(),
    CommunityCategoryListPage.routeName: (_) => CommunityCategoryListPage(),
    CommunityCommentPage.routeName: (_) => CommunityCommentPage(),
    CommunityMembersPage.routeName: (_) => CommunityMembersPage(),
    CommunityDiscoverMyGroupPage.routeName: (_) =>
        CommunityDiscoverMyGroupPage(),
    TransactionCommunityDetailPage.routeName: (_) =>
        TransactionCommunityDetailPage(),
    CreatePostPage.routeName: (_) => CreatePostPage(),
    CommunityCreateEventPage.routeName: (_) => CommunityCreateEventPage(),
    CommunityEventTabListPage.routeName: (_) => CommunityEventTabListPage(),
    CommunityEventDetailPage.routeName: (_) => CommunityEventDetailPage(),
    CommunityEventMemberPage.routeName: (_) => CommunityEventMemberPage(),
    SearchGooglePage.routeName: (_) => SearchGooglePage(),
    CommunityPaymentSuccessfulPage.routeName: (_) =>
        CommunityPaymentSuccessfulPage(),
    ExploreMainPage.routeName: (_) => ExploreMainPage(),
    CommunityCategorySearch.routeName: (_) => CommunityCategorySearch(),
    ExploreFilterPage.routeName: (_) => ExploreFilterPage(),
    ExploreDetailPage.routeName: (_) => ExploreDetailPage(),
    ExploreOperationalHoursPage.routeName: (_) => ExploreOperationalHoursPage(),
    CalendarPage.routeName: (_) => CalendarPage(),
    BookTicketListSelectionPage.routeName: (_) => BookTicketListSelectionPage(),
    SubmitFormPage.routeName: (_) => SubmitFormPage(),
    ConfirmationTicketDetailsPage.routeName: (_) =>
        ConfirmationTicketDetailsPage(),
    SearchExploreEventPage.routeName: (_) => SearchExploreEventPage(),
    OrderSuccessfulPage.routeName: (_) => OrderSuccessfulPage(),
  };
}
