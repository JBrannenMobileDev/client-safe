import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'DeviceInfo.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelAnalyticsManager {
  static final MixPanelAnalyticsManager _instance = MixPanelAnalyticsManager._internal();
  Mixpanel _mixpanel;
  DeviceInfo _deviceInfo;
  String _mixpanelToken = "b68c6458df27e9e215eafc6e5e8d5019";

  factory MixPanelAnalyticsManager() {
    return _instance;
  }

  MixPanelAnalyticsManager._internal() {}

  Future<void> initialize(DeviceInfo deviceInfo) async {
    _deviceInfo = deviceInfo;
    _mixpanel = await Mixpanel.init(
        _mixpanelToken,
        optOutTrackingDefault: false,
        trackAutomaticEvents: true,
        superProperties: metaData,
    );
  }

  /// converting [DeviceInfo] into map
  Map<String, String> get metaData {
    return {
      'deviceIdentifier': _deviceInfo.deviceIdentifier,
      'os': _deviceInfo.os,
      'device': _deviceInfo.device,
      'appVersion': _deviceInfo.appVersion,
    };
  }

  set deviceInfo(DeviceInfo value) {
    _deviceInfo = value;
  }

  void setUserIdentity(String uuid) async {
    if (uuid.isNotEmpty && _instance != null && _mixpanel != null) {
      await _mixpanel.identify(uuid);
    }
  }

  void setUserSuperPropertiesOnce(String name, String data) async {
    if (name.isNotEmpty && data.isNotEmpty && _instance != null && _mixpanel != null) {
      await _mixpanel.registerSuperPropertiesOnce({name : data});
    }
  }

  void setUserSuperProperties(String name, String data) async {
    if (name.isNotEmpty && data.isNotEmpty && _instance != null && _mixpanel != null) {
      await _mixpanel.registerSuperProperties({name : data});
    }
  }

  void sendEvent({
    @required String eventName,
    Map<String, Object> properties,
  }) async {
    if (_instance != null && _mixpanel != null) {
      properties ??= {};
      await _mixpanel.track(eventName, properties: properties);
    }
  }
}