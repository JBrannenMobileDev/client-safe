import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../models/ImportantDate.dart';
import '../../models/ResponsesListItem.dart';

class ClientDetailsPageState {
  final Client client;
  final List<Job> clientJobs;
  final String leadSource;
  final String customLeadSourceName;
  final String notes;
  final bool showNoSavedResponsesError;
  final List<ResponsesListItem> items;
  final List<ImportantDate> importantDates;
  final Function(Client) onEditClientClicked;
  final Function() onDeleteClientClicked;
  final Function() onCallClientClicked;
  final Function() onMessageClientClicked;
  final Function() onEmailClientClicked;
  final Function(Client) onStartNewJobClicked;
  final Function(Job) onJobSelected;
  final Function() onInstagramSelected;
  final Function(String) onCustomLeadSourceTextChanged;
  final Function(String) onLeadSourceSelected;
  final Function() onSaveLeadSourceSelected;
  final Function(String) onNotesTextChanged;
  final Function(ImportantDate) onImportantDateAdded;
  final Function(int) onImportantDateRemoved;
  final Function() onSaveImportantDatesSelected;

  ClientDetailsPageState({
    @required this.client,
    @required this.clientJobs,
    @required this.onEditClientClicked,
    @required this.onDeleteClientClicked,
    @required this.onCallClientClicked,
    @required this.onMessageClientClicked,
    @required this.onEmailClientClicked,
    @required this.onStartNewJobClicked,
    @required this.onJobSelected,
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
  });

  ClientDetailsPageState copyWith({
    Client client,
    List<Job> clientJobs,
    String leadSource,
    String customLeadSourceName,
    bool showNoSavedResponsesError,
    Function(Client) onEditClientClicked,
    Function() onDeleteClientClicked,
    Function() onCallClientClicked,
    Function() onMessageClientClicked,
    Function() onEmailClientClicked,
    Function(Client) onStartNewJobClicked,
    Function(Job) onJobSelected,
    Function() onInstagramSelected,
    Function(String) onCustomLeadSourceTextChanged,
    Function(String) onLeadSourceSelected,
    Function() onSaveLeadSourceSelected,
    Function(String) onNotesTextChanged,
    String notes,
    List<ImportantDate> importantDates,
    Function(ImportantDate) onImportantDateAdded,
    Function(int) onImportantDateRemoved,
    Function() onSaveImportantDatesSelected,
    List<ResponsesListItem> items,
  }){
    return ClientDetailsPageState(
      client: client?? this.client,
      clientJobs: clientJobs?? this.clientJobs,
      onEditClientClicked: onEditClientClicked?? this.onEditClientClicked,
      onDeleteClientClicked: onDeleteClientClicked?? this.onDeleteClientClicked,
      onCallClientClicked: onCallClientClicked?? this.onCallClientClicked,
      onMessageClientClicked: onMessageClientClicked?? this.onMessageClientClicked,
      onEmailClientClicked: onEmailClientClicked?? this.onEmailClientClicked,
      onStartNewJobClicked: onStartNewJobClicked?? this.onStartNewJobClicked,
      onJobSelected: onJobSelected?? this.onJobSelected,
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
    );
  }

  factory ClientDetailsPageState.initial() => ClientDetailsPageState(
    client: null,
    clientJobs: [],
    onEditClientClicked: null,
    onDeleteClientClicked: null,
    onCallClientClicked: null,
    onMessageClientClicked: null,
    onEmailClientClicked: null,
    onStartNewJobClicked: null,
    onJobSelected: null,
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
  );

  factory ClientDetailsPageState.fromStore(Store<AppState> store) {
    return ClientDetailsPageState(
      client: store.state.clientDetailsPageState.client,
      clientJobs: store.state.clientDetailsPageState.clientJobs,
      leadSource: store.state.clientDetailsPageState.leadSource,
      customLeadSourceName: store.state.clientDetailsPageState.customLeadSourceName,
      notes: store.state.clientDetailsPageState.notes,
      importantDates: store.state.clientDetailsPageState.importantDates,
      items: store.state.clientDetailsPageState.items,
      showNoSavedResponsesError: store.state.clientDetailsPageState.showNoSavedResponsesError,
      onEditClientClicked: (client) => store.dispatch(LoadExistingClientData(store.state.newContactPageState, client)),
      onDeleteClientClicked: () => store.dispatch(DeleteClientAction(store.state.clientDetailsPageState)),
      onCallClientClicked: () => store.dispatch(null),
      onMessageClientClicked: () => store.dispatch(null),
      onEmailClientClicked: () => store.dispatch(null),
      onStartNewJobClicked: (client) => store.dispatch(InitializeNewContactPageAction(store.state.newJobPageState, client)),
      onJobSelected: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job.documentId)),
      onInstagramSelected: () => store.dispatch(InstagramSelectedAction(store.state.clientDetailsPageState)),
      onCustomLeadSourceTextChanged: (customLead) => store.dispatch(UpdateTempCustomLeadNameAction(store.state.clientDetailsPageState, customLead)),
      onLeadSourceSelected: (leadSource) => store.dispatch(SetTempLeadSourceAction(store.state.clientDetailsPageState, leadSource)),
      onSaveLeadSourceSelected: () => store.dispatch(OnSaveLeadSourceUpdateAction(store.state.clientDetailsPageState)),
      onNotesTextChanged: (notes) => store.dispatch(SaveNotesAction(store.state.clientDetailsPageState, notes)),
      onImportantDateAdded: (importantDate) => store.dispatch(AddClientDetailsImportantDateAction(store.state.clientDetailsPageState, importantDate)),
      onImportantDateRemoved: (chipIndex) => store.dispatch(RemoveClientDetailsImportantDateAction(store.state.clientDetailsPageState, chipIndex)),
      onSaveImportantDatesSelected: () => store.dispatch(SaveImportantDatesAction(store.state.clientDetailsPageState)),
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
    showNoSavedResponsesError.hashCode ^
    onJobSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientDetailsPageState &&
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
          showNoSavedResponsesError == other.showNoSavedResponsesError &&
          onJobSelected == other.onJobSelected;
}
