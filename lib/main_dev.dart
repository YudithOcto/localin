import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localin/build_environment.dart';
import 'package:localin/main.dart';

Future<void> main() async {
  BuildEnvironment.init(
      flavor: BuildFlavor.development,
      baseApiUrl: 'https://api.localin.xyz/',
      baseUrl: 'https://localin.xyz/');
  assert(buildEnvironment != null);
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() {
    runApp(MyApp(
      isDebugMode: true,
    ));
  }, (error, stackTrace) {
    debugPrint('runZonedGuarded: Caught error in my root zone.');
  });
}
