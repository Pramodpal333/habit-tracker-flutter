import 'package:package_info_plus/package_info_plus.dart';

/// App version from `pubspec.yaml` (e.g. `v1.1.0`). Call [init] in [main].
abstract final class AppVersion {
  static late final String label;

  static Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    label = 'v${info.version}';
  }
}
