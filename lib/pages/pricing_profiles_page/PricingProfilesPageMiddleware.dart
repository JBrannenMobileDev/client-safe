import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';

class PricingProfilesPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchPricingProfilesAction){
      fetchProfiles(store, next);
    }
    if(action is DeletePriceProfileAction){
      _deletePricingProfile(store, action, next);
    }
  }

  void fetchProfiles(Store<AppState> store, NextDispatcher next) async{
      PriceProfileDao priceProfileDao = PriceProfileDao();
      List<PriceProfile> priceProfiles = await priceProfileDao.getAllSortedByName();
      next(SetPricingProfilesAction(store.state.pricingProfilesPageState, priceProfiles));
  }

  void _deletePricingProfile(Store<AppState> store, action, NextDispatcher next) async{
    PriceProfileDao priceProfileDao = PriceProfileDao();
    await priceProfileDao.delete(action.priceProfile);
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}