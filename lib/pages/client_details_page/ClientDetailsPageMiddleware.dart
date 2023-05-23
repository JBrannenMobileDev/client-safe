
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/device_contacts/DeviceContactsDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/clients_page/ClientsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/ResponseDao.dart';
import '../../models/Client.dart';
import '../../models/Response.dart';

class ClientDetailsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is InitializeClientDetailsAction){
      _initializedClientDetailsState(store, next, action);
    }
    if(action is DeleteClientAction){
      _deleteClient(store, next);
    }
    if(action is InstagramSelectedAction){
      _launchInstagramProfile(store.state.clientDetailsPageState.client.instagramProfileUrl);
    }
    if(action is OnSaveLeadSourceUpdateAction){
      _updateClientLeadSource(store, next, action);
    }
    if(action is SaveNotesAction){
      _updateClientNotes(store, next, action);
    }
    if(action is SaveImportantDatesAction) {
      _updateClientWithImportantDates(store, action);
    }
    if(action is FetchClientDetailsResponsesAction){
      fetchResponses(store);
    }
  }

  void fetchResponses(Store<AppState> store) async{
    List<Response> responses = await ResponseDao.getAll();
    store.dispatch(SetClientDetailsResponsesAction(store.state.clientDetailsPageState, responses));

    (await ResponseDao.getResponseStream()).listen((snapshots) async {
      List<Response> streamResponses = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        streamResponses.add(Response.fromMap(clientSnapshot.value));
      }

      store.dispatch(SetClientDetailsResponsesAction(store.state.clientDetailsPageState, responses));
    });
  }

  void _updateClientWithImportantDates(Store<AppState> store, SaveImportantDatesAction action) async{
    Client client = action.pageState.client;
    client.importantDates = action.pageState.importantDates;
    await ClientDao.update(client);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateClientNotes(Store<AppState> store, NextDispatcher next, SaveNotesAction action) async{
    Client client = action.pageState.client;
    client.notes = action.notes;
    await ClientDao.update(client);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _updateClientLeadSource(Store<AppState> store, NextDispatcher next, OnSaveLeadSourceUpdateAction action) async{
    Client client = action.pageState.client;
    client.leadSource = action.pageState.leadSource;
    client.customLeadSourceName = action.pageState.customLeadSourceName;

    await ClientDao.update(client);

    next(action);
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void _initializedClientDetailsState(Store<AppState> store, NextDispatcher next, InitializeClientDetailsAction action) async{
    next(InitializeClientDetailsAction(store.state.clientDetailsPageState, action.client));
    store.dispatch(SetClientJobsAction(store.state.clientDetailsPageState, await JobDao.getAllJobs()));

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = List();
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetClientJobsAction(store.state.clientDetailsPageState, jobs));
    });
  }

  void _deleteClient(Store<AppState> store, NextDispatcher next) async{
    await ClientDao.delete(store.state.clientDetailsPageState.client);
    if(await ClientDao.getClientById(store.state.clientDetailsPageState.client.documentId) != null) {
      await ClientDao.delete(store.state.clientDetailsPageState.client);
    }

    bool isGranted = (await UserPermissionsUtil.getPermissionStatus(Permission.contacts)).isGranted;
    if(isGranted) {
      DeviceContactsDao.deleteContact(store.state.clientDetailsPageState.client);
    }
    store.dispatch(FetchClientData(store.state.clientsPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void _launchInstagramProfile(String instagramUrl){
    IntentLauncherUtil.launchURL(instagramUrl);
  }
}