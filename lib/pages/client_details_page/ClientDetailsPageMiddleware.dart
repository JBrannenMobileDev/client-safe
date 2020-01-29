import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/device_contacts/DeviceContactsDao.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:client_safe/utils/IntentLauncherUtil.dart';
import 'package:client_safe/utils/UserPermissionsUtil.dart';
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
  }

  void _initializedClientDetailsState(Store<AppState> store, NextDispatcher next, InitializeClientDetailsAction action) async{
    next(InitializeClientDetailsAction(store.state.clientDetailsPageState, action.client));
    store.dispatch(SetClientJobsAction(store.state.clientDetailsPageState, await JobDao.getAllJobs()));
  }

  void _deleteClient(Store<AppState> store, NextDispatcher next) async{
    await ClientDao.delete(store.state.clientDetailsPageState.client);
    UserPermissionsUtil.requestPermission(PermissionGroup.contacts);
    DeviceContactsDao.deleteContact(store.state.clientDetailsPageState.client);
    store.dispatch(FetchClientData(store.state.clientsPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void _launchInstagramProfile(String instagramUrl){
    IntentLauncherUtil.launchURL(instagramUrl);
  }
}