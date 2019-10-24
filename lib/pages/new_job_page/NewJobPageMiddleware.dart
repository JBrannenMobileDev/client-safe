import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:redux/redux.dart';

class NewJobPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllClientsAction){
      _loadAllClients(store, action, next);
    }
  }

  void _loadAllClients(Store<AppState> store, action, NextDispatcher next) async{
    ClientDao clientDao = ClientDao();
    List<Client> allClients = await clientDao.getAllSortedByFirstName();
    store.dispatch(SetAllClientsToStateAction(store.state.newJobPageState, allClients));
  }
}