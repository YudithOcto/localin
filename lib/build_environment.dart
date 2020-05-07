import 'package:meta/meta.dart';

enum BuildFlavor { development, production }
BuildEnvironment get buildEnvironment => _env;
BuildEnvironment _env;

class BuildEnvironment {
  final String baseUrl;
  final BuildFlavor flavor;

  BuildEnvironment._init({this.baseUrl, this.flavor});

  static void init({@required BuildFlavor flavor, @required String baseUrl}) =>
      _env ??= BuildEnvironment._init(flavor: flavor, baseUrl: baseUrl);
}
