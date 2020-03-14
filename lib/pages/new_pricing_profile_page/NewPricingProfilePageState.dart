import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Invoice.dart';
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
  final String rateType;
  final double flatRate;
  final double hourlyRate;
  final double itemRate;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function() onDeleteProfileSelected;
  final Function(String) onProfileNameChanged;
  final Function(String) onProfileIconSelected;
  final Function(String) onFilterChanged;
  final Function(String) onFlatRateTextChanged;
  final Function(String) onHourlyRateTextChanged;
  final Function(String) onItemRateTextChanged;

  NewPricingProfilePageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.profileName,
    @required this.profileIcon,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.onDeleteProfileSelected,
    @required this.onProfileNameChanged,
    @required this.onProfileIconSelected,
    @required this.rateType,
    @required this.flatRate,
    @required this.hourlyRate,
    @required this.itemRate,
    @required this.onFilterChanged,
    @required this.onFlatRateTextChanged,
    @required this.onHourlyRateTextChanged,
    @required this.onItemRateTextChanged,
  });

  NewPricingProfilePageState copyWith({
    int id,
    int pageViewIndex,
    saveButtonEnabled,
    bool shouldClear,
    String profileName,
    String profileIcon,
    String rateType,
    double flatRate,
    double hourlyRate,
    double itemRate,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(PriceProfile) onDeleteProfileSelected,
    Function(String) onProfileNameChanged,
    Function(String) onProfileIconSelected,
    Function(String) onFilterChanged,
    Function(String) onFlatRateTextChanged,
    Function(String) onHourlyRateTextChanged,
    Function(String) onItemRateTextChanged,
  }){
    return NewPricingProfilePageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      profileName: profileName?? this.profileName,
      profileIcon: profileIcon?? this.profileIcon,
      rateType: rateType ?? this.rateType,
      flatRate: flatRate ?? this.flatRate,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      itemRate: itemRate ?? this.itemRate,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onDeleteProfileSelected: onDeleteProfileSelected?? this.onDeleteProfileSelected,
      onProfileNameChanged: onProfileNameChanged?? this.onProfileNameChanged,
      onProfileIconSelected: onProfileIconSelected?? this.onProfileIconSelected,
      onFilterChanged: onFilterChanged ?? this.onFilterChanged,
      onFlatRateTextChanged: onFlatRateTextChanged ?? this.onFlatRateTextChanged,
      onHourlyRateTextChanged: onHourlyRateTextChanged ?? this.onHourlyRateTextChanged,
      onItemRateTextChanged: onItemRateTextChanged ?? this.onItemRateTextChanged,
    );
  }

  factory NewPricingProfilePageState.initial() => NewPricingProfilePageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        profileName: "",
        profileIcon: null,
        rateType: Invoice.RATE_TYPE_FLAT_RATE,
        flatRate: 0,
        hourlyRate: 0,
        itemRate: 0,
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onDeleteProfileSelected: null,
        onProfileNameChanged: null,
        onProfileIconSelected: null,
        onFilterChanged: null,
        onFlatRateTextChanged: null,
        onHourlyRateTextChanged: null,
        onItemRateTextChanged: null,
      );

  factory NewPricingProfilePageState.fromStore(Store<AppState> store) {
    return NewPricingProfilePageState(
      id: store.state.pricingProfilePageState.id,
      pageViewIndex: store.state.pricingProfilePageState.pageViewIndex,
      saveButtonEnabled: store.state.pricingProfilePageState.saveButtonEnabled,
      shouldClear: store.state.pricingProfilePageState.shouldClear,
      profileName: store.state.pricingProfilePageState.profileName,
      profileIcon: store.state.pricingProfilePageState.profileIcon,
      rateType: store.state.pricingProfilePageState.rateType,
      flatRate: store.state.pricingProfilePageState.flatRate,
      hourlyRate: store.state.pricingProfilePageState.hourlyRate,
      onSavePressed: () => store.dispatch(SavePricingProfileAction(store.state.pricingProfilePageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.pricingProfilePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.pricingProfilePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.pricingProfilePageState)),
      onDeleteProfileSelected: () => store.dispatch(DeletePriceProfileAction(store.state.pricingProfilePageState)),
      onProfileNameChanged: (profileName) => store.dispatch(UpdateProfileNameAction(store.state.pricingProfilePageState, profileName)),
      onProfileIconSelected: (fileLocation) => store.dispatch(SetProfileIconAction(store.state.pricingProfilePageState, fileLocation)),
      onFilterChanged: (rateType) => store.dispatch(SaveSelectedRateTypeAction(store.state.pricingProfilePageState, rateType)),
      onFlatRateTextChanged: (flatRateText) => store.dispatch(UpdateFlatRateTextAction(store.state.pricingProfilePageState, flatRateText)),
      onHourlyRateTextChanged: (hourlyRateText) => store.dispatch(UpdateHourlyRateTextAction(store.state.pricingProfilePageState, hourlyRateText)),
      onItemRateTextChanged: (itemRateText) => store.dispatch(UpdateItemRateTextAction(store.state.pricingProfilePageState, itemRateText)),
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
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onProfileNameChanged.hashCode ^
      onProfileIconSelected.hashCode ^
      rateType.hashCode ^
      flatRate.hashCode ^
      hourlyRate.hashCode ^
      itemRate.hashCode ;

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
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onProfileNameChanged == other.onProfileNameChanged &&
          onProfileIconSelected == other.onProfileIconSelected &&
          rateType == other.rateType &&
          hourlyRate == other.hourlyRate &&
          itemRate == other.itemRate &&
          flatRate == other.flatRate ;
}
