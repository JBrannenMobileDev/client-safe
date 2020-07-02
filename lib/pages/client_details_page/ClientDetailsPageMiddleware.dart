
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/device_contacts/DeviceContactsDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/clients_page/ClientsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:dandylight/utils/UserPermissionsUtil.dart';
import 'package:permission_handler/permission_handler.dart';
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
    if(action is InstagramSelectedAction){
      _launchInstagramProfile(store.state.clientDetailsPageState.client.instagramProfileUrl);
    }
    if(action is LoadClientJobsAction) {
      _loadClientJobs(store, next, action);
    }
  }

  void _loadClientJobs(Store<AppState> store, NextDispatcher next, LoadClientJobsAction action) async{
    store.dispatch(SetClientJobsAction(store.state.clientDetailsPageState, await JobDao.getAllJobs()));
  }

  void _initializedClientDetailsState(Store<AppState> store, NextDispatcher next, InitializeClientDetailsAction action) async{
    next(InitializeClientDetailsAction(store.state.clientDetailsPageState, action.client));
    store.dispatch(SetClientJobsAction(store.state.clientDetailsPageState, await JobDao.getAllJobs()));
  }

  void _deleteClient(Store<AppState> store, NextDispatcher next) async{
    await ClientDao.delete(store.state.clientDetailsPageState.client);
    UserPermissionsUtil.requestPermission(Permission.contacts);
    DeviceContactsDao.deleteContact(store.state.clientDetailsPageState.client);
    store.dispatch(FetchClientData(store.state.clientsPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void _launchInstagramProfile(String instagramUrl){
    IntentLauncherUtil.launchURL(instagramUrl);
  }
}