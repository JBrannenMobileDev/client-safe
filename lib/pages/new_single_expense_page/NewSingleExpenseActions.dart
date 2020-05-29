import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_single_expense_page/NewSingleExpensePageState.dart';

class LoadExistingPricingProfileData{
  final NewSingleExpensePageState pageState;
  final PriceProfile profile;
  LoadExistingPricingProfileData(this.pageState, this.profile);
}

class SavePricingProfileAction{
  final NewSingleExpensePageState pageState;
  SavePricingProfileAction(this.pageState);
}

class SetProfileIconAction{
  final NewSingleExpensePageState pageState;
  final String profileIcon;
  SetProfileIconAction(this.pageState, this.profileIcon);
}

class ClearStateAction{
  final NewSingleExpensePageState pageState;
  ClearStateAction(this.pageState);
}

class DeletePriceProfileAction{
  final NewSingleExpensePageState pageState;
  DeletePriceProfileAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewSingleExpensePageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewSingleExpensePageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class UpdateProfileNameAction{
  final NewSingleExpensePageState pageState;
  final String profileName;
  UpdateProfileNameAction(this.pageState, this.profileName);
}

class SaveSelectedRateTypeAction{
  final NewSingleExpensePageState pageState;
  final String rateType;
  SaveSelectedRateTypeAction(this.pageState, this.rateType);
}

class UpdateFlatRateTextAction{
  final NewSingleExpensePageState pageState;
  final String flatRateText;
  UpdateFlatRateTextAction(this.pageState, this.flatRateText);
}

class UpdateHourlyRateTextAction{
  final NewSingleExpensePageState pageState;
  final String hourlyRateText;
  UpdateHourlyRateTextAction(this.pageState, this.hourlyRateText);
}

class UpdateItemRateTextAction{
  final NewSingleExpensePageState pageState;
  final String itemRateText;
  UpdateItemRateTextAction(this.pageState, this.itemRateText);
}





