import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/ImportantDate.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewContactPageState {
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool isFemale;
  final String newContactFirstName;
  final String newContactLastName;
  final String newContactPhone;
  final String newContactEmail;
  final String newContactInstagramUrl;
  final String relationshipStatus;
  final String spouseFirstName;
  final String spouseLastName;
  final int numberOfChildren;
  final List<ImportantDate> importantDates;
  final String notes;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function(int) onGenderSelected;
  final Function(String) onClientFirstNameChanged;
  final Function(String) onClientLastNameChanged;
  final Function(String) onPhoneTextChanged;
  final Function(String) onEmailTextChanged;
  final Function(String) onInstagramUrlChanged;
  final Function(int) onRelationshipStatusChanged;
  final Function(String) onSpouseFirstNameChanged;
  final Function(String) onSpouseLastNameChanged;
  final Function(int) onNumberOfChildrenChanged;
  final Function(ImportantDate) onImportantDateAdded;
  final Function(int) onImportantDateRemoved;
  final Function(String) onNotesChanged;

  NewContactPageState({
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.isFemale,
    @required this.newContactFirstName,
    @required this.newContactLastName,
    @required this.newContactPhone,
    @required this.newContactEmail,
    @required this.newContactInstagramUrl,
    @required this.relationshipStatus,
    @required this.spouseFirstName,
    @required this.spouseLastName,
    @required this.numberOfChildren,
    @required this.importantDates,
    @required this.notes,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onGenderSelected,
    @required this.onClientFirstNameChanged,
    @required this.onClientLastNameChanged,
    @required this.onPhoneTextChanged,
    @required this.onEmailTextChanged,
    @required this.onInstagramUrlChanged,
    @required this.onRelationshipStatusChanged,
    @required this.onSpouseFirstNameChanged,
    @required this.onSpouseLastNameChanged,
    @required this.onNumberOfChildrenChanged,
    @required this.onImportantDateAdded,
    @required this.onImportantDateRemoved,
    @required this.onNotesChanged,
  });

  NewContactPageState copyWith({
    int pageViewIndex,
    saveButtonEnabled,
    bool isFemale,
    String newContactFirstName,
    String newContactLastName,
    String newContactPhone,
    String newContactEmail,
    String newContactInstagramUrl,
    String relationshipStatus,
    String spouseFirstName,
    String spouseLastName,
    int numberOfChildren,
    List<ImportantDate> importantDates,
    String notes,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function(int) onGenderSelected,
    Function(String) onClientFirstNameChanged,
    Function(String) onClientLastNameChanged,
    Function(String) onPhoneTextChanged,
    Function(String) onEmailTextChanged,
    Function(String) onInstagramUrlChanged,
    Function(int) onRelationshipStatusChanged,
    Function(String) onSpouseFirstNameChanged,
    Function(String) onSpouseLastNameChanged,
    Function(int) onNumberOfChildrenChanged,
    Function(ImportantDate) onImportantDateAdded,
    Function(int) onImportantDateRemoved,
    Function(String) onNotesChanged,
  }){
    return NewContactPageState(
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      isFemale: isFemale?? this.isFemale,
      newContactFirstName: newContactFirstName?? this.newContactFirstName,
      newContactLastName: newContactLastName?? this.newContactLastName,
      newContactPhone: newContactPhone?? this.newContactPhone,
      newContactEmail: newContactEmail?? this.newContactEmail,
      newContactInstagramUrl: newContactInstagramUrl?? this.newContactInstagramUrl,
      relationshipStatus: relationshipStatus?? this.relationshipStatus,
      spouseFirstName: spouseFirstName?? this.spouseFirstName,
      spouseLastName: spouseLastName?? this.spouseLastName,
      numberOfChildren: numberOfChildren?? this.numberOfChildren,
      importantDates: importantDates?? this.importantDates,
      notes: notes?? this.notes,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onGenderSelected: onGenderSelected?? this.onGenderSelected,
      onClientFirstNameChanged: onClientFirstNameChanged?? this.onClientFirstNameChanged,
      onClientLastNameChanged: onClientLastNameChanged?? this.onClientLastNameChanged,
      onPhoneTextChanged: onPhoneTextChanged?? this.onPhoneTextChanged,
      onEmailTextChanged: onEmailTextChanged?? this.onEmailTextChanged,
      onInstagramUrlChanged: onInstagramUrlChanged?? this.onInstagramUrlChanged,
      onSpouseFirstNameChanged: onSpouseFirstNameChanged?? this.onSpouseFirstNameChanged,
      onSpouseLastNameChanged: onSpouseLastNameChanged?? this.onSpouseLastNameChanged,
      onNumberOfChildrenChanged: onNumberOfChildrenChanged?? this.onNumberOfChildrenChanged,
      onImportantDateAdded: onImportantDateAdded?? this.onImportantDateAdded,
      onImportantDateRemoved: onImportantDateRemoved?? this.onImportantDateRemoved,
      onNotesChanged: onNotesChanged?? this.onNotesChanged,
      onRelationshipStatusChanged: onRelationshipStatusChanged?? this.onRelationshipStatusChanged,
    );
  }

  factory NewContactPageState.initial() => NewContactPageState(
        pageViewIndex: 0,
        saveButtonEnabled: false,
        isFemale: true,
        newContactFirstName: "",
        newContactLastName: "",
        newContactPhone: "",
        newContactEmail: "",
        newContactInstagramUrl: "",
        relationshipStatus: "",
        spouseFirstName: "",
        spouseLastName: "",
        numberOfChildren: 0,
        importantDates: List(),
        notes: "",
        onSavePressed: null,
        onCancelPressed: null,
        onGenderSelected: null,
        onRelationshipStatusChanged: null,
        onClientFirstNameChanged: null,
        onClientLastNameChanged: null,
        onPhoneTextChanged: null,
        onEmailTextChanged: null,
        onInstagramUrlChanged: null,
        onSpouseFirstNameChanged: null,
        onSpouseLastNameChanged: null,
        onNumberOfChildrenChanged: null,
        onImportantDateAdded: null,
        onImportantDateRemoved: null,
        onNotesChanged: null,
      );

  factory NewContactPageState.fromStore(Store<AppState> store) {
    return NewContactPageState(
      pageViewIndex: store.state.newContactPageState.pageViewIndex,
      saveButtonEnabled: store.state.newContactPageState.saveButtonEnabled,
      isFemale: store.state.newContactPageState.isFemale,
      newContactFirstName: store.state.newContactPageState.newContactFirstName,
      newContactLastName: store.state.newContactPageState.newContactLastName,
      newContactPhone: store.state.newContactPageState.newContactPhone,
      newContactEmail: store.state.newContactPageState.newContactEmail,
      newContactInstagramUrl: store.state.newContactPageState.newContactInstagramUrl,
      relationshipStatus: store.state.newContactPageState.relationshipStatus,
      spouseFirstName: store.state.newContactPageState.spouseFirstName,
      spouseLastName: store.state.newContactPageState.spouseLastName,
      numberOfChildren: store.state.newContactPageState.numberOfChildren,
      importantDates: store.state.newContactPageState.importantDates,
      notes: store.state.newContactPageState.notes,
      onSavePressed: () => store.dispatch(null),
      onCancelPressed: () => store.dispatch(null),
      onGenderSelected: (genderIndex) => store.dispatch(null),
      onClientFirstNameChanged: (firstName) => store.dispatch(null),
      onClientLastNameChanged: (lastName) => store.dispatch(null),
      onPhoneTextChanged: (phoneNum) => store.dispatch(null),
      onEmailTextChanged: (email) => store.dispatch(null),
      onInstagramUrlChanged: (instaUrl) => store.dispatch(null),
      onSpouseFirstNameChanged: (spouseFirstName) => store.dispatch(null),
      onSpouseLastNameChanged: (spouseLastName) => store.dispatch(null),
      onNumberOfChildrenChanged: (numOfChildren) => store.dispatch(null),
      onImportantDateAdded: (importantDate) => store.dispatch(null),
      onImportantDateRemoved: (chipIndex) => store.dispatch(null),
      onNotesChanged: (notes) => store.dispatch(null),
      onRelationshipStatusChanged: (statusIndex) => store.dispatch(null),
    );
  }

  @override
  int get hashCode =>
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      isFemale.hashCode ^
      newContactFirstName.hashCode ^
      newContactLastName.hashCode ^
      newContactPhone.hashCode ^
      newContactEmail.hashCode ^
      newContactInstagramUrl.hashCode ^
      relationshipStatus.hashCode ^
      spouseFirstName.hashCode ^
      spouseLastName.hashCode ^
      numberOfChildren.hashCode ^
      importantDates.hashCode ^
      notes.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onGenderSelected.hashCode ^
      onClientFirstNameChanged.hashCode ^
      onClientLastNameChanged.hashCode ^
      onPhoneTextChanged.hashCode ^
      onEmailTextChanged.hashCode ^
      onInstagramUrlChanged.hashCode ^
      onRelationshipStatusChanged.hashCode ^
      onSpouseFirstNameChanged.hashCode ^
      onSpouseLastNameChanged.hashCode ^
      onNumberOfChildrenChanged.hashCode ^
      onImportantDateAdded.hashCode ^
      onImportantDateRemoved.hashCode ^
      onNotesChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewContactPageState &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          isFemale == other.isFemale &&
          newContactFirstName == other.newContactFirstName &&
          newContactLastName == other.newContactLastName &&
          newContactPhone == other.newContactPhone &&
          newContactEmail == other.newContactEmail &&
          newContactInstagramUrl == other.newContactInstagramUrl &&
          relationshipStatus == other.relationshipStatus &&
          spouseFirstName == other.spouseFirstName &&
          spouseLastName == other.spouseLastName &&
          numberOfChildren == other.numberOfChildren &&
          importantDates == other.importantDates &&
          notes == other.notes &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onGenderSelected == other.onGenderSelected &&
          onClientFirstNameChanged == other.onClientFirstNameChanged &&
          onClientLastNameChanged == other.onClientLastNameChanged &&
          onPhoneTextChanged == other.onPhoneTextChanged &&
          onEmailTextChanged == other.onEmailTextChanged &&
          onInstagramUrlChanged == other.onInstagramUrlChanged &&
          onRelationshipStatusChanged == other.onRelationshipStatusChanged &&
          onSpouseFirstNameChanged == other.onSpouseFirstNameChanged &&
          onSpouseLastNameChanged == other.onSpouseLastNameChanged &&
          onNumberOfChildrenChanged == other.onNumberOfChildrenChanged &&
          onImportantDateAdded == other.onImportantDateAdded &&
          onImportantDateRemoved == other.onImportantDateRemoved &&
          onNotesChanged == other.onNotesChanged;
}
