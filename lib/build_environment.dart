import 'package:meta/meta.dart';

enum BuildFlavor { development, production }

BuildEnvironment get buildEnvironment => _env;
late BuildEnvironment _env;

class BuildEnvironment {
  final String baseApiUrl;
  final String baseUrl;
  final BuildFlavor flavor;

  BuildEnvironment._init({required this.baseApiUrl, required this.flavor, required this.baseUrl});

  static void init(
          {required BuildFlavor flavor,
          required String baseApiUrl,
          required String baseUrl}) =>
      _env ??= BuildEnvironment._init(
          flavor: flavor, baseApiUrl: baseApiUrl, baseUrl: baseUrl);
}
