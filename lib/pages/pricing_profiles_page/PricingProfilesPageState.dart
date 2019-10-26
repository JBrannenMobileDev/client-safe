import 'package:client_safe/models/PriceProfile.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class PricingProfilesPageState{

  final List<PriceProfile> pricingProfiles;
  final Function(PriceProfile) onProfileSelected;
  final Function() onAddNewPricingProfile;

  PricingProfilesPageState({
    @required this.pricingProfiles,
    @required this.onProfileSelected,
    @required this.onAddNewPricingProfile,
  });

  PricingProfilesPageState copyWith({
    List<PriceProfile> pricingProfiles,
    Function(int) onProfileSelected,
    Function() onAddNewPricingProfile,
  }){
    return PricingProfilesPageState(
      pricingProfiles: pricingProfiles?? this.pricingProfiles,
      onProfileSelected: onProfileSelected?? this.onProfileSelected,
      onAddNewPricingProfile: onAddNewPricingProfile?? this.onAddNewPricingProfile,
    );
  }

  factory PricingProfilesPageState.initial() => PricingProfilesPageState(
    pricingProfiles: List(),
    onProfileSelected: null,
    onAddNewPricingProfile: null,
  );

  factory PricingProfilesPageState.fromStore(Store<AppState> store) {
    return PricingProfilesPageState(
      pricingProfiles: store.state.pricingProfilesPageState.pricingProfiles,
      onProfileSelected: (profile) => store.dispatch(null),
      onAddNewPricingProfile: () => store.dispatch(null),

    );
  }

  @override
  int get hashCode =>
      pricingProfiles.hashCode ^
      onProfileSelected.hashCode ^
      onAddNewPricingProfile.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PricingProfilesPageState &&
              pricingProfiles == other.pricingProfiles &&
              onProfileSelected == other.onProfileSelected &&
              onAddNewPricingProfile == other.onAddNewPricingProfile;
}