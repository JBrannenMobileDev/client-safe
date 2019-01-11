import 'package:client_safe/AppMiddleware.dart';
import 'package:client_safe/AppState.dart';
import 'package:client_safe/ClientSafeApp.dart';
import 'package:client_safe/AppReducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

Future main() async {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown]);
  final store = new Store<AppState>(
      appReducers,
      initialState: AppState.initial(),
      middleware: createAppMiddleware());
  runApp(new ClientSafeApp(store));
}
