import 'dart:async';
import 'package:client_safe/AppReducers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';
import 'AppState.dart';

Future<Store<AppState>> createStore() async {
  var prefs = await SharedPreferences.getInstance();
  return Store(
    appReducers,
    initialState: AppState.initial(),
    middleware: [
//      ValidationMiddleware(),
//      LoggingMiddleware.printer(),
//      LocalStorageMiddleware(prefs),
//      NavigationMiddleware()
    ],
  );
}