import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageState.dart';

class LoadExistingPricingProfileData{
  final NewPricingProfilePageState pageState;
  final PriceProfile profile;
  LoadExistingPricingProfileData(this.pageState, this.profile);
}

class SavePricingProfileAction{
  final NewPricingProfilePageState pageState;
  SavePricingProfileAction(this.pageState);
}

class InitializeProfileSettings {
  final NewPricingProfilePageState pageState;
  InitializeProfileSettings(this.pageState);
}

class SetProfileIconAction{
  final NewPricingProfilePageState pageState;
  final String profileIcon;
  SetProfileIconAction(this.pageState, this.profileIcon);
}

class ClearStateAction{
  final NewPricingProfilePageState pageState;
  ClearStateAction(this.pageState);
}

class ResetPageIndexAction{
  final NewPricingProfilePageState pageState;
  ResetPageIndexAction(this.pageState);
}

class DeletePriceProfileAction{
  final NewPricingProfilePageState pageState;
  DeletePriceProfileAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewPricingProfilePageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewPricingProfilePageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class UpdateProfileNameAction{
  final NewPricingProfilePageState pageState;
  final String profileName;
  UpdateProfileNameAction(this.pageState, this.profileName);
}

class SaveSelectedRateTypeAction{
  final NewPricingProfilePageState pageState;
  final String rateType;
  SaveSelectedRateTypeAction(this.pageState, this.rateType);
}

class UpdateFlatRateTextAction{
  final NewPricingProfilePageState pageState;
  final String flatRateText;
  UpdateFlatRateTextAction(this.pageState, this.flatRateText);
}

class UpdateDepositAmountAction{
  final NewPricingProfilePageState pageState;
  final String depositAmount;
  UpdateDepositAmountAction(this.pageState, this.depositAmount);
}

class UpdateHourlyRateTextAction{
  final NewPricingProfilePageState pageState;
  final String hourlyRateText;
  UpdateHourlyRateTextAction(this.pageState, this.hourlyRateText);
}

class UpdateItemRateTextAction{
  final NewPricingProfilePageState pageState;
  final String itemRateText;
  UpdateItemRateTextAction(this.pageState, this.itemRateText);
}

class UpdateIncludeSalesTaxAction {
  final NewPricingProfilePageState pageState;
  final bool include;
  UpdateIncludeSalesTaxAction(this.pageState, this.include);
}

class UpdateTaxPercentAction {
  final NewPricingProfilePageState pageState;
  final String taxPercent;
  UpdateTaxPercentAction(this.pageState, this.taxPercent);
}





