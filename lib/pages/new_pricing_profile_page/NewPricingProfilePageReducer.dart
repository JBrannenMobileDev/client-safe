import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:redux/redux.dart';
import 'NewPricingProfilePageState.dart';

final newPricingProfilePageReducer = combineReducers<NewPricingProfilePageState>([
  TypedReducer<NewPricingProfilePageState, ClearStateAction>(_clearState),
  TypedReducer<NewPricingProfilePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewPricingProfilePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewPricingProfilePageState, UpdateErrorStateAction>(_updateErrorState),
  TypedReducer<NewPricingProfilePageState, LoadExistingPricingProfileData>(_loadPriceProfile),
  TypedReducer<NewPricingProfilePageState, SetProfileIconAction>(_setProfileIcon),
  TypedReducer<NewPricingProfilePageState, UpdateProfileNameAction>(_updateName),
  TypedReducer<NewPricingProfilePageState, UpdateProfilePriceFivesAction>(_updatePriceFives),
  TypedReducer<NewPricingProfilePageState, UpdateProfilePriceHundredsAction>(_updatePriceHundreds),
  TypedReducer<NewPricingProfilePageState, UpdateProfileLengthAction>(_updateLength),
  TypedReducer<NewPricingProfilePageState, UpdateProfileLengthInHoursAction>(_updateLengthInHours),
  TypedReducer<NewPricingProfilePageState, UpdateProfileNumberOfEditsAction>(_updateNumOfEdits),
]);

NewPricingProfilePageState _updateName(NewPricingProfilePageState previousState, UpdateProfileNameAction action){
  return previousState.copyWith(
      profileName: action.profileName,
  );
}

NewPricingProfilePageState _updatePriceFives(NewPricingProfilePageState previousState, UpdateProfilePriceFivesAction action){
  return previousState.copyWith(
    priceFives: action.priceFives,
  );
}

NewPricingProfilePageState _updatePriceHundreds(NewPricingProfilePageState previousState, UpdateProfilePriceHundredsAction action){
  return previousState.copyWith(
    priceHundreds: action.priceHundreds,
  );
}

NewPricingProfilePageState _updateLength(NewPricingProfilePageState previousState, UpdateProfileLengthAction action){
  return previousState.copyWith(
    lengthInMinutes: action.lengthInMinutes,
  );
}

NewPricingProfilePageState _updateLengthInHours(NewPricingProfilePageState previousState, UpdateProfileLengthInHoursAction action){
  return previousState.copyWith(
    lengthInHours: action.lengthInHours,
  );
}

NewPricingProfilePageState _updateNumOfEdits(NewPricingProfilePageState previousState, UpdateProfileNumberOfEditsAction action){
  return previousState.copyWith(
    numOfEdits: action.numberOfEdits,
  );
}

NewPricingProfilePageState _loadPriceProfile(NewPricingProfilePageState previousState, LoadExistingPricingProfileData action){
  return previousState.copyWith(
    id: action.profile.id,
    shouldClear: false,
    profileName: action.profile.profileName,
    profileIcon: action.profile.icon,
    priceFives: action.profile.priceFives,
    priceHundreds: action.profile.priceHundreds,
    lengthInMinutes: action.profile.timeInMin,
    lengthInHours: action.profile.timeInHours,
    numOfEdits: action.profile.numOfEdits
  );
}

NewPricingProfilePageState _updateErrorState(NewPricingProfilePageState previousState, UpdateErrorStateAction action){
  return previousState.copyWith(
      errorState: action.errorCode
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
