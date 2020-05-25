import 'package:get_it/get_it.dart';

import 'analytics/analytic_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AnalyticsService());
}
