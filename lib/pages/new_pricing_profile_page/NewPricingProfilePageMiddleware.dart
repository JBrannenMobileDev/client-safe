import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart' as prefix0;
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart' as prefix1;
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:redux/redux.dart';

class NewPricingProfilePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SavePricingProfileAction){
      saveProfile(store, action, next);
    }
    if(action is prefix1.DeletePriceProfileAction){
      _deletePricingProfile(store, action, next);
    }
  }

  void saveProfile(Store<AppState> store, action, NextDispatcher next) async{
    PriceProfile priceProfile = PriceProfile(
      id: store.state.pricingProfilePageState.id,
      profileName: store.state.pricingProfilePageState.profileName,
      rateType: store.state.pricingProfilePageState.rateType,
      flatRate: store.state.pricingProfilePageState.flatRate,
      hourlyRate: store.state.pricingProfilePageState.hourlyRate,
      itemRate: store.state.pricingProfilePageState.itemRate,
      icon: store.state.pricingProfilePageState.profileIcon != null
          ? store.state.pricingProfilePageState.profileIcon : ImageUtil.getDefaultPricingProfileIcon(),
    );
    await PriceProfileDao.insertOrUpdate(priceProfile);
    store.dispatch(ClearStateAction(store.state.pricingProfilePageState));
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    store.dispatch(prefix0.FetchAllClientsAction(store.state.newJobPageState));
  }

  void _deletePricingProfile(Store<AppState> store, action, NextDispatcher next) async{
    await PriceProfileDao.delete(PriceProfile(id: store.state.pricingProfilePageState.id));
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}