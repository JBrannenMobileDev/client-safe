class DeviceInfo {
  /// [deviceIdentifier] unique identification of device
  String deviceIdentifier;

  /// [os] iOS or Android
  String os;

  /// [device] Phone Details - name and model
  String device;

  /// [appVersion] Current version of the app
  String appVersion;

  DeviceInfo({
    this.deviceIdentifier,
    this.os,
    this.device,
    this.appVersion,
  });
}