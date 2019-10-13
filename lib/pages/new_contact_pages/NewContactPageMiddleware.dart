import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/ImportantDate.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:redux/redux.dart';

class NewContactPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveNewContactAction){
      saveClient(store, action, next);
    }
  }

  void saveClient(Store<AppState> store, action, NextDispatcher next) async{
    ClientDao clientDao = ClientDao();
    Client client = Client(
      firstName: action.pageState.newContactFirstName,
      lastName: action.pageState.newContactLastName,
      gender: action.pageState.isFemale ? Client.GENDER_FEMALE : Client.GENDER_MALE,
      email: action.pageState.newContactEmail,
      phone: action.pageState.newContactPhone,
      instagramProfileUrl: action.pageState.newContactInstagramUrl,
      spouseFirstName: action.pageState.spouseFirstName,
      spouseLastName: action.pageState.spouseLastName,
      numOfChildren: action.pageState.numberOfChildren,
      importantDates: action.pageState.importantDates,
      notes: action.pageState.notes,
      iconUrl: action.pageState.clientIcon != null ? action.pageState.clientIcon : ImageUtil.getRandomPersonIcon(action.pageState.isFemale),
    );
    await clientDao.insert(client);
  }
}