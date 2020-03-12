import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
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
  TypedReducer<NewPricingProfilePageState, UpdateHourlyQuantityTextAction>(_updateHourlyQuantity),
  TypedReducer<NewPricingProfilePageState, UpdateItemRateTextAction>(_updateItemRate),
  TypedReducer<NewPricingProfilePageState, UpdateItemQuantityTextAction>(_updateItemQuantity),
]);

NewPricingProfilePageState _saveRateType(NewPricingProfilePageState previousState, SaveSelectedRateTypeAction action){
  return previousState.copyWith(
    rateType: action.rateType,
  );
}

NewPricingProfilePageState _updateItemQuantity(NewPricingProfilePageState previousState, UpdateItemQuantityTextAction action){
  action.itemQuantityText.replaceFirst('\$', '');
  return previousState.copyWith(
    itemQuantity: int.parse(action.itemQuantityText),
  );
}

NewPricingProfilePageState _updateItemRate(NewPricingProfilePageState previousState, UpdateItemRateTextAction action){
  return previousState.copyWith(
    itemRate: double.parse(action.itemRateText),
  );
}

NewPricingProfilePageState _updateHourlyQuantity(NewPricingProfilePageState previousState, UpdateHourlyQuantityTextAction action){
  return previousState.copyWith(
    hourlyQuantity: int.parse(action.hourlyQuantityText),
  );
}

NewPricingProfilePageState _updateHourlyRate(NewPricingProfilePageState previousState, UpdateHourlyRateTextAction action){
  return previousState.copyWith(
    hourlyRate: double.parse(action.hourlyRateText),
  );
}

NewPricingProfilePageState _updateFlatRate(NewPricingProfilePageState previousState, UpdateFlatRateTextAction action){
  String flatRate = action.flatRateText.replaceFirst(r'$', '');
  return previousState.copyWith(
    flatRate: double.parse(flatRate),
  );
}

NewPricingProfilePageState _updateName(NewPricingProfilePageState previousState, UpdateProfileNameAction action){
  return previousState.copyWith(
      profileName: action.profileName,
  );
}

NewPricingProfilePageState _loadPriceProfile(NewPricingProfilePageState previousState, LoadExistingPricingProfileData action){
  return previousState.copyWith(
    id: action.profile.id,
    shouldClear: false,
    profileName: action.profile.profileName,
    profileIcon: action.profile.icon,
    rateType: action.profile.rateType,
    flatRate: action.profile.flatRate,
    hourlyRate: action.profile.hourlyRate,
    hourlyQuantity: action.profile.hourlyQuantity,
    itemQuantity: action.profile.itemQuantity,
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
