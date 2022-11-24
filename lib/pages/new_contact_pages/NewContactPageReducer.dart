import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/ImportantDate.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:redux/redux.dart';
import 'NewContactPageState.dart';

final newContactPageReducer = combineReducers<NewContactPageState>([
  TypedReducer<NewContactPageState, ClearStateAction>(_clearState),
  TypedReducer<NewContactPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewContactPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewContactPageState, UpdateNewContactFirstNameAction>(_updateNewContactFirstName),
  TypedReducer<NewContactPageState, UpdateNewContactLastNameAction>(_updateNewContactLastName),
  TypedReducer<NewContactPageState, UpdatePhoneNumAction>(_updatePhoneNum),
  TypedReducer<NewContactPageState, UpdateEmailAction>(_updateEmail),
  TypedReducer<NewContactPageState, UpdateInstagramUrlAction>(_updateInstaUrl),
  TypedReducer<NewContactPageState, UpdateRelationshipAction>(_updateRelationship),
  TypedReducer<NewContactPageState, UpdateSpouseFirstNameAction>(_updateSpouseFirstName),
  TypedReducer<NewContactPageState, UpdateSpouseLastNameAction>(_updateSpouseLastName),
  TypedReducer<NewContactPageState, UpdateNumOfChildrenAction>(_updateNumOfChildren),
  TypedReducer<NewContactPageState, AddImportantDateAction>(_addImportantDate),
  TypedReducer<NewContactPageState, RemoveImportantDateAction>(_removeImportantDate),
  TypedReducer<NewContactPageState, UpdateNotesAction>(_updateNotes),
  TypedReducer<NewContactPageState, SetLeadSourceAction>(_setLeadSource),
  TypedReducer<NewContactPageState, UpdateErrorStateAction>(_updateErrorState),
  TypedReducer<NewContactPageState, LoadExistingClientData>(_loadClient),
  TypedReducer<NewContactPageState, LoadDeviceContacts>(_loadDeviceContacts),
  TypedReducer<NewContactPageState, SetSelectedDeviceContactAction>(_setSelectedDeviceContact),
  TypedReducer<NewContactPageState, ClearDeviceContactsAction>(_clearDeviceContacts),
  TypedReducer<NewContactPageState, FilterDeviceContactsAction>(_filterContacts),
  TypedReducer<NewContactPageState, SetSavedClientToState>(_setClient),
  TypedReducer<NewContactPageState, UpdateCustomLeadNameAction>(_setCustomLeadSourceName),
  TypedReducer<NewContactPageState, SetIsComingFromNewJobAction>(_setIsComingFromNewJob),
]);

NewContactPageState _setIsComingFromNewJob(NewContactPageState previousState, SetIsComingFromNewJobAction action){
  return previousState.copyWith(
    isComingFromNewJob: true,
  );
}

NewContactPageState _setCustomLeadSourceName(NewContactPageState previousState, UpdateCustomLeadNameAction action){
  return previousState.copyWith(
    customLeadSourceName: action.customName,
    leadSource: '',
  );
}

NewContactPageState _setClient(NewContactPageState previousState, SetSavedClientToState action){
  return previousState.copyWith(
      client: action.client,
  );
}

NewContactPageState _filterContacts(NewContactPageState previousState, FilterDeviceContactsAction action) {
  List<Contact> filteredClients = action.textInput.length > 0
      ? previousState.deviceContacts
      .where((client) => client
      .displayName
      .toLowerCase()
      .contains(action.textInput.toLowerCase()))
      .toList()
      : previousState.deviceContacts;
  if(action.textInput.length == 0){
    filteredClients = previousState.deviceContacts;
  }
  return previousState.copyWith(
    filteredDeviceContacts: filteredClients,
    searchText: action.textInput,
  );
}

NewContactPageState _loadClient(NewContactPageState previousState, LoadExistingClientData action){
  return previousState.copyWith(
    documentId: action.client.documentId,
    shouldClear: false,
    newContactFirstName: action.client.firstName,
    newContactLastName: action.client.lastName,
    newContactPhone: action.client.phone,
    newContactEmail: action.client.email,
    newContactInstagramUrl: action.client.instagramProfileUrl,
    relationshipStatus: action.client.relationshipStatus,
    spouseFirstName: action.client.spouseFirstName,
    spouseLastName: action.client.spouseLastName,
    numberOfChildren: action.client.numOfChildren,
    importantDates: action.client.importantDates,
    leadSource: action.client.leadSource,
    notes: action.client.notes,
    client: action.client,
    customLeadSourceName: action.client.customLeadSourceName,
    pageViewIndex: 0,
  );
}

NewContactPageState _setSelectedDeviceContact(NewContactPageState previousState, SetSelectedDeviceContactAction action){
  String phone = action.selectedContact.phones != null && action.selectedContact.phones.isNotEmpty ? action.selectedContact.phones.toList().elementAt(0).value : '';
  String email = action.selectedContact.emails!= null && action.selectedContact.emails.isNotEmpty ? action.selectedContact.emails.toList().elementAt(0).value : '';
  phone = TextFormatterUtil.formatPhoneNum(phone);
  return previousState.copyWith(
      selectedDeviceContact: action.selectedContact,
      deviceContacts: List(),
      newContactFirstName: action.selectedContact.givenName,
      newContactLastName: action.selectedContact.familyName,
      newContactPhone: phone,
      newContactEmail: email,
  );
}



NewContactPageState _clearDeviceContacts(NewContactPageState previousState, ClearDeviceContactsAction action){
  return previousState.copyWith(
      deviceContacts: List()
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

NewContactPageState _updateNotes(NewContactPageState previousState, UpdateNotesAction action) {
  return previousState.copyWith(
      notes: action.notes
  );
}

NewContactPageState _incrementPageViewIndex(NewContactPageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewContactPageState _decrementPageViewIndex(NewContactPageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewContactPageState _removeImportantDate(NewContactPageState previousState, RemoveImportantDateAction action) {
  for(ImportantDate date in previousState.importantDates){
    if(date.chipIndex == action.chipIndex){
      previousState.importantDates.remove(date);
      break;
    }
  }
  return previousState.copyWith(
      importantDates: previousState.importantDates
  );
}

NewContactPageState _addImportantDate(NewContactPageState previousState, AddImportantDateAction action) {
  previousState.importantDates.add(action.importantDate);
  return previousState.copyWith(
      importantDates: previousState.importantDates
  );
}

NewContactPageState _updateNumOfChildren(NewContactPageState previousState, UpdateNumOfChildrenAction action) {
  return previousState.copyWith(
      numberOfChildren: action.childCount
  );
}

NewContactPageState _updateSpouseLastName(NewContactPageState previousState, UpdateSpouseLastNameAction action) {
  return previousState.copyWith(
      spouseLastName: action.lastName
  );
}

NewContactPageState _updateSpouseFirstName(NewContactPageState previousState, UpdateSpouseFirstNameAction action) {
  return previousState.copyWith(
      spouseFirstName: action.firstName
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
