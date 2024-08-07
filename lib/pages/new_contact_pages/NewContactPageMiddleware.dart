import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/device_contacts/DeviceContactsDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/clients_page/ClientsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../models/Progress.dart';
import '../../utils/UidUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../new_job_page/NewJobPageActions.dart';

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
      id: action.pageState!.client?.id,
      documentId: action.pageState!.client?.documentId,
      firstName: action.pageState!.newContactFirstName,
      lastName: action.pageState!.newContactLastName,
      email: action.pageState!.newContactEmail,
      phone: action.pageState!.newContactPhone,
      instagramProfileUrl: action.pageState!.newContactInstagramUrl,
      leadSource: action.pageState!.leadSource,
      customLeadSourceName: action.pageState!.customLeadSourceName,
      createdDate: action.pageState!.client?.createdDate ?? DateTime.now()
    );

    await ClientDao.insertOrUpdate(client);

    EventSender().sendEvent(eventName: EventNames.CREATED_CONTACT);

    List<Client> clients = await ClientDao.getAllSortedByFirstName();
    for(Client client in clients){
      if((client.phone != null && client.phone!.isNotEmpty && (client.phone == store.state.newContactPageState!.newContactPhone)) ||
          (client.email != null && client.email!.isNotEmpty && (client.email == store.state.newContactPageState!.newContactEmail)) ||
          (client.instagramProfileUrl != null && client.instagramProfileUrl!.isNotEmpty && (client.instagramProfileUrl == store.state.newContactPageState!.newContactInstagramUrl))){
        store.dispatch(SetSavedClientToState(store.state.newContactPageState, client));
      }
    }
    store.dispatch(FetchClientData(store.state.clientsPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client));

    //Update any job that has this client
    List<Job>? allJobs = await JobDao.getAllJobs();
    List<Job> jobsWithMatchingClient = allJobs.where((job) => job.clientDocumentId == client.documentId).toList();

    if(jobsWithMatchingClient.isNotEmpty) {
      for (var job in jobsWithMatchingClient) {
        await JobDao.update(job);
      }
    }

    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null && !profile.progress.addClient) {
      profile.progress.addClient = true;
      await ProfileDao.update(profile);
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
      EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
        EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.ADD_CLIENT,
      });
    }
  }
}