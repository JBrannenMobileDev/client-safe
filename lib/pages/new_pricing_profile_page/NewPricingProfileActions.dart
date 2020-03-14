import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';

class LoadExistingPricingProfileData{
  final NewPricingProfilePageState pageState;
  final PriceProfile profile;
  LoadExistingPricingProfileData(this.pageState, this.profile);
}

class SavePricingProfileAction{
  final NewPricingProfilePageState pageState;
  SavePricingProfileAction(this.pageState);
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





