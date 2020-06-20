import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageState.dart';

class FetchPricingProfilesAction{
  final PricingProfilesPageState pageState;
  FetchPricingProfilesAction(this.pageState);
}

class SetPricingProfilesAction{
  final PricingProfilesPageState pageState;
  final List<PriceProfile> priceProfiles;
  SetPricingProfilesAction(this.pageState, this.priceProfiles);
}

class DeletePriceProfileAction{
  final PricingProfilesPageState pageState;
  final PriceProfile priceProfile;
  DeletePriceProfileAction(this.pageState, this.priceProfile);
}

