import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class PricingProfilesPageState{

  final List<PriceProfile> pricingProfiles;
  final Function(PriceProfile) onProfileSelected;
  final Function(PriceProfile) onDeleteProfileSelected;

  PricingProfilesPageState({
    @required this.pricingProfiles,
    @required this.onProfileSelected,
    @required this.onDeleteProfileSelected,
  });

  PricingProfilesPageState copyWith({
    List<PriceProfile> pricingProfiles,
    Function(int) onProfileSelected,
    Function(PriceProfile) onDeleteProfileSelected,
  }){
    return PricingProfilesPageState(
      pricingProfiles: pricingProfiles?? this.pricingProfiles,
      onProfileSelected: onProfileSelected?? this.onProfileSelected,
      onDeleteProfileSelected: onDeleteProfileSelected?? this.onDeleteProfileSelected,
    );
  }

  factory PricingProfilesPageState.initial() => PricingProfilesPageState(
    pricingProfiles: List(),
    onProfileSelected: null,
    onDeleteProfileSelected: null,
  );

  factory PricingProfilesPageState.fromStore(Store<AppState> store) {
    return PricingProfilesPageState(
      pricingProfiles: store.state.pricingProfilesPageState.pricingProfiles,
      onProfileSelected: (profile) => store.dispatch(LoadExistingPricingProfileData(store.state.pricingProfilePageState, profile)),
      onDeleteProfileSelected: (priceProfile) => store.dispatch(prefix0.DeletePriceProfileAction(store.state.pricingProfilesPageState, priceProfile)),
    );
  }

  @override
  int get hashCode =>
      pricingProfiles.hashCode ^
      onProfileSelected.hashCode ^
      onDeleteProfileSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PricingProfilesPageState &&
              pricingProfiles == other.pricingProfiles &&
              onProfileSelected == other.onProfileSelected &&
              onDeleteProfileSelected == other.onDeleteProfileSelected;
}