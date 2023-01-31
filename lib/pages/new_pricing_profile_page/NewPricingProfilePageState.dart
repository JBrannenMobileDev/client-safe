import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewPricingProfilePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";

  final int id;
  final String documentId;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final String profileName;
  final String profileIcon;
  final double flatRate;
  final double deposit;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function() onDeleteProfileSelected;
  final Function(String) onProfileNameChanged;
  final Function(String) onProfileIconSelected;
  final Function(String) onFilterChanged;
  final Function(String) onFlatRateTextChanged;
  final Function(String) onDepositTextChanged;

  NewPricingProfilePageState({
    @required this.id,
    @required this.documentId,
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
    @required this.flatRate,
    @required this.onFilterChanged,
    @required this.onFlatRateTextChanged,
    @required this.onDepositTextChanged,
    @required this.deposit,
  });

  NewPricingProfilePageState copyWith({
    int id,
    String documentId,
    int pageViewIndex,
    saveButtonEnabled,
    bool shouldClear,
    String profileName,
    String profileIcon,
    String rateType,
    double flatRate,
    double deposit,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(PriceProfile) onDeleteProfileSelected,
    Function(String) onProfileNameChanged,
    Function(String) onProfileIconSelected,
    Function(String) onFilterChanged,
    Function(String) onFlatRateTextChanged,
    Function(String) onDepositTextChanged,
  }){
    return NewPricingProfilePageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      profileName: profileName?? this.profileName,
      profileIcon: profileIcon?? this.profileIcon,
      flatRate: flatRate ?? this.flatRate,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onDeleteProfileSelected: onDeleteProfileSelected?? this.onDeleteProfileSelected,
      onProfileNameChanged: onProfileNameChanged?? this.onProfileNameChanged,
      onProfileIconSelected: onProfileIconSelected?? this.onProfileIconSelected,
      onFilterChanged: onFilterChanged ?? this.onFilterChanged,
      onFlatRateTextChanged: onFlatRateTextChanged ?? this.onFlatRateTextChanged,
      documentId: documentId ?? this.documentId,
      onDepositTextChanged: onDepositTextChanged ?? this.onDepositTextChanged,
      deposit: deposit ?? this.deposit,
    );
  }

  factory NewPricingProfilePageState.initial() => NewPricingProfilePageState(
        id: null,
        documentId: '',
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        profileName: "",
        profileIcon: 'assets/images/collection_icons/pricing_profile_icons/piggy_bank_icon_gold.png',
        flatRate: 0.0,
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onDeleteProfileSelected: null,
        onProfileNameChanged: null,
        onProfileIconSelected: null,
        onFilterChanged: null,
        onFlatRateTextChanged: null,
        onDepositTextChanged: null,
        deposit: 0.0,
      );

  factory NewPricingProfilePageState.fromStore(Store<AppState> store) {
    return NewPricingProfilePageState(
      id: store.state.pricingProfilePageState.id,
      pageViewIndex: store.state.pricingProfilePageState.pageViewIndex,
      saveButtonEnabled: store.state.pricingProfilePageState.saveButtonEnabled,
      shouldClear: store.state.pricingProfilePageState.shouldClear,
      profileName: store.state.pricingProfilePageState.profileName,
      profileIcon: store.state.pricingProfilePageState.profileIcon,
      flatRate: store.state.pricingProfilePageState.flatRate,
      documentId: store.state.pricingProfilePageState.documentId,
      deposit: store.state.pricingProfilePageState.deposit,
      onSavePressed: () => store.dispatch(SavePricingProfileAction(store.state.pricingProfilePageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.pricingProfilePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.pricingProfilePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.pricingProfilePageState)),
      onDeleteProfileSelected: () => store.dispatch(DeletePriceProfileAction(store.state.pricingProfilePageState)),
      onProfileNameChanged: (profileName) => store.dispatch(UpdateProfileNameAction(store.state.pricingProfilePageState, profileName)),
      onProfileIconSelected: (fileLocation) => store.dispatch(SetProfileIconAction(store.state.pricingProfilePageState, fileLocation)),
      onFilterChanged: (rateType) => store.dispatch(SaveSelectedRateTypeAction(store.state.pricingProfilePageState, rateType)),
      onFlatRateTextChanged: (flatRateText) => store.dispatch(UpdateFlatRateTextAction(store.state.pricingProfilePageState, flatRateText)),
      onDepositTextChanged: (deposit) => store.dispatch(UpdateDepositAmountAction(store.state.pricingProfilePageState, deposit)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
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
      flatRate.hashCode ^
      onFilterChanged.hashCode ^
      onDepositTextChanged.hashCode ^
      deposit.hashCode ^
      onFlatRateTextChanged.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewPricingProfilePageState &&
          id == other.id &&
          documentId == other.documentId &&
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
          onDepositTextChanged == other.onDepositTextChanged &&
          deposit == other.deposit &&
          flatRate == other.flatRate ;
}
