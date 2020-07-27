import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:redux/redux.dart';
import 'NewReminderPageState.dart';

final newReminderPageReducer = combineReducers<NewReminderPageState>([
  TypedReducer<NewReminderPageState, SaveSelectedRateTypeAction>(_saveRateType),
  TypedReducer<NewReminderPageState, UpdateItemRateTextAction>(_updateItemRate),
]);

NewReminderPageState _saveRateType(NewReminderPageState previousState, SaveSelectedRateTypeAction action){
  return previousState.copyWith(
    rateType: action.rateType,
  );
}

NewReminderPageState _updateItemRate(NewReminderPageState previousState, UpdateItemRateTextAction action){
  String itemRate = action.itemRateText.replaceFirst(r'$', '');
  return previousState.copyWith(
    itemRate: double.parse(itemRate),
    hourlyRate: itemRate.length > 0 ? 0 : previousState.hourlyRate,
    flatRate: itemRate.length > 0 ? 0 : previousState.flatRate,
  );
}