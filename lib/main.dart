import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppMiddleware.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/ClientSafeApp.dart';
import 'package:dandylight/AppReducers.dart';
import 'package:dandylight/utils/PlatformInfo.dart';
import 'package:dandylight/utils/analytics/DeviceInfo.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as revenuecat;
import 'package:redux/redux.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //
  // // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await initializingMixPanel();
  await initSubscriptions();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
    ],
  );


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final store = Store<AppState>(
      appReducers,
      initialState: AppState.initial(),
      middleware: createAppMiddleware());

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  if (!kIsWeb) {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  catchAsyncErrors();

  usePathUrlStrategy();
  initializeDateFormatting().then((_) => runApp(new ClientSafeApp(store)));
}

Future<void> catchAsyncErrors() async {
  FlutterError.onError = (errorDetails) {
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
  };
  if(!kIsWeb) {
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

Future<void> initSubscriptions() async {
  if(!PlatformInfo().isWeb()) {
    await revenuecat.Purchases.setDebugLogsEnabled(true);
    revenuecat.PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = revenuecat.PurchasesConfiguration("goog_hHOtMzChjzMLkuWrwvcHpNIVaKn");
    } else if (Platform.isIOS) {
      configuration = revenuecat.PurchasesConfiguration("appl_nGYkHELZrcYyxKnkcRDQfccLFrK", );
      configuration.usesStoreKit2IfAvailable = true;
    }
    await revenuecat.Purchases.configure(configuration);
  }
}

void initializingMixPanel() async {
  DeviceInfo deviceInfo;

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  /// getting device details as per OS
  switch(PlatformInfo().getCurrentPlatformType()) {

    case PlatformType.Web:

      break;
    case PlatformType.iOS:
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceInfo = DeviceInfo(
        deviceIdentifier: iosDeviceInfo.identifierForVendor,
        os: 'iOS ${iosDeviceInfo.systemName} ${iosDeviceInfo.systemVersion}',
        device: '${iosDeviceInfo.name} ${iosDeviceInfo.model}',
        appVersion: packageInfo.version,
      );
      await EventSender().initialize(deviceInfo);
      break;
    case PlatformType.Android:
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      deviceInfo = DeviceInfo(
        deviceIdentifier: androidDeviceInfo.id,
        os: 'Android ${androidDeviceInfo.version.release} ${androidDeviceInfo.version.sdkInt}',
        device: '${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}',
        appVersion: packageInfo.version,
      );
      await EventSender().initialize(deviceInfo);
      break;
    case PlatformType.MacOS:
      // TODO: Handle this case.
      break;
    case PlatformType.Fuchsia:
      // TODO: Handle this case.
      break;
    case PlatformType.Linux:
      // TODO: Handle this case.
      break;
    case PlatformType.Windows:
      // TODO: Handle this case.
      break;
    case PlatformType.Unknown:
      // TODO: Handle this case.
      break;
  }
}
