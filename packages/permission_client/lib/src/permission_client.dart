import 'package:permission_handler/permission_handler.dart';

export 'package:permission_handler/permission_handler.dart'
    show PermissionStatus, PermissionStatusGetters;

/// {@template permission_client}
/// A client that handles requesting permissions on a device.
/// {@endtemplate}
class PermissionClient {
  /// {@macro permission_client}
  const PermissionClient();

  /// Request access to the device's phone,
  /// if access hasn't been previously granted.
  Future<PermissionStatus> requestPhone() =>
      Permission.phone.request();

  /// Returns a permission status for the device's phone.
  Future<PermissionStatus> phoneStatus() =>
      Permission.phone.status;

  /// Opens the app settings page.
  ///
  /// Returns true if the settings could be opened, otherwise false.
  Future<bool> openPermissionSettings() => openAppSettings();
}
