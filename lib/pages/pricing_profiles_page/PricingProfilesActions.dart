import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';

class FetchPricingProfilesAction{
  final PricingProfilesPageState pageState;
  FetchPricingProfilesAction(this.pageState);
}

class SetPricingProfilesAction{
  final PricingProfilesPageState pageState;
  final List<PriceProfile> priceProfiles;
  SetPricingProfilesAction(this.pageState, this.priceProfiles);
}

