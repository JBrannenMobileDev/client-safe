import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewPricingProfilePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";

  final int id;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final String profileName;
  final String profileIcon;
  final int priceFives;
  final int priceHundreds;
  final int lengthInMinutes;
  final int lengthInHours;
  final int numOfEdits;
  final String errorState;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(PriceProfile) onDeleteProfileSelected;
  final Function(String) onProfileNameChanged;
  final Function(String) onProfileIconSelected;
  final Function(int) onPriceFivesChanged;
  final Function(int) onPriceHundredsChanged;
  final Function(int) onLengthInMinutesChanged;
  final Function(int) onLengthInHoursChanged;
  final Function(int) onNumOfEditsChanged;
  final Function(String) onErrorStateChanged;

  NewPricingProfilePageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.profileName,
    @required this.profileIcon,
    @required this.priceFives,
    @required this.priceHundreds,
    @required this.lengthInMinutes,
    @required this.lengthInHours,
    @required this.numOfEdits,
    @required this.errorState,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.onDeleteProfileSelected,
    @required this.onProfileNameChanged,
    @required this.onProfileIconSelected,
    @required this.onPriceFivesChanged,
    @required this.onPriceHundredsChanged,
    @required this.onLengthInMinutesChanged,
    @required this.onLengthInHoursChanged,
    @required this.onNumOfEditsChanged,
    @required this.onErrorStateChanged,
  });

  NewPricingProfilePageState copyWith({
    int id,
    int pageViewIndex,
    saveButtonEnabled,
    bool shouldClear,
    String profileName,
    String profileIcon,
    int priceFives,
    int priceHundreds,
    int lengthInMinutes,
    int lengthInHours,
    int numOfEdits,
    String errorState,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(PriceProfile) onDeleteProfileSelected,
    Function(String) onProfileNameChanged,
    Function(String) onProfileIconSelected,
    Function(int) onPriceFivesChanged,
    Function(int) onPriceHundredsChanged,
    Function(int) onLengthInMinutesChanged,
    Function(int) onLengthInHoursChanged,
    Function(int) onNumOfEditsChanged,
    Function(String) onErrorStateChanged,
  }){
    return NewPricingProfilePageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      profileName: profileName?? this.profileName,
      profileIcon: profileIcon?? this.profileIcon,
      priceFives: priceFives?? this.priceFives,
      priceHundreds: priceHundreds?? this.priceHundreds,
      lengthInMinutes: lengthInMinutes?? this.lengthInMinutes,
      lengthInHours: lengthInHours?? this.lengthInHours,
      numOfEdits: numOfEdits?? this.numOfEdits,
      errorState: errorState?? this.errorState,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onDeleteProfileSelected: onDeleteProfileSelected?? this.onDeleteProfileSelected,
      onProfileNameChanged: onProfileNameChanged?? this.onProfileNameChanged,
      onProfileIconSelected: onProfileIconSelected?? this.onProfileIconSelected,
      onPriceFivesChanged: onPriceFivesChanged?? this.onPriceFivesChanged,
      onPriceHundredsChanged: onPriceHundredsChanged?? this.onPriceHundredsChanged,
      onLengthInMinutesChanged: onLengthInMinutesChanged?? this.onLengthInMinutesChanged,
      onLengthInHoursChanged: onLengthInHoursChanged?? this.onLengthInHoursChanged,
      onNumOfEditsChanged: onNumOfEditsChanged?? this.onNumOfEditsChanged,
      onErrorStateChanged: onErrorStateChanged?? this.onErrorStateChanged,
    );
  }

  factory NewPricingProfilePageState.initial() => NewPricingProfilePageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        profileName: "",
        profileIcon: null,
        priceFives: 0,
        priceHundreds: 0,
        lengthInMinutes: 0,
        lengthInHours: 0,
        numOfEdits: 0,
        errorState: NO_ERROR,
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onDeleteProfileSelected: null,
        onProfileNameChanged: null,
        onProfileIconSelected: null,
        onPriceFivesChanged: null,
        onPriceHundredsChanged: null,
        onLengthInMinutesChanged: null,
        onLengthInHoursChanged: null,
        onNumOfEditsChanged: null,
        onErrorStateChanged: null,
      );

  factory NewPricingProfilePageState.fromStore(Store<AppState> store) {
    return NewPricingProfilePageState(
      id: store.state.pricingProfilePageState.id,
      pageViewIndex: store.state.pricingProfilePageState.pageViewIndex,
      saveButtonEnabled: store.state.pricingProfilePageState.saveButtonEnabled,
      shouldClear: store.state.pricingProfilePageState.shouldClear,
      profileName: store.state.pricingProfilePageState.profileName,
      profileIcon: store.state.pricingProfilePageState.profileIcon,
      priceFives: store.state.pricingProfilePageState.priceFives,
      priceHundreds: store.state.pricingProfilePageState.priceHundreds,
      lengthInMinutes: store.state.pricingProfilePageState.lengthInMinutes,
      lengthInHours: store.state.pricingProfilePageState.lengthInHours,
      numOfEdits: store.state.pricingProfilePageState.numOfEdits,
      errorState: store.state.newContactPageState.errorState,
      onSavePressed: () => store.dispatch(SavePricingProfileAction(store.state.pricingProfilePageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.pricingProfilePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.pricingProfilePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.pricingProfilePageState)),
      onDeleteProfileSelected: (priceProfile) => store.dispatch(DeletePriceProfileAction(store.state.pricingProfilePageState, priceProfile)),
      onProfileNameChanged: (profileName) => store.dispatch(UpdateProfileNameAction(store.state.pricingProfilePageState, profileName)),
      onProfileIconSelected: (fileLocation) => store.dispatch(SetProfileIconAction(store.state.pricingProfilePageState, fileLocation)),
      onPriceFivesChanged: (priceFives) => store.dispatch(UpdateProfilePriceFivesAction(store.state.pricingProfilePageState, priceFives)),
      onPriceHundredsChanged: (priceHundreds) => store.dispatch(UpdateProfilePriceHundredsAction(store.state.pricingProfilePageState, priceHundreds)),
      onLengthInMinutesChanged: (lengthInMinutes) => store.dispatch(UpdateProfileLengthAction(store.state.pricingProfilePageState, lengthInMinutes)),
      onLengthInHoursChanged: (lengthInHours) => store.dispatch(UpdateProfileLengthInHoursAction(store.state.pricingProfilePageState, lengthInHours)),
      onNumOfEditsChanged: (numOfEdits) => store.dispatch(UpdateProfileNumberOfEditsAction(store.state.pricingProfilePageState, numOfEdits)),
      onErrorStateChanged: (errorCode) => store.dispatch(UpdateErrorStateAction(store.state.pricingProfilePageState, errorCode)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      profileName.hashCode ^
      profileIcon.hashCode ^
      priceFives.hashCode ^
      priceHundreds.hashCode ^
      lengthInMinutes.hashCode ^
      lengthInHours.hashCode ^
      numOfEdits.hashCode ^
      errorState.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onProfileNameChanged.hashCode ^
      onProfileIconSelected.hashCode ^
      onPriceFivesChanged.hashCode ^
      onPriceHundredsChanged.hashCode ^
      onLengthInMinutesChanged.hashCode ^
      onNumOfEditsChanged.hashCode ^
      onErrorStateChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewPricingProfilePageState &&
          id == other.id &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          profileName == other.profileName &&
          profileIcon == other.profileIcon &&
          priceFives == other.priceFives &&
          priceHundreds == other.priceHundreds &&
          lengthInMinutes == other.lengthInMinutes &&
          lengthInHours == other.lengthInHours &&
          numOfEdits == other.numOfEdits &&
          errorState == other.errorState &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onProfileNameChanged == other.onProfileNameChanged &&
          onProfileIconSelected == other.onProfileIconSelected &&
          onPriceFivesChanged == other.onPriceFivesChanged &&
          onPriceHundredsChanged == other.onPriceHundredsChanged &&
          onLengthInMinutesChanged == other.onLengthInMinutesChanged &&
          onNumOfEditsChanged == other.onNumOfEditsChanged &&
          onErrorStateChanged == other.onErrorStateChanged;
}
