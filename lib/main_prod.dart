import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:localin/main.dart';

import 'build_environment.dart';

Future<void> main() async {
  BuildEnvironment.init(
      flavor: BuildFlavor.development, baseUrl: 'https://api.localin.id/');
  assert(buildEnvironment != null);
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}
