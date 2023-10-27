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
  TypedReducer<NewPricingProfilePageState, UpdateDepositAmountAction>(_updateDepositAmount),
  TypedReducer<NewPricingProfilePageState, ResetPageIndexAction>(_resetPageIndex),
  TypedReducer<NewPricingProfilePageState, UpdateIncludeSalesTaxAction>(_updateIncludeSalesTax),
  TypedReducer<NewPricingProfilePageState, UpdateTaxPercentAction>(_updateTaxPercent),
]);

NewPricingProfilePageState _updateTaxPercent(NewPricingProfilePageState previousState, UpdateTaxPercentAction action){
  double percent = action.taxPercent != null ? double.parse(action.taxPercent.replaceAll('%', '')) : 0.0;
  percent = double.parse(percent.toStringAsFixed(1));
  double taxAmount = 0;
  if(action.pageState.flatRate != 0 && percent != 0) {
    taxAmount = (action.pageState.flatRate * percent) / 100;
  }
  return previousState.copyWith(
    taxPercent: percent,
    total: taxAmount + action.pageState.flatRate,
    taxAmount: taxAmount,
  );
}

NewPricingProfilePageState _updateIncludeSalesTax(NewPricingProfilePageState previousState, UpdateIncludeSalesTaxAction action){
  return previousState.copyWith(
    includeSalesTax: action.include,
  );
}

NewPricingProfilePageState _resetPageIndex(NewPricingProfilePageState previousState, ResetPageIndexAction action){
  return previousState.copyWith(
    pageViewIndex: 0,
  );
}

NewPricingProfilePageState _updateDepositAmount(NewPricingProfilePageState previousState, UpdateDepositAmountAction action){
  String resultCost = action.depositAmount.replaceAll('\$', '');
  resultCost = resultCost.replaceAll(',', '');
  resultCost = resultCost.replaceAll(' ', '');
  double doubleCost = resultCost.isNotEmpty ? double.parse(resultCost) : 0.0;
  return previousState.copyWith(
    deposit: doubleCost,
  );
}

NewPricingProfilePageState _saveRateType(NewPricingProfilePageState previousState, SaveSelectedRateTypeAction action){
  return previousState.copyWith(
    rateType: action.rateType,
  );
}

NewPricingProfilePageState _updateFlatRate(NewPricingProfilePageState previousState, UpdateFlatRateTextAction action){
  String resultCost = action.flatRateText.replaceAll('\$', '');
  resultCost = resultCost.replaceAll(',', '');
  resultCost = resultCost.replaceAll(' ', '');
  double doubleCost = resultCost.isNotEmpty ? double.parse(resultCost) : 0.0;
  double taxAmount = (doubleCost * action.pageState.taxPercent)/100;
  return previousState.copyWith(
    flatRate: doubleCost,
    taxAmount: taxAmount,
    total: (doubleCost + taxAmount),
  );
}

NewPricingProfilePageState _updateName(NewPricingProfilePageState previousState, UpdateProfileNameAction action){
  return previousState.copyWith(
      profileName: action.profileName,
  );
}

NewPricingProfilePageState _loadPriceProfile(NewPricingProfilePageState previousState, LoadExistingPricingProfileData action){
  double resultCost = action.profile.flatRate;
  double taxAmount = (resultCost * action.profile.salesTaxPercent)/100;
  return previousState.copyWith(
    id: action.profile.id,
    documentId: action.profile.documentId,
    shouldClear: false,
    profileName: action.profile.profileName,
    profileIcon: action.profile.icon,
    rateType: action.profile.rateType,
    flatRate: action.profile.flatRate,
    taxAmount: taxAmount,
    total: (resultCost + taxAmount),
    taxPercent: action.profile.salesTaxPercent,
    includeSalesTax: action.profile.includeSalesTax,
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
