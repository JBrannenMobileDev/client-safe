import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:redux/redux.dart';
import 'NewContactPageState.dart';

final newContactPageReducer = combineReducers<NewContactPageState>([
  TypedReducer<NewContactPageState, ClearStateAction>(_clearState),
  TypedReducer<NewContactPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewContactPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewContactPageState, UpdateNewContactFirstNameAction>(_updateNewContactFirstName),
  TypedReducer<NewContactPageState, UpdateNewContactLastNameAction>(_updateNewContactLastName),
  TypedReducer<NewContactPageState, UpdateGenderSelectionAction>(_updateGender),
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
  TypedReducer<NewContactPageState, SetClientIconAction>(_setClientIcon),
  TypedReducer<NewContactPageState, UpdateErrorStateAction>(_updateErrorState),
]);

NewContactPageState _updateErrorState(NewContactPageState previousState, UpdateErrorStateAction action){
  return previousState.copyWith(
      errorState: action.errorCode
  );
}

NewContactPageState _setClientIcon(NewContactPageState previousState, SetClientIconAction action){
  return previousState.copyWith(
    clientIcon: action.clientIcon
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
  previousState.importantDates.removeAt(action.chipIndex);
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

NewContactPageState _updateGender(NewContactPageState previousState, UpdateGenderSelectionAction action) {
  bool isFemale = action.genderIndex == 1;
  return previousState.copyWith(
      isFemale: isFemale,
      clientIcon: null,
  );
}

NewContactPageState _updatePhoneNum(NewContactPageState previousState, UpdatePhoneNumAction action) {
  return previousState.copyWith(
      newContactPhone: action.phone
  );
}
