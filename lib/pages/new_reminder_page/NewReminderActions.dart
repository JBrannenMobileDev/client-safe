import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageState.dart';

class LoadExistingPricingProfileData{
  final NewReminderPageState pageState;
  final PriceProfile profile;
  LoadExistingPricingProfileData(this.pageState, this.profile);
}

class SavePricingProfileAction{
  final NewReminderPageState pageState;
  SavePricingProfileAction(this.pageState);
}

class SetProfileIconAction{
  final NewReminderPageState pageState;
  final String profileIcon;
  SetProfileIconAction(this.pageState, this.profileIcon);
}

class ClearStateAction{
  final NewReminderPageState pageState;
  ClearStateAction(this.pageState);
}

class DeletePriceProfileAction{
  final NewReminderPageState pageState;
  DeletePriceProfileAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewReminderPageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewReminderPageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class UpdateProfileNameAction{
  final NewReminderPageState pageState;
  final String profileName;
  UpdateProfileNameAction(this.pageState, this.profileName);
}

class SaveSelectedRateTypeAction{
  final NewReminderPageState pageState;
  final String rateType;
  SaveSelectedRateTypeAction(this.pageState, this.rateType);
}

class UpdateFlatRateTextAction{
  final NewReminderPageState pageState;
  final String flatRateText;
  UpdateFlatRateTextAction(this.pageState, this.flatRateText);
}

class UpdateHourlyRateTextAction{
  final NewReminderPageState pageState;
  final String hourlyRateText;
  UpdateHourlyRateTextAction(this.pageState, this.hourlyRateText);
}

class UpdateItemRateTextAction{
  final NewReminderPageState pageState;
  final String itemRateText;
  UpdateItemRateTextAction(this.pageState, this.itemRateText);
}





