import 'dart:io';

import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'DeviceInfo.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import 'EventNames.dart';

class EventSender {
  static final EventSender _instance = EventSender._internal();
  Mixpanel? _mixpanel;
  DeviceInfo? _deviceInfo;
  String _mixpanelTokenProd = "b68c6458df27e9e215eafc6e5e8d5019";
  String _mixpanelTokenStage = "b68c6458df27e9e215eafc6e5e8d5019";
  String _mixpanelTokenDev = "efb6a18dfd40f8417215c7e506109913";

  factory EventSender() {
    return _instance;
  }

  String _getToken() {
    switch(EnvironmentUtil().getCurrentEnvironment()) {
      case EnvironmentUtil.PROD:
        return _mixpanelTokenProd;
        break;
      case EnvironmentUtil.STAGE:
        return _mixpanelTokenStage;
        break;
      case EnvironmentUtil.DEV:
        return _mixpanelTokenDev;
        break;
    }
    return _mixpanelTokenDev;
  }

  EventSender._internal() {}

  Future<void> initialize(DeviceInfo deviceInfo) async {
    _deviceInfo = deviceInfo;
    _mixpanel = await Mixpanel.init(
        _getToken(),
        trackAutomaticEvents: true,
        superProperties: metaData,
    );
  }

  /// converting [DeviceInfo] into map
  Map<String, String> get metaData {
    return {
      'deviceIdentifier': _deviceInfo!.deviceIdentifier,
      'os': _deviceInfo!.os,
      'device': _deviceInfo!.device,
      'appVersion': _deviceInfo!.appVersion,
    };
  }

  set deviceInfo(DeviceInfo value) {
    _deviceInfo = value;
  }

  void reset() {
    if(_mixpanel != null) {
      _mixpanel!.reset();
    }
  }

  void setUserIdentity(String uid) async {
    if (uid.isNotEmpty && _instance != null && _mixpanel != null) {
      _mixpanel!.identify(uid);
    }
  }

  void setUserProfileData(String name, Object data) async {
    if (name.isNotEmpty && data != null && _instance != null && _mixpanel != null) {
      _mixpanel!.getPeople().set(name, data);
    }
  }

  void setUserSuperPropertiesOnce(String name, String data) async {
    if (name.isNotEmpty && data.isNotEmpty && _instance != null && _mixpanel != null) {
      _mixpanel!.registerSuperPropertiesOnce({name : data});
    }
  }

  void setUserSuperProperties(String name, String data) async {
    if (name.isNotEmpty && data.isNotEmpty && _instance != null && _mixpanel != null) {
      _mixpanel!.registerSuperProperties({name : data});
    }
  }

  void sendEvent({
    required String eventName,
    Map<String, Object>? properties,
  }) async {
    if (_instance != null && _mixpanel != null) {
      properties ??= {};
      _mixpanel!.track(eventName, properties: properties);
    }
  }
}