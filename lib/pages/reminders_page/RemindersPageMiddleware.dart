import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/PriceProfileDao.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

class RemindersPageMiddleware extends MiddlewareClass<AppState> {

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
      List<PriceProfile> priceProfiles = await PriceProfileDao.getAllSortedByName();
      next(SetPricingProfilesAction(store.state.pricingProfilesPageState, priceProfiles));

      (await PriceProfileDao.getPriceProfilesStream()).listen((snapshots) async {
        List<PriceProfile> priceProfilesToUpdate = List();
        for(RecordSnapshot clientSnapshot in snapshots) {
          priceProfilesToUpdate.add(PriceProfile.fromMap(clientSnapshot.value));
        }
        store.dispatch(SetPricingProfilesAction(store.state.pricingProfilesPageState, priceProfilesToUpdate));
      });
  }

  void _deletePricingProfile(Store<AppState> store, action, NextDispatcher next) async{
    await PriceProfileDao.delete(action.priceProfile);
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}