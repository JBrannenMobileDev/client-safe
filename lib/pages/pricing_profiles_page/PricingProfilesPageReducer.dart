import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:redux/redux.dart';

final pricingProfilesReducer = combineReducers<PricingProfilesPageState>([
  TypedReducer<PricingProfilesPageState, SetPricingProfilesAction>(_setPricingProfiles),
]);

PricingProfilesPageState _setPricingProfiles(PricingProfilesPageState previousState, SetPricingProfilesAction action){
  return previousState.copyWith(
    pricingProfiles: action.priceProfiles
  );
}
