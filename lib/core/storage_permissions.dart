import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Runtime storage access for backup import/export on Android.
///
/// Android 13+ uses the system document picker (no broad storage permission).
/// Older Android versions may need [Permission.storage] before file pickers work
/// reliably on some OEM devices — requested once from [HomeScreen].
class StoragePermissions {
  StoragePermissions._();

  static bool _requestedThisSession = false;

  /// Call on app start (Home tab). Safe to invoke multiple times.
  static Future<void> requestOnAppStart() async {
    if (_requestedThisSession) return;
    _requestedThisSession = true;
    await ensureForBackup(showSystemDialog: true);
  }

  /// Ensures backup-related access before opening file pickers.
  static Future<bool> ensureForBackup({bool showSystemDialog = false}) async {
    if (!Platform.isAndroid) {
      return true;
    }

    final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
    if (sdkInt >= 33) {
      // Scoped storage + SAF — no legacy READ_EXTERNAL_STORAGE needed.
      return true;
    }

    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    if (!showSystemDialog && status.isDenied) {
      return false;
    }

    status = await Permission.storage.request();
    return status.isGranted;
  }
}
