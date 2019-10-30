import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';

class LoadExistingPricingProfileData{
  final NewPricingProfilePageState pageState;
  final PriceProfile profile;
  LoadExistingPricingProfileData(this.pageState, this.profile);
}

class SavePricingProfileAction{
  final NewPricingProfilePageState pageState;
  SavePricingProfileAction(this.pageState);
}

class UpdateErrorStateAction{
  final NewPricingProfilePageState pageState;
  final String errorCode;
  UpdateErrorStateAction(this.pageState, this.errorCode);
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
  final PriceProfile priceProfile;
  DeletePriceProfileAction(this.pageState, this.priceProfile);
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

class UpdateProfileLengthAction{
  final NewPricingProfilePageState pageState;
  final int lengthInMinutes;
  UpdateProfileLengthAction(this.pageState, this.lengthInMinutes);
}

class UpdateProfileLengthInHoursAction{
  final NewPricingProfilePageState pageState;
  final int lengthInHours;
  UpdateProfileLengthInHoursAction(this.pageState, this.lengthInHours);
}

class UpdateProfileNumberOfEditsAction{
  final NewPricingProfilePageState pageState;
  final int numberOfEdits;
  UpdateProfileNumberOfEditsAction(this.pageState, this.numberOfEdits);
}

class UpdateProfilePriceFivesAction{
  final NewPricingProfilePageState pageState;
  final int priceFives;
  UpdateProfilePriceFivesAction(this.pageState, this.priceFives);
}

class UpdateProfilePriceHundredsAction{
  final NewPricingProfilePageState pageState;
  final int priceHundreds;
  UpdateProfilePriceHundredsAction(this.pageState, this.priceHundreds);
}




