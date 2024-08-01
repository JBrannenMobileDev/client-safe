import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../models/ImportantDate.dart';
import '../../models/ResponsesListItem.dart';
import 'BookingPageActions.dart';

class BookingPageState {
  final Client? client;
  final List<Job>? clientJobs;
  final String? leadSource;
  final String? customLeadSourceName;
  final String? notes;
  final bool? showNoSavedResponsesError;
  final bool? setupComplete;
  final List<ResponsesListItem>? items;
  final List<ImportantDate>? importantDates;
  final Function(Client)? onEditClientClicked;
  final Function()? onDeleteClientClicked;
  final Function()? onCallClientClicked;
  final Function()? onMessageClientClicked;
  final Function()? onEmailClientClicked;
  final Function(Client)? onStartNewJobClicked;
  final Function()? onInstagramSelected;
  final Function(String)? onCustomLeadSourceTextChanged;
  final Function(String)? onLeadSourceSelected;
  final Function()? onSaveLeadSourceSelected;
  final Function(String)? onNotesTextChanged;
  final Function(ImportantDate)? onImportantDateAdded;
  final Function(int)? onImportantDateRemoved;
  final Function()? onSaveImportantDatesSelected;

  BookingPageState({
    @required this.client,
    @required this.clientJobs,
    @required this.onEditClientClicked,
    @required this.onDeleteClientClicked,
    @required this.onCallClientClicked,
    @required this.onMessageClientClicked,
    @required this.onEmailClientClicked,
    @required this.onStartNewJobClicked,
    @required this.onInstagramSelected,
    @required this.onCustomLeadSourceTextChanged,
    @required this.onLeadSourceSelected,
    @required this.leadSource,
    @required this.customLeadSourceName,
    @required this.onSaveLeadSourceSelected,
    @required this.onNotesTextChanged,
    @required this.notes,
    @required this.importantDates,
    @required this.onImportantDateAdded,
    @required this.onImportantDateRemoved,
    @required this.onSaveImportantDatesSelected,
    @required this.items,
    @required this.showNoSavedResponsesError,
    @required this.setupComplete,
  });

  BookingPageState copyWith({
    Client? client,
    List<Job>? clientJobs,
    String? leadSource,
    String? customLeadSourceName,
    bool? showNoSavedResponsesError,
    Function(Client)? onEditClientClicked,
    Function()? onDeleteClientClicked,
    Function()? onCallClientClicked,
    Function()? onMessageClientClicked,
    Function()? onEmailClientClicked,
    Function(Client)? onStartNewJobClicked,
    Function()? onInstagramSelected,
    Function(String)? onCustomLeadSourceTextChanged,
    Function(String)? onLeadSourceSelected,
    Function()? onSaveLeadSourceSelected,
    Function(String)? onNotesTextChanged,
    String? notes,
    List<ImportantDate>? importantDates,
    Function(ImportantDate)? onImportantDateAdded,
    Function(int)? onImportantDateRemoved,
    Function()? onSaveImportantDatesSelected,
    List<ResponsesListItem>? items,
    bool? setupComplete,
  }){
    return BookingPageState(
      client: client?? this.client,
      clientJobs: clientJobs?? this.clientJobs,
      onEditClientClicked: onEditClientClicked?? this.onEditClientClicked,
      onDeleteClientClicked: onDeleteClientClicked?? this.onDeleteClientClicked,
      onCallClientClicked: onCallClientClicked?? this.onCallClientClicked,
      onMessageClientClicked: onMessageClientClicked?? this.onMessageClientClicked,
      onEmailClientClicked: onEmailClientClicked?? this.onEmailClientClicked,
      onStartNewJobClicked: onStartNewJobClicked?? this.onStartNewJobClicked,
      onInstagramSelected: onInstagramSelected?? this.onInstagramSelected,
      onCustomLeadSourceTextChanged: onCustomLeadSourceTextChanged ?? this.onCustomLeadSourceTextChanged,
      onLeadSourceSelected: onLeadSourceSelected ?? this.onLeadSourceSelected,
      leadSource: leadSource ?? this.leadSource,
      customLeadSourceName: customLeadSourceName ?? this.customLeadSourceName,
      onSaveLeadSourceSelected: onSaveLeadSourceSelected ?? this.onSaveLeadSourceSelected,
      onNotesTextChanged: onNotesTextChanged ?? this.onNotesTextChanged,
      notes: notes ?? this.notes,
      importantDates: importantDates ?? this.importantDates,
      onImportantDateAdded: onImportantDateAdded ?? this.onImportantDateAdded,
      onImportantDateRemoved: onImportantDateRemoved ?? this.onImportantDateRemoved,
      onSaveImportantDatesSelected: onSaveImportantDatesSelected ?? this.onSaveImportantDatesSelected,
      items: items ?? this.items,
      showNoSavedResponsesError: showNoSavedResponsesError ?? this.showNoSavedResponsesError,
      setupComplete: setupComplete ?? this.setupComplete,
    );
  }

  factory BookingPageState.initial() => BookingPageState(
    client: null,
    clientJobs: [],
    onEditClientClicked: null,
    onDeleteClientClicked: null,
    onCallClientClicked: null,
    onMessageClientClicked: null,
    onEmailClientClicked: null,
    onStartNewJobClicked: null,
    onInstagramSelected: null,
    onCustomLeadSourceTextChanged: null,
    onLeadSourceSelected: null,
    leadSource: '',
    customLeadSourceName: '',
    onSaveLeadSourceSelected: null,
    onNotesTextChanged: null,
    notes: '',
    importantDates: [],
    onImportantDateRemoved: null,
    onImportantDateAdded: null,
    onSaveImportantDatesSelected: null,
    items: [],
    showNoSavedResponsesError: true,
    setupComplete: false,
  );

  factory BookingPageState.fromStore(Store<AppState> store) {
    return BookingPageState(
      client: store.state.bookingPageState!.client,
      clientJobs: store.state.bookingPageState!.clientJobs,
      leadSource: store.state.bookingPageState!.leadSource,
      customLeadSourceName: store.state.bookingPageState!.customLeadSourceName,
      notes: store.state.bookingPageState!.notes,
      importantDates: store.state.bookingPageState!.importantDates,
      items: store.state.bookingPageState!.items,
      showNoSavedResponsesError: store.state.bookingPageState!.showNoSavedResponsesError,
      setupComplete: store.state.bookingPageState!.setupComplete,
      onEditClientClicked: (client) => store.dispatch(LoadExistingClientData(store.state.newContactPageState!, client)),
      onDeleteClientClicked: () => store.dispatch(DeleteClientAction(store.state.bookingPageState)),
      onCallClientClicked: () => store.dispatch(null),
      onMessageClientClicked: () => store.dispatch(null),
      onEmailClientClicked: () => store.dispatch(null),
      onStartNewJobClicked: (client) => store.dispatch(InitializeNewContactPageAction(store.state.newJobPageState!, client)),
      onInstagramSelected: () => store.dispatch(InstagramSelectedAction(store.state.bookingPageState)),
      onCustomLeadSourceTextChanged: (customLead) => store.dispatch(UpdateTempCustomLeadNameAction(store.state.bookingPageState, customLead)),
      onLeadSourceSelected: (leadSource) => store.dispatch(SetTempLeadSourceAction(store.state.bookingPageState, leadSource)),
      onSaveLeadSourceSelected: () => store.dispatch(OnSaveLeadSourceUpdateAction(store.state.bookingPageState)),
      onNotesTextChanged: (notes) => store.dispatch(SaveNotesAction(store.state.bookingPageState, notes)),
      onImportantDateAdded: (importantDate) => store.dispatch(AddClientDetailsImportantDateAction(store.state.bookingPageState, importantDate)),
      onImportantDateRemoved: (chipIndex) => store.dispatch(RemoveClientDetailsImportantDateAction(store.state.bookingPageState, chipIndex)),
      onSaveImportantDatesSelected: () => store.dispatch(SaveImportantDatesAction(store.state.bookingPageState)),
    );
  }

  @override
  int get hashCode =>
    client.hashCode ^
    clientJobs.hashCode ^
    onEditClientClicked.hashCode ^
    onCallClientClicked.hashCode ^
    onDeleteClientClicked.hashCode ^
    onMessageClientClicked.hashCode ^
    onEmailClientClicked.hashCode ^
    onStartNewJobClicked.hashCode ^
    onCustomLeadSourceTextChanged.hashCode ^
    onLeadSourceSelected.hashCode ^
    leadSource.hashCode ^
    customLeadSourceName.hashCode ^
    onSaveLeadSourceSelected.hashCode ^
    onNotesTextChanged.hashCode ^
    notes.hashCode ^
    importantDates.hashCode ^
    onImportantDateRemoved.hashCode ^
    onImportantDateAdded.hashCode ^
    onSaveImportantDatesSelected.hashCode ^
    items.hashCode ^
    showNoSavedResponsesError.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingPageState &&
          client == other.client &&
          clientJobs == other.clientJobs &&
          onEditClientClicked == other.onEditClientClicked &&
          onDeleteClientClicked == other.onDeleteClientClicked &&
          onCallClientClicked == other.onCallClientClicked &&
          onMessageClientClicked == other.onMessageClientClicked &&
          onEmailClientClicked == other.onEmailClientClicked &&
          onStartNewJobClicked == other.onStartNewJobClicked &&
          onSaveLeadSourceSelected == other.onSaveLeadSourceSelected &&
          onNotesTextChanged == other.onNotesTextChanged &&
          notes == other.notes &&
          importantDates == other.importantDates &&
          onImportantDateRemoved == other.onImportantDateRemoved &&
          onImportantDateAdded == other.onImportantDateAdded &&
          onSaveImportantDatesSelected == other.onSaveImportantDatesSelected &&
          items == other.items &&
          showNoSavedResponsesError == other.showNoSavedResponsesError;
}
