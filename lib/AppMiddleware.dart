
import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPageMiddleware.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageMiddleware.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware() {
  List<Middleware<AppState>> middlewareList = new List<Middleware<AppState>>();
  middlewareList.add(TypedMiddleware<AppState, FetchClientData>(ClientsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewContactAction>(NewContactPageMiddleware()));
  return middlewareList;
}


