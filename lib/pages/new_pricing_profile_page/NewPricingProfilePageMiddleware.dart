import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileActions.dart' as prefix0;
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
    if(action is prefix0.DeletePriceProfileAction){
      _deletePricingProfile(store, action, next);
    }
  }

  void saveProfile(Store<AppState> store, action, NextDispatcher next) async{
    PriceProfileDao priceProfileDao = PriceProfileDao();
    PriceProfile priceProfile = PriceProfile(
      id: store.state.pricingProfilePageState.id,
      profileName: store.state.pricingProfilePageState.profileName,
      priceFives: store.state.pricingProfilePageState.priceFives,
      priceHundreds: store.state.pricingProfilePageState.priceHundreds,
      timeInMin: store.state.pricingProfilePageState.lengthInMinutes,
      timeInHours: store.state.pricingProfilePageState.lengthInHours,
      numOfEdits: store.state.pricingProfilePageState.numOfEdits,
      icon: store.state.pricingProfilePageState.profileIcon != null
          ? store.state.pricingProfilePageState.profileIcon : ImageUtil.getDefaultPricingProfileIcon(),
    );
    await priceProfileDao.insertOrUpdate(priceProfile);
    store.dispatch(ClearStateAction(store.state.pricingProfilePageState));
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
  }

  void _deletePricingProfile(Store<AppState> store, action, NextDispatcher next) async{
    PriceProfileDao priceProfileDao = PriceProfileDao();
    await priceProfileDao.delete(action.priceProfile);
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}