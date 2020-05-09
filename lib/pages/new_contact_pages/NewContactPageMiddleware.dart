import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/device_contacts/DeviceContactsDao.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:client_safe/pages/clients_page/ClientsPageActions.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:redux/redux.dart';

class NewContactPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveNewContactAction){
      saveClient(store, action, next);
    }

    if(action is GetDeviceContactsAction) {
      _loadDeviceContacts(store, action, next);
    }
  }

  void _loadDeviceContacts(Store<AppState> store, action, NextDispatcher next) async{
    List<Contact> allContacts = await DeviceContactsDao.getNonClientDeviceContacts(await ClientDao.getAllSortedByFirstName());
    store.dispatch(LoadDeviceContacts(store.state.newContactPageState, allContacts));
  }

  void saveClient(Store<AppState> store, SaveNewContactAction action, NextDispatcher next) async{
    Client client = Client(
      id: action.pageState.id,
      firstName: action.pageState.newContactFirstName,
      lastName: action.pageState.newContactLastName,
      gender: action.pageState.isFemale ? Client.GENDER_FEMALE : Client.GENDER_MALE,
      email: action.pageState.newContactEmail,
      phone: action.pageState.newContactPhone,
      instagramProfileUrl: action.pageState.newContactInstagramUrl,
      relationshipStatus: action.pageState.relationshipStatus,
      spouseFirstName: action.pageState.spouseFirstName,
      spouseLastName: action.pageState.spouseLastName,
      numOfChildren: action.pageState.numberOfChildren,
      importantDates: action.pageState.importantDates,
      notes: action.pageState.notes,
      leadSource: action.pageState.leadSource,
      iconUrl: action.pageState.clientIcon != null ? action.pageState.clientIcon : ImageUtil.getRandomPersonIcon(action.pageState.isFemale),
    );
    await ClientDao.insertOrUpdate(client);
    DeviceContactsDao.addOrUpdateContact(client);
    List<Client> clients = await ClientDao.getAllSortedByFirstName();
    for(Client client in clients){
      if((client.phone.isNotEmpty && (client.phone == store.state.newContactPageState.newContactPhone)) ||
          (client.email.isNotEmpty && (client.email == store.state.newContactPageState.newContactEmail)) ||
          (client.instagramProfileUrl.isNotEmpty && (client.instagramProfileUrl == store.state.newContactPageState.newContactInstagramUrl))){
        store.dispatch(SetSavedClientToState(store.state.newContactPageState, client));
      }
    }
    store.dispatch(FetchClientData(store.state.clientsPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client));
  }
}