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

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';

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
      documentId: store.state.pricingProfilePageState.documentId,
      profileName: store.state.pricingProfilePageState.profileName,
      flatRate: store.state.pricingProfilePageState.flatRate.toDouble(),
      icon: ImageUtil.getRandomPriceProfileIcon(),
      deposit: store.state.pricingProfilePageState.deposit != null ? store.state.pricingProfilePageState.deposit.toDouble() : 0,
    );
    await PriceProfileDao.insertOrUpdate(priceProfile);
    EventSender().sendEvent(eventName: EventNames.CREATED_PRICE_PACKAGE, properties: {
      EventNames.PRICE_PACKAGE_PARAM_NAME : priceProfile.profileName,
      EventNames.PRICE_PACKAGE_PARAM_PRICE : priceProfile.flatRate,
      EventNames.PRICE_PACKAGE_PARAM_DEPOSIT : priceProfile.deposit,
    });
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    PriceProfile newProfileWithDocumentId = await PriceProfileDao.getByNameAndPrice(priceProfile.profileName, priceProfile.flatRate);
    store.dispatch(prefix0.UpdateWithNewPricePackageAction(store.state.newJobPageState, newProfileWithDocumentId));
    store.dispatch(ClearStateAction(store.state.pricingProfilePageState));
  }

  void _deletePricingProfile(Store<AppState> store, action, NextDispatcher next) async{
    await PriceProfileDao.delete(PriceProfile(id: store.state.pricingProfilePageState.id, documentId: store.state.pricingProfilePageState.documentId));
    store.dispatch(FetchPricingProfilesAction(store.state.pricingProfilesPageState));
    store.dispatch(ClearStateAction(store.state.pricingProfilePageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}