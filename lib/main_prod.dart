import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:localin/main.dart';

import 'build_environment.dart';

Future<void> main() async {
  BuildEnvironment.init(
      flavor: BuildFlavor.development,
      baseApiUrl: 'https://api.localin.id/',
      baseUrl: 'https://localin.id/');
  assert(buildEnvironment != null);

  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() {
    runApp(MyApp(
      isDebugMode: false,
    ));
  }, (error, stackTrace) {
    debugPrint('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
