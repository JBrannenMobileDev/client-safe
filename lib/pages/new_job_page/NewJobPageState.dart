import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
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
  final bool isFinishedFetchingClients;
  final String errorState;
  final Client selectedClient;
  final String clientSearchText;
  final String jobTitle;
  final PriceProfile selectedPriceProfile;
  final Location selectedLocation;
  final List<Client> allClients;
  final List<Client> filteredClients;
  final List<PriceProfile> pricingProfiles;
  final List<Location> locations;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(Client) onClientSelected;
  final Function(String) onClientSearchTextChanged;
  final Function() onClearInputSelected;
  final Function(String) onJobTitleTextChanged;
  final Function(PriceProfile) onPriceProfileSelected;
  final Function(Location) onLocationSelected;

  NewJobPageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.isFinishedFetchingClients,
    @required this.errorState,
    @required this.clientSearchText,
    @required this.jobTitle,
    @required this.selectedPriceProfile,
    @required this.selectedLocation,
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
    @required this.onJobTitleTextChanged,
    @required this.pricingProfiles,
    @required this.onPriceProfileSelected,
    @required this.locations,
    @required this.onLocationSelected,
  });

  NewJobPageState copyWith({
    int id,
    int pageViewIndex,
    bool saveButtonEnabled,
    bool shouldClear,
    bool isFinishedFetchingClients,
    String errorState,
    Client selectedClient,
    String clientSearchText,
    String jobTitle,
    PriceProfile selectedPriceProfile,
    Location selectedLocation,
    List<Client> allClients,
    List<Client> filteredClients,
    List<PriceProfile> pricingProfiles,
    List<Location> locations,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(Client) onClientSelected,
    Function(String) onClientSearchTextChanged,
    Function() onClearInputSelected,
    Function(String) onJobTitleTextChanged,
    Function(PriceProfile) onPriceProfileSelected,
    Function(Location) onLocationSelected,
  }){
    return NewJobPageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      isFinishedFetchingClients: isFinishedFetchingClients?? this.isFinishedFetchingClients,
      errorState: errorState?? this.errorState,
      selectedClient: selectedClient?? this.selectedClient,
      clientSearchText: clientSearchText?? this.clientSearchText,
      jobTitle: jobTitle?? this.jobTitle,
      selectedPriceProfile: selectedPriceProfile?? this.selectedPriceProfile,
      allClients: allClients?? this.allClients,
      filteredClients: filteredClients?? this.filteredClients,
      pricingProfiles: pricingProfiles?? this.pricingProfiles,
      selectedLocation: selectedLocation?? this.selectedLocation,
      locations: locations?? this.locations,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onClientSelected:  onClientSelected?? this.onClientSelected,
      onClientSearchTextChanged: onClientSearchTextChanged?? this.onClientSearchTextChanged,
      onClearInputSelected: onClearInputSelected?? this.onClearInputSelected,
      onJobTitleTextChanged: onJobTitleTextChanged?? this.onJobTitleTextChanged,
      onPriceProfileSelected: onPriceProfileSelected?? this.onPriceProfileSelected,
      onLocationSelected: onLocationSelected?? this.onLocationSelected,
    );
  }

  factory NewJobPageState.initial() => NewJobPageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        isFinishedFetchingClients: false,
        errorState: NO_ERROR,
        selectedClient: null,
        clientSearchText: "",
        jobTitle: "",
        selectedPriceProfile: null,
        selectedLocation: null,
        allClients: List(),
        filteredClients: List(),
        pricingProfiles: List(),
        locations: List(),
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onClientSelected: null,
        onClientSearchTextChanged: null,
        onClearInputSelected: null,
        onJobTitleTextChanged: null,
        onPriceProfileSelected: null,
        onLocationSelected: null,
      );

  factory NewJobPageState.fromStore(Store<AppState> store) {
    return NewJobPageState(
      id: store.state.newJobPageState.id,
      pageViewIndex: store.state.newJobPageState.pageViewIndex,
      saveButtonEnabled: store.state.newJobPageState.saveButtonEnabled,
      shouldClear: store.state.newJobPageState.shouldClear,
      isFinishedFetchingClients: store.state.newJobPageState.isFinishedFetchingClients,
      errorState: store.state.newJobPageState.errorState,
      selectedClient: store.state.newJobPageState.selectedClient,
      clientSearchText: store.state.newJobPageState.clientSearchText,
      jobTitle: store.state.newJobPageState.jobTitle,
      selectedPriceProfile: store.state.newJobPageState.selectedPriceProfile,
      selectedLocation: store.state.newJobPageState.selectedLocation,
      allClients: store.state.newJobPageState.allClients,
      filteredClients: store.state.newJobPageState.filteredClients,
      pricingProfiles: store.state.newJobPageState.pricingProfiles,
      locations: store.state.newJobPageState.locations,
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newJobPageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newJobPageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newJobPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newJobPageState)),
      onClientSelected: (client) => store.dispatch(ClientSelectedAction(store.state.newJobPageState, client)),
      onClientSearchTextChanged: (text) => store.dispatch(FilterClientList(store.state.newJobPageState, text)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newJobPageState)),
      onJobTitleTextChanged: (jobTitle) => store.dispatch(SetJobTitleAction(store.state.newJobPageState, jobTitle)),
      onPriceProfileSelected: (priceProfile) => store.dispatch(SetSelectedPriceProfile(store.state.newJobPageState, priceProfile)),
      onLocationSelected: (location) => store.dispatch(SetSelectedLocation(store.state.newJobPageState, location)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      isFinishedFetchingClients.hashCode ^
      errorState.hashCode ^
      selectedClient.hashCode ^
      clientSearchText.hashCode ^
      allClients.hashCode ^
      selectedPriceProfile.hashCode ^
      selectedLocation.hashCode ^
      filteredClients.hashCode ^
      pricingProfiles.hashCode ^
      locations.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onClientSelected.hashCode ^
      onClientSearchTextChanged.hashCode ^
      onClearInputSelected.hashCode ^
      onLocationSelected.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewJobPageState &&
          id == other.id &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          isFinishedFetchingClients == other.isFinishedFetchingClients &&
          errorState == other.errorState &&
          selectedClient == other.selectedClient &&
          clientSearchText == other.clientSearchText &&
          allClients == other.allClients &&
          filteredClients == other.filteredClients &&
          selectedPriceProfile == other.selectedPriceProfile &&
          selectedLocation == other.selectedLocation &&
          pricingProfiles == other.pricingProfiles &&
          locations == other.locations &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onClientSelected == other.onClientSelected &&
          onClientSearchTextChanged == other.onClientSearchTextChanged &&
          onClearInputSelected == other.onClearInputSelected;
}
