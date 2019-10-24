import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewJobPageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_JOB_TITLE_MISSING = "missingJobTitle";

  final int id;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final String errorState;
  final Client selectedClient;
  final String clientSearchText;
  final List<Client> allClients;
  final List<Client> filteredClients;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(Client) onClientSelected;
  final Function(String) onClientSearchTextChanged;
  final Function() onClearInputSelected;

  NewJobPageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.errorState,
    @required this.clientSearchText,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.selectedClient,
    @required this.onClientSelected,
    @required this.onClientSearchTextChanged,
    @required this.onClearInputSelected,
    @required this.allClients,
    @required this.filteredClients,
  });

  NewJobPageState copyWith({
    int id,
    int pageViewIndex,
    bool saveButtonEnabled,
    bool shouldClear,
    String errorState,
    Client selectedClient,
    String clientSearchText,
    List<Client> allClients,
    List<Client> filteredClients,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(Client) onClientSelected,
    Function(String) onClientSearchTextChanged,
    Function() onClearInputSelected,
  }){
    return NewJobPageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      errorState: errorState?? this.errorState,
      selectedClient: selectedClient?? this.selectedClient,
      clientSearchText: clientSearchText?? this.clientSearchText,
      allClients: allClients?? this.allClients,
      filteredClients: filteredClients?? this.filteredClients,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onClientSelected:  onClientSelected?? this.onClientSelected,
      onClientSearchTextChanged: onClientSearchTextChanged?? this.onClientSearchTextChanged,
      onClearInputSelected: onClearInputSelected?? this.onClearInputSelected,
    );
  }

  factory NewJobPageState.initial() => NewJobPageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        errorState: NO_ERROR,
        selectedClient: null,
        clientSearchText: "",
        allClients: List(),
        filteredClients: List(),
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onClientSelected: null,
        onClientSearchTextChanged: null,
        onClearInputSelected: null,
      );

  factory NewJobPageState.fromStore(Store<AppState> store) {
    return NewJobPageState(
      id: store.state.newJobPageState.id,
      pageViewIndex: store.state.newJobPageState.pageViewIndex,
      saveButtonEnabled: store.state.newJobPageState.saveButtonEnabled,
      shouldClear: store.state.newJobPageState.shouldClear,
      errorState: store.state.newJobPageState.errorState,
      selectedClient: store.state.newJobPageState.selectedClient,
      clientSearchText: store.state.newJobPageState.clientSearchText,
      allClients: store.state.newJobPageState.allClients,
      filteredClients: store.state.newJobPageState.filteredClients,
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newJobPageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newJobPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newJobPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newJobPageState)),
      onClientSelected: (client) => store.dispatch(ClientSelectedAction(store.state.newJobPageState, client)),
      onClientSearchTextChanged: (text) => store.dispatch(FilterClientList(store.state.newJobPageState, text)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newJobPageState)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      errorState.hashCode ^
      selectedClient.hashCode ^
      clientSearchText.hashCode ^
      allClients.hashCode ^
      filteredClients.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onClientSelected.hashCode ^
      onClientSearchTextChanged.hashCode ^
      onClearInputSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewJobPageState &&
          id == other.id &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          errorState == other.errorState &&
          selectedClient == other.selectedClient &&
          clientSearchText == other.clientSearchText &&
          allClients == other.allClients &&
          filteredClients == other.filteredClients &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onClientSelected == other.onClientSelected &&
          onClientSearchTextChanged == other.onClientSearchTextChanged &&
          onClearInputSelected == other.onClearInputSelected;
}
