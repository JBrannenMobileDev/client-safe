import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';

class ClientDetailsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is InitializeClientDetailsAction){
      _initializedClientDetailsState(store, next, action);
    }
    if(action is DeleteClientAction){
      _deleteClient(store, next);
    }
  }

  void _initializedClientDetailsState(Store<AppState> store, NextDispatcher next, InitializeClientDetailsAction action) {
      next(InitializeClientDetailsAction(store.state.clientDetailsPageState, action.client));
  }

  void _deleteClient(Store<AppState> store, NextDispatcher next) async{
    ClientDao clientDao = ClientDao();
    await clientDao.delete(store.state.clientDetailsPageState.client);
    store.dispatch(FetchClientData(store.state.clientsPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}