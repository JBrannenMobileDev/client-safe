import 'dart:io';

import 'package:dandylight/AppMiddleware.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/ClientSafeApp.dart';
import 'package:dandylight/AppReducers.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/analytics/DeviceInfo.dart';
import 'package:dandylight/utils/analytics/MixPanelAnalyticsManager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';

import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializingMixPanel();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final store = Store<AppState>(
      appReducers,
      initialState: AppState.initial(),
      middleware: createAppMiddleware());

  initializeDateFormatting().then((_) => runApp(new ClientSafeApp(store)));
}

void initializingMixPanel() async {
  DeviceInfo deviceInfo;

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  /// getting device details as per OS
  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    deviceInfo = DeviceInfo(
      deviceIdentifier: iosDeviceInfo.identifierForVendor,
      os: 'iOS ${iosDeviceInfo.systemName} ${iosDeviceInfo.systemVersion}',
      device: '${iosDeviceInfo.name} ${iosDeviceInfo.model}',
      appVersion: packageInfo.version,
    );
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    deviceInfo = DeviceInfo(
      deviceIdentifier: androidDeviceInfo.id,
      os: 'Android ${androidDeviceInfo.version.release} ${androidDeviceInfo.version.sdkInt}',
      device: '${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}',
      appVersion: packageInfo.version,
    );
  }

  await MixPanelAnalyticsManager().initialize(deviceInfo);
}
