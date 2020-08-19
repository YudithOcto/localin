import 'package:meta/meta.dart';

enum BuildFlavor { development, production }
BuildEnvironment get buildEnvironment => _env;
BuildEnvironment _env;

class BuildEnvironment {
  final String baseApiUrl;
  final String baseUrl;
  final BuildFlavor flavor;

  BuildEnvironment._init({this.baseApiUrl, this.flavor, this.baseUrl});

  static void init(
          {@required BuildFlavor flavor,
          @required String baseApiUrl,
          @required String baseUrl}) =>
      _env ??= BuildEnvironment._init(
          flavor: flavor, baseApiUrl: baseApiUrl, baseUrl: baseUrl);
}
