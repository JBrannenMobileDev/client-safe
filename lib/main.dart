import 'package:dandylight/AppMiddleware.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/ClientSafeApp.dart';
import 'package:dandylight/AppReducers.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final store = Store<AppState>(
      appReducers,
      initialState: AppState.initial(),
      middleware: createAppMiddleware());

  initializeDateFormatting().then((_) => runApp(new ClientSafeApp(store)));
}
