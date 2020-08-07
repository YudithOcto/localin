import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:localin/build_environment.dart';
import 'package:localin/main.dart';

Future<void> main() async {
  BuildEnvironment.init(
      flavor: BuildFlavor.development,
      baseApiUrl: 'https://api.localin.xyz/',
      baseUrl: 'https://localin.xyz/');
  assert(buildEnvironment != null);
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  WidgetsFlutterBinding.ensureInitialized();

  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}
