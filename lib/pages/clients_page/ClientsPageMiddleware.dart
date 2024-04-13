import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/clients_page/ClientsPageActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

class ClientsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchClientData){
      fetchClients(store, next);
    }
  }

  void fetchClients(Store<AppState> store, NextDispatcher next) async{
      List<Client> clients = await ClientDao.getAllSortedByFirstName();
      List<Job>? allJobs = await JobDao.getAllJobs();
      next(SetClientsData(store.state.clientsPageState, clients, allJobs));

      (await ClientDao.getClientsStream()).listen((clientSnapshots) async {
        List<Client> clients = [];
        for(RecordSnapshot clientSnapshot in clientSnapshots) {
          clients.add(Client.fromMap(clientSnapshot.value! as Map<String, dynamic>));
        }
        store.dispatch(SetClientsData(store.state.clientsPageState, clients, allJobs));
      });

      (await JobDao.getJobsStream()).listen((jobSnapshots) async {
        List<Job> jobs = [];
        for(RecordSnapshot clientSnapshot in jobSnapshots) {
          jobs.add(Job.fromMap(clientSnapshot.value! as Map<String, dynamic>));
        }
        store.dispatch(SetClientsData(store.state.clientsPageState, clients, jobs));
      });
  }
}