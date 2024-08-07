import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/ImportantDate.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:redux/redux.dart';
import 'NewContactPageState.dart';

final newContactPageReducer = combineReducers<NewContactPageState>([
  TypedReducer<NewContactPageState, ClearStateAction>(_clearState),
  TypedReducer<NewContactPageState, UpdateNewContactFirstNameAction>(_updateNewContactFirstName),
  TypedReducer<NewContactPageState, UpdateNewContactLastNameAction>(_updateNewContactLastName),
  TypedReducer<NewContactPageState, UpdatePhoneNumAction>(_updatePhoneNum),
  TypedReducer<NewContactPageState, UpdateEmailAction>(_updateEmail),
  TypedReducer<NewContactPageState, UpdateInstagramUrlAction>(_updateInstaUrl),
  TypedReducer<NewContactPageState, UpdateRelationshipAction>(_updateRelationship),
  TypedReducer<NewContactPageState, SetLeadSourceAction>(_setLeadSource),
  TypedReducer<NewContactPageState, UpdateErrorStateAction>(_updateErrorState),
  TypedReducer<NewContactPageState, LoadExistingClientData>(_loadClient),
  TypedReducer<NewContactPageState, LoadDeviceContacts>(_loadDeviceContacts),
  TypedReducer<NewContactPageState, SetSelectedDeviceContactAction>(_setSelectedDeviceContact),
  TypedReducer<NewContactPageState, ClearDeviceContactsAction>(_clearDeviceContacts),
  TypedReducer<NewContactPageState, FilterDeviceContactsAction>(_filterContacts),
  TypedReducer<NewContactPageState, SetSavedClientToState>(_setClient),
  TypedReducer<NewContactPageState, UpdateCustomLeadNameAction>(_setCustomLeadSourceName),
]);


NewContactPageState _setCustomLeadSourceName(NewContactPageState previousState, UpdateCustomLeadNameAction action){
  return previousState.copyWith(
    customLeadSourceName: action.customName,
  );
}

NewContactPageState _setClient(NewContactPageState previousState, SetSavedClientToState action){
  return previousState.copyWith(
      client: action.client,
  );
}

NewContactPageState _filterContacts(NewContactPageState previousState, FilterDeviceContactsAction action) {
  List<Contact>? filteredClients = action.textInput!.length > 0
      ? previousState.deviceContacts!
      .where((client) => client
      .displayName!
      .toLowerCase()
      .contains(action.textInput!.toLowerCase()))
      .toList()
      : previousState.deviceContacts;
  if(action.textInput!.length == 0){
    filteredClients = previousState.deviceContacts;
  }
  return previousState.copyWith(
    filteredDeviceContacts: filteredClients,
    searchText: action.textInput,
  );
}

NewContactPageState _loadClient(NewContactPageState previousState, LoadExistingClientData action){
  String phone = TextFormatterUtil.formatPhoneNum(action.client!.phone);
  return previousState.copyWith(
    documentId: action.client!.documentId,
    shouldClear: false,
    newContactFirstName: action.client!.firstName,
    newContactLastName: action.client!.lastName,
    newContactPhone: phone,
    newContactEmail: action.client!.email,
    newContactInstagramUrl: action.client!.instagramProfileUrl,
    relationshipStatus: action.client!.relationshipStatus,
    spouseFirstName: action.client!.spouseFirstName,
    spouseLastName: action.client!.spouseLastName,
    numberOfChildren: action.client!.numOfChildren,
    importantDates: action.client!.importantDates,
    leadSource: action.client!.leadSource,
    notes: action.client!.notes,
    client: action.client,
    customLeadSourceName: action.client!.customLeadSourceName,
    pageViewIndex: 0,
  );
}

NewContactPageState _setSelectedDeviceContact(NewContactPageState previousState, SetSelectedDeviceContactAction action){
  String? phone = action.selectedContact!.phones != null && action.selectedContact!.phones!.isNotEmpty ? action.selectedContact!.phones!.toList().elementAt(0).value : '';
  String? email = action.selectedContact!.emails != null && action.selectedContact!.emails!.isNotEmpty ? action.selectedContact!.emails!.toList().elementAt(0).value : '';
  phone = TextFormatterUtil.formatPhoneNum(phone);
  return previousState.copyWith(
      selectedDeviceContact: action.selectedContact,
      newContactFirstName: action.selectedContact!.givenName,
      newContactLastName: action.selectedContact!.familyName,
      newContactPhone: phone,
      newContactEmail: email,
  );
}



NewContactPageState _clearDeviceContacts(NewContactPageState previousState, ClearDeviceContactsAction action){
  return previousState.copyWith(
      deviceContacts: []
  );
}

NewContactPageState _updateErrorState(NewContactPageState previousState, UpdateErrorStateAction action){
  return previousState.copyWith(
      errorState: action.errorCode
  );
}

NewContactPageState _loadDeviceContacts(NewContactPageState previousState, LoadDeviceContacts action){
  return previousState.copyWith(
      deviceContacts: action.deviceContacts,
      filteredDeviceContacts: action.deviceContacts,
  );
}

NewContactPageState _setLeadSource(NewContactPageState previousState, SetLeadSourceAction action){
  return previousState.copyWith(
      leadSource: action.leadSource,
      customLeadSourceName: '',
  );
}

NewContactPageState _updateRelationship(NewContactPageState previousState, UpdateRelationshipAction action) {
  String status = Client.RELATIONSHIP_SINGLE;
  switch(action.statusIndex){
    case 0:
      status = Client.RELATIONSHIP_MARRIED;
      break;
    case 1:
      status = Client.RELATIONSHIP_ENGAGED;
      break;
    case 2:
      status = Client.RELATIONSHIP_SINGLE;
      break;
  }
  return previousState.copyWith(
      relationshipStatus: status
  );
}

NewContactPageState _updateInstaUrl(NewContactPageState previousState, UpdateInstagramUrlAction action) {
  return previousState.copyWith(
      newContactInstagramUrl: action.instaUrl
  );
}

NewContactPageState _updateEmail(NewContactPageState previousState, UpdateEmailAction action) {
  return previousState.copyWith(
      newContactEmail: action.email
  );
}

NewContactPageState _clearState(NewContactPageState previousState, ClearStateAction action) {
  return NewContactPageState.initial();
}

NewContactPageState _updateNewContactFirstName(NewContactPageState previousState, UpdateNewContactFirstNameAction action) {
  return previousState.copyWith(
    newContactFirstName: action.firstName
  );
}

NewContactPageState _updateNewContactLastName(NewContactPageState previousState, UpdateNewContactLastNameAction action) {
  return previousState.copyWith(
      newContactLastName: action.lastName
  );
}

NewContactPageState _updatePhoneNum(NewContactPageState previousState, UpdatePhoneNumAction action) {
  return previousState.copyWith(
      newContactPhone: action.phone
  );
}
