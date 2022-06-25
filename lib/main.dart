import 'package:dandylight/AppMiddleware.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/ClientSafeApp.dart';
import 'package:dandylight/AppReducers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  final store = Store<AppState>(
      appReducers,
      initialState: AppState.initial(),
      middleware: createAppMiddleware());

  initializeDateFormatting("ENG").then((_) => runApp(new ClientSafeApp(store)));
}
