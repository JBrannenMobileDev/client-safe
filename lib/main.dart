import 'package:client_safe/AppMiddleware.dart';
import 'package:client_safe/AppState.dart';
import 'package:client_safe/ClientSafeApp.dart';
import 'package:client_safe/AppReducers.dart';
import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast/sembast_io.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color(ColorConstants.primary_black), // Color for Android
      statusBarBrightness: Brightness.light)); // Dark == white status bar -- for IOS.

//  await FirebaseApp.configure(
//      name: 'db2',
//      options: Platform.isIOS
//          ? const FirebaseOptions(
//        googleAppID: '1:302354368329:ios:51c249236c1fc222',
//        gcmSenderID: '297855924061',
//        databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
//      )
//          : const FirebaseOptions(
//        googleAppID: '1:302354368329:android:0e23b58fe757ce5e',
//        apiKey: 'AIzaSyAPg025-piStaX0Zd0TSEqigH2pNxhWREI',
//        databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
//      )
//  );
  final store = Store<AppState>(
      appReducers,
      initialState: AppState.initial(),
      middleware: createAppMiddleware());

  runApp(new ClientSafeApp(store));
}
