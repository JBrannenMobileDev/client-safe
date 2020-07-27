import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageState.dart';
import 'package:redux/redux.dart';

final remindersReducer = combineReducers<RemindersPageState>([
  TypedReducer<RemindersPageState, SetPricingProfilesAction>(_setPricingProfiles),
]);

RemindersPageState _setPricingProfiles(RemindersPageState previousState, SetPricingProfilesAction action){
  return previousState.copyWith(
    pricingProfiles: action.priceProfiles
  );
}
