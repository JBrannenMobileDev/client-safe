import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class PricingProfilesPageState{

  final List<PriceProfile> pricingProfiles;
  final Function(PriceProfile) onProfileSelected;

  PricingProfilesPageState({
    @required this.pricingProfiles,
    @required this.onProfileSelected,
  });

  PricingProfilesPageState copyWith({
    List<PriceProfile> pricingProfiles,
    Function(int) onProfileSelected,
    Function() onAddNewPricingProfile,
  }){
    return PricingProfilesPageState(
      pricingProfiles: pricingProfiles?? this.pricingProfiles,
      onProfileSelected: onProfileSelected?? this.onProfileSelected,
    );
  }

  factory PricingProfilesPageState.initial() => PricingProfilesPageState(
    pricingProfiles: List(),
    onProfileSelected: null,
  );

  factory PricingProfilesPageState.fromStore(Store<AppState> store) {
    return PricingProfilesPageState(
      pricingProfiles: store.state.pricingProfilesPageState.pricingProfiles,
      onProfileSelected: (profile) => store.dispatch(LoadExistingPricingProfileData(store.state.pricingProfilePageState, profile)),
    );
  }

  @override
  int get hashCode =>
      pricingProfiles.hashCode ^
      onProfileSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PricingProfilesPageState &&
              pricingProfiles == other.pricingProfiles &&
              onProfileSelected == other.onProfileSelected;
}