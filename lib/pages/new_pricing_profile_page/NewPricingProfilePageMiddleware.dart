import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart' as prefix0;
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart' as prefix1;
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:client_safe/utils/ImageUtil.dart';
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
      icon: store.state.pricingProfilePageState.profileIcon != null
          ? store.state.pricingProfilePageState.profileIcon : ImageUtil.getDefaultPricingProfileIcon(),
    );
    await PriceProfileDao.insertOrUpdate(priceProfile);
    store.dispatch(ClearStateAction(store.state.pricingProfilePageState));
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    store.dispatch(prefix0.FetchAllClientsAction(store.state.newJobPageState));
  }

  void _deletePricingProfile(Store<AppState> store, action, NextDispatcher next) async{
    await PriceProfileDao.delete(PriceProfile());
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}