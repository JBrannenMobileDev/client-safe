import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:client_safe/pages/new_single_expense_page/NewSingleExpensePageState.dart';
import 'package:redux/redux.dart';
import 'NewSingleExpensePageState.dart';

final newSingleExpensePageReducer = combineReducers<NewSingleExpensePageState>([
  TypedReducer<NewSingleExpensePageState, ClearStateAction>(_clearState),
  TypedReducer<NewSingleExpensePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewSingleExpensePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewSingleExpensePageState, LoadExistingPricingProfileData>(_loadPriceProfile),
  TypedReducer<NewSingleExpensePageState, SetProfileIconAction>(_setProfileIcon),
  TypedReducer<NewSingleExpensePageState, UpdateProfileNameAction>(_updateName),
  TypedReducer<NewSingleExpensePageState, SaveSelectedRateTypeAction>(_saveRateType),
  TypedReducer<NewSingleExpensePageState, UpdateFlatRateTextAction>(_updateFlatRate),
  TypedReducer<NewSingleExpensePageState, UpdateHourlyRateTextAction>(_updateHourlyRate),
  TypedReducer<NewSingleExpensePageState, UpdateItemRateTextAction>(_updateItemRate),
]);

NewSingleExpensePageState _saveRateType(NewSingleExpensePageState previousState, SaveSelectedRateTypeAction action){
  return previousState.copyWith(
    rateType: action.rateType,
  );
}

NewSingleExpensePageState _updateItemRate(NewSingleExpensePageState previousState, UpdateItemRateTextAction action){
  String itemRate = action.itemRateText.replaceFirst(r'$', '');
  return previousState.copyWith(
    itemRate: double.parse(itemRate),
    hourlyRate: itemRate.length > 0 ? 0 : previousState.hourlyRate,
    flatRate: itemRate.length > 0 ? 0 : previousState.flatRate,
  );
}

NewSingleExpensePageState _updateHourlyRate(NewSingleExpensePageState previousState, UpdateHourlyRateTextAction action){
  String hourlyRate = action.hourlyRateText.replaceFirst(r'$', '');
  return previousState.copyWith(
    hourlyRate: double.parse(hourlyRate),
    itemRate: hourlyRate.length > 0 ? 0 : previousState.itemRate,
    flatRate: hourlyRate.length > 0 ? 0 : previousState.flatRate,
  );
}

NewSingleExpensePageState _updateFlatRate(NewSingleExpensePageState previousState, UpdateFlatRateTextAction action){
  String flatRate = action.flatRateText.replaceFirst(r'$', '');
  return previousState.copyWith(
    flatRate: double.parse(flatRate),
    itemRate: flatRate.length > 0 ? 0 : previousState.itemRate,
    hourlyRate: flatRate.length > 0 ? 0 : previousState.hourlyRate,
  );
}

NewSingleExpensePageState _updateName(NewSingleExpensePageState previousState, UpdateProfileNameAction action){
  return previousState.copyWith(
      profileName: action.profileName,
  );
}

NewSingleExpensePageState _loadPriceProfile(NewSingleExpensePageState previousState, LoadExistingPricingProfileData action){
  return previousState.copyWith(
    id: action.profile.id,
    shouldClear: false,
    profileName: action.profile.profileName,
    profileIcon: action.profile.icon,
    rateType: action.profile.rateType,
    flatRate: action.profile.flatRate,
    hourlyRate: action.profile.hourlyRate,
    itemRate: action.profile.itemRate,
  );
}

NewSingleExpensePageState _setProfileIcon(NewSingleExpensePageState previousState, SetProfileIconAction action){
  return previousState.copyWith(
    profileIcon: action.profileIcon,
  );
}

NewSingleExpensePageState _incrementPageViewIndex(NewSingleExpensePageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewSingleExpensePageState _decrementPageViewIndex(NewSingleExpensePageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewSingleExpensePageState _clearState(NewSingleExpensePageState previousState, ClearStateAction action) {
  return NewSingleExpensePageState.initial();
}
