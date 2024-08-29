// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:flutter/material.dart';
//
// class AnalyticsService {
//   final FirebaseAnalytics _analytics = FirebaseAnalytics();
//
//   FirebaseAnalyticsObserver getAnalyticsObserver() =>
//       FirebaseAnalyticsObserver(analytics: _analytics);
//
//   Future setUserProperties({@required String userId}) async {
//     await _analytics.setUserId(userId);
//   }
//
//   Future setScreenName({String name}) async {
//     await _analytics.setCurrentScreen(screenName: name);
//   }
//
//   Future setCustomEvent(
//       {@required String eventName, Map<String, dynamic> parameters}) async {
//     return _analytics.logEvent(name: eventName, parameters: parameters);
//   }
//
//   Future setCustomSearchEvent(
//       {String keyword,
//       String startDate,
//       String endDate,
//       int numberOfRooms}) async {
//     return _analytics.logSearch(
//         searchTerm: keyword,
//         startDate: startDate,
//         endDate: endDate,
//         numberOfRooms: numberOfRooms);
//   }
// }
//
// class FirebaseAnalytics {
// }
