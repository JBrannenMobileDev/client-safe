import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:redux/redux.dart';

class ClientsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchClientData){
      fetchClients(store, next);
    }
  }

  void fetchClients(Store<AppState> store, NextDispatcher next) async{
      List<Client> clients = await ClientDao.getAllSortedByFirstName();
      next(SetClientsData(store.state.clientsPageState, clients));
  }
}