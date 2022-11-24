import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/ImportantDate.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart' as jobActions;
import 'package:flutter/widgets.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:redux/redux.dart';

@immutable
class NewContactPageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_FIRST_NAME_MISSING = "missingFirstName";
  static const String ERROR_PHONE_INVALID = "invalidPhone";
  static const String ERROR_EMAIL_NAME_INVALID = "invalidEmail";
  static const String ERROR_INSTAGRAM_URL_INVALID = "invalidInstaUrl";
  static const String ERROR_MISSING_CONTACT_INFO = "missingContactInfo";

  final String documentId;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
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
  final List<Contact> deviceContacts;
  final List<Contact> filteredDeviceContacts;
  final Contact selectedDeviceContact;
  final String searchText;
  final String notes;
  final String customLeadSourceName;
  final String leadSource;
  final String errorState;
  final Client client;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
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
  final Function(String) onErrorStateChanged;
  final Function(String) onLeadSourceSelected;
  final Function() onGetDeviceContactsSelected;
  final Function(Contact) onDeviceContactSelected;
  final Function() onCloseSelected;
  final Function(String) onContactSearchTextChanged;
  final Function() onStartNewJobSelected;
  final Function(String) onCustomLeadSourceTextChanged;

  NewContactPageState({
    @required this.documentId,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
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
    @required this.deviceContacts,
    @required this.filteredDeviceContacts,
    @required this.selectedDeviceContact,
    @required this.searchText,
    @required this.notes,
    @required this.leadSource,
    @required this.errorState,
    @required this.client,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
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
    @required this.onErrorStateChanged,
    @required this.onLeadSourceSelected,
    @required this.onGetDeviceContactsSelected,
    @required this.onDeviceContactSelected,
    @required this.onCloseSelected,
    @required this.onContactSearchTextChanged,
    @required this.onStartNewJobSelected,
    @required this.customLeadSourceName,
    @required this.onCustomLeadSourceTextChanged,
  });

  NewContactPageState copyWith({
    String documentId,
    int pageViewIndex,
    saveButtonEnabled,
    bool shouldClear,
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
    List<Contact> deviceContacts,
    List<Contact> filteredDeviceContacts,
    Contact selectedDeviceContact,
    String searchText,
    String notes,
    String leadSource,
    String customLeadSourceName,
    String errorState,
    Client client,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
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
    Function(String) onClientIconSelected,
    Function(String) onErrorStateChanged,
    Function(String) onLeadSourceSelected,
    Function() onGetDeviceContactsSelected,
    Function(Contact) onDeviceContactSelected,
    Function() onCLoseSelected,
    Function(String) onContactSearchTextChanged,
    Function() onStartNewJobSelected,
    Function(String) onCustomLeadSourceTextChanged,
  }){
    return NewContactPageState(
      documentId: documentId?? this.documentId,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
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
      deviceContacts: deviceContacts?? this.deviceContacts,
      filteredDeviceContacts: filteredDeviceContacts?? this.filteredDeviceContacts,
      selectedDeviceContact: selectedDeviceContact?? this.selectedDeviceContact,
      searchText: searchText?? this.searchText,
      notes: notes?? this.notes,
      leadSource: leadSource?? this.leadSource,
      errorState: errorState?? this.errorState,
      client: client ?? this.client,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
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
      onErrorStateChanged: onErrorStateChanged?? this.onErrorStateChanged,
      onLeadSourceSelected: onLeadSourceSelected?? this.onLeadSourceSelected,
      onGetDeviceContactsSelected: onGetDeviceContactsSelected?? this.onGetDeviceContactsSelected,
      onDeviceContactSelected: onDeviceContactSelected?? this.onDeviceContactSelected,
      onCloseSelected: onCLoseSelected?? this.onCloseSelected,
      onContactSearchTextChanged: onContactSearchTextChanged?? this.onContactSearchTextChanged,
      onStartNewJobSelected: onStartNewJobSelected ?? this.onStartNewJobSelected,
      customLeadSourceName: customLeadSourceName ?? this.customLeadSourceName,
      onCustomLeadSourceTextChanged: onCustomLeadSourceTextChanged ?? this.onCustomLeadSourceTextChanged,
    );
  }

  factory NewContactPageState.initial() => NewContactPageState(
        documentId: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        newContactFirstName: "",
        newContactLastName: "",
        newContactPhone: "",
        newContactEmail: "",
        newContactInstagramUrl: "",
        relationshipStatus: Client.RELATIONSHIP_SINGLE,
        spouseFirstName: "",
        spouseLastName: "",
        customLeadSourceName: '',
        numberOfChildren: 0,
        importantDates: [],
        deviceContacts: [],
        filteredDeviceContacts: [],
        selectedDeviceContact: null,
        searchText: '',
        notes: "",
        leadSource: 'assets/images/icons/email_icon_white.png',
        errorState: NO_ERROR,
        client: null,
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
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
        onErrorStateChanged: null,
        onLeadSourceSelected: null,
        onGetDeviceContactsSelected: null,
        onDeviceContactSelected: null,
        onCloseSelected: null,
        onContactSearchTextChanged: null,
        onStartNewJobSelected: null,
        onCustomLeadSourceTextChanged: null,
      );

  factory NewContactPageState.fromStore(Store<AppState> store) {
    return NewContactPageState(
      documentId: store.state.newContactPageState.documentId,
      pageViewIndex: store.state.newContactPageState.pageViewIndex,
      saveButtonEnabled: store.state.newContactPageState.saveButtonEnabled,
      shouldClear: store.state.newContactPageState.shouldClear,
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
      deviceContacts: store.state.newContactPageState.deviceContacts,
      selectedDeviceContact: store.state.newContactPageState.selectedDeviceContact,
      filteredDeviceContacts: store.state.newContactPageState.filteredDeviceContacts,
      searchText: store.state.newContactPageState.searchText,
      notes: store.state.newContactPageState.notes,
      leadSource: store.state.newContactPageState.leadSource,
      errorState: store.state.newContactPageState.errorState,
      client: store.state.newContactPageState.client,
      customLeadSourceName: store.state.newContactPageState.customLeadSourceName,
      onSavePressed: () => store.dispatch(SaveNewContactAction(store.state.newContactPageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newContactPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newContactPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newContactPageState)),
      onClientFirstNameChanged: (firstName) => store.dispatch(UpdateNewContactFirstNameAction(store.state.newContactPageState, firstName)),
      onClientLastNameChanged: (lastName) => store.dispatch(UpdateNewContactLastNameAction(store.state.newContactPageState, lastName)),
      onPhoneTextChanged: (phoneNum) => store.dispatch(UpdatePhoneNumAction(store.state.newContactPageState, phoneNum)),
      onEmailTextChanged: (email) => store.dispatch(UpdateEmailAction(store.state.newContactPageState, email)),
      onInstagramUrlChanged: (instaUrl) => store.dispatch(UpdateInstagramUrlAction(store.state.newContactPageState, instaUrl)),
      onSpouseFirstNameChanged: (spouseFirstName) => store.dispatch(UpdateSpouseFirstNameAction(store.state.newContactPageState, spouseFirstName)),
      onSpouseLastNameChanged: (spouseLastName) => store.dispatch(UpdateSpouseLastNameAction(store.state.newContactPageState, spouseLastName)),
      onNumberOfChildrenChanged: (numOfChildren) => store.dispatch(UpdateNumOfChildrenAction(store.state.newContactPageState, numOfChildren)),
      onImportantDateAdded: (importantDate) => store.dispatch(AddImportantDateAction(store.state.newContactPageState, importantDate)),
      onImportantDateRemoved: (chipIndex) => store.dispatch(RemoveImportantDateAction(store.state.newContactPageState, chipIndex)),
      onNotesChanged: (notes) => store.dispatch(UpdateNotesAction(store.state.newContactPageState, notes)),
      onRelationshipStatusChanged: (statusIndex) => store.dispatch(UpdateRelationshipAction(store.state.newContactPageState, statusIndex)),
      onErrorStateChanged: (errorCode) => store.dispatch(UpdateErrorStateAction(store.state.newContactPageState, errorCode)),
      onLeadSourceSelected: (fileLocation) => store.dispatch(SetLeadSourceAction(store.state.newContactPageState, fileLocation)),
      onGetDeviceContactsSelected: () => store.dispatch(GetDeviceContactsAction(store.state.newContactPageState)),
      onDeviceContactSelected: (contact) => store.dispatch(SetSelectedDeviceContactAction(store.state.newContactPageState, contact)),
      onCloseSelected: () => store.dispatch(ClearDeviceContactsAction(store.state.newContactPageState)),
      onContactSearchTextChanged: (text) => store.dispatch(FilterDeviceContactsAction(store.state.newContactPageState, text)),
      onStartNewJobSelected: () => store.dispatch(jobActions.InitializeNewContactPageAction(store.state.newJobPageState, store.state.newContactPageState.client)),
      onCustomLeadSourceTextChanged: (customName) => store.dispatch(UpdateCustomLeadNameAction(store.state.newContactPageState, customName)),
    );
  }

  @override
  int get hashCode =>
      documentId.hashCode ^
      client.hashCode ^
      onStartNewJobSelected.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
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
      deviceContacts.hashCode ^
      filteredDeviceContacts.hashCode ^
      selectedDeviceContact.hashCode ^
      searchText.hashCode ^
      notes.hashCode ^
      leadSource.hashCode ^
      errorState.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
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
      onNotesChanged.hashCode ^
      onErrorStateChanged.hashCode ^
      onLeadSourceSelected.hashCode ^
      onDeviceContactSelected.hashCode ^
      onCloseSelected.hashCode ^
      onGetDeviceContactsSelected.hashCode ^
      customLeadSourceName.hashCode ^
      onCustomLeadSourceTextChanged.hashCode ^
      onContactSearchTextChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewContactPageState &&
          documentId == other.documentId &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
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
          deviceContacts == other.deviceContacts &&
          filteredDeviceContacts == other.filteredDeviceContacts &&
          selectedDeviceContact == other.selectedDeviceContact &&
          searchText == other.searchText &&
          notes == other.notes &&
          onStartNewJobSelected == other.onStartNewJobSelected &&
          client == other.client &&
          leadSource == other.leadSource &&
          errorState == other.errorState &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
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
          onNotesChanged == other.onNotesChanged &&
          onErrorStateChanged == other.onErrorStateChanged &&
          onLeadSourceSelected == other.onLeadSourceSelected &&
          onDeviceContactSelected == other.onDeviceContactSelected &&
          onCloseSelected == other.onCloseSelected &&
          onGetDeviceContactsSelected == other.onGetDeviceContactsSelected &&
          customLeadSourceName == other.customLeadSourceName &&
          onCustomLeadSourceTextChanged == other.onCustomLeadSourceTextChanged &&
          onContactSearchTextChanged == other.onContactSearchTextChanged;
}
