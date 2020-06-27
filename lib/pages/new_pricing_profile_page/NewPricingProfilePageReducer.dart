import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:redux/redux.dart';
import 'NewPricingProfilePageState.dart';

final newPricingProfilePageReducer = combineReducers<NewPricingProfilePageState>([
  TypedReducer<NewPricingProfilePageState, ClearStateAction>(_clearState),
  TypedReducer<NewPricingProfilePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewPricingProfilePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewPricingProfilePageState, LoadExistingPricingProfileData>(_loadPriceProfile),
  TypedReducer<NewPricingProfilePageState, SetProfileIconAction>(_setProfileIcon),
  TypedReducer<NewPricingProfilePageState, UpdateProfileNameAction>(_updateName),
  TypedReducer<NewPricingProfilePageState, SaveSelectedRateTypeAction>(_saveRateType),
  TypedReducer<NewPricingProfilePageState, UpdateFlatRateTextAction>(_updateFlatRate),
  TypedReducer<NewPricingProfilePageState, UpdateHourlyRateTextAction>(_updateHourlyRate),
  TypedReducer<NewPricingProfilePageState, UpdateItemRateTextAction>(_updateItemRate),
]);

NewPricingProfilePageState _saveRateType(NewPricingProfilePageState previousState, SaveSelectedRateTypeAction action){
  return previousState.copyWith(
    rateType: action.rateType,
  );
}

NewPricingProfilePageState _updateItemRate(NewPricingProfilePageState previousState, UpdateItemRateTextAction action){
  String itemRate = action.itemRateText.replaceFirst(r'$', '');
  return previousState.copyWith(
    itemRate: double.parse(itemRate),
    hourlyRate: itemRate.length > 0 ? 0 : previousState.hourlyRate,
    flatRate: itemRate.length > 0 ? 0 : previousState.flatRate,
  );
}

NewPricingProfilePageState _updateHourlyRate(NewPricingProfilePageState previousState, UpdateHourlyRateTextAction action){
  String hourlyRate = action.hourlyRateText.replaceFirst(r'$', '');
  return previousState.copyWith(
    hourlyRate: double.parse(hourlyRate),
    itemRate: hourlyRate.length > 0 ? 0 : previousState.itemRate,
    flatRate: hourlyRate.length > 0 ? 0 : previousState.flatRate,
  );
}

NewPricingProfilePageState _updateFlatRate(NewPricingProfilePageState previousState, UpdateFlatRateTextAction action){
  String flatRate = action.flatRateText.replaceFirst(r'$', '');
  return previousState.copyWith(
    flatRate: double.parse(flatRate),
    itemRate: flatRate.length > 0 ? 0 : previousState.itemRate,
    hourlyRate: flatRate.length > 0 ? 0 : previousState.hourlyRate,
  );
}

NewPricingProfilePageState _updateName(NewPricingProfilePageState previousState, UpdateProfileNameAction action){
  return previousState.copyWith(
      profileName: action.profileName,
  );
}

NewPricingProfilePageState _loadPriceProfile(NewPricingProfilePageState previousState, LoadExistingPricingProfileData action){
  return previousState.copyWith(
    documentId: action.profile.documentId,
    shouldClear: false,
    profileName: action.profile.profileName,
    profileIcon: action.profile.icon,
    rateType: action.profile.rateType,
    flatRate: action.profile.flatRate,
    hourlyRate: action.profile.hourlyRate,
    itemRate: action.profile.itemRate,
  );
}

NewPricingProfilePageState _setProfileIcon(NewPricingProfilePageState previousState, SetProfileIconAction action){
  return previousState.copyWith(
    profileIcon: action.profileIcon,
  );
}

NewPricingProfilePageState _incrementPageViewIndex(NewPricingProfilePageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewPricingProfilePageState _decrementPageViewIndex(NewPricingProfilePageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewPricingProfilePageState _clearState(NewPricingProfilePageState previousState, ClearStateAction action) {
  return NewPricingProfilePageState.initial();
}
