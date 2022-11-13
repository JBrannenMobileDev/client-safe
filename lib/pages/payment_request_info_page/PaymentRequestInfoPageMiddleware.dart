import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';

import 'PaymentRequestInfoPageActions.dart';

class PaymentRequestInfoPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadPaymentSettingsFromProfile){
      loadSettings(store, next);
    }
    if(action is SaveZelleFullNameInput){
      saveZelleFullName(store, next, action);
    }
    if(action is SaveZellePhoneEmailInput){
      saveZellePhoneEmail(store, next, action);
    }
    if(action is SaveVenmoInput){
      saveVenmoInput(store, next, action);
    }
    if(action is SaveCashAppInput){
      saveCashAppInput(store, next, action);
    }
    if(action is SaveApplePayInput){
      saveApplePayPhone(store, next, action);
    }
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SaveZelleStateAction(store.state.paymentRequestInfoPageState, !(profile.zellePhoneEmail.isEmpty && profile.zelleFullName.isEmpty)));
    store.dispatch(SetZellePhoneEmailTextAction(store.state.paymentRequestInfoPageState, profile.zellePhoneEmail));
    store.dispatch(SetZelleFullNameTextAction(store.state.paymentRequestInfoPageState, profile.zelleFullName));
    store.dispatch(SaveVenmoStateAction(store.state.paymentRequestInfoPageState, profile.venmoLink.isNotEmpty));
    store.dispatch(SetVenmoLinkTextAction(store.state.paymentRequestInfoPageState, profile.venmoLink));
    store.dispatch(SaveCashAppStateAction(store.state.paymentRequestInfoPageState, profile.cashAppLink.isNotEmpty));
    store.dispatch(SetCashAppLinkTextAction(store.state.paymentRequestInfoPageState, profile.cashAppLink));
    store.dispatch(SaveApplePayStateAction(store.state.paymentRequestInfoPageState, profile.venmoLink.isNotEmpty));
    store.dispatch(SetApplePayPhoneTextAction(store.state.paymentRequestInfoPageState, profile.applePayPhone));
  }

  void saveZellePhoneEmail(Store<AppState> store, NextDispatcher next, SaveZellePhoneEmailInput action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.zellePhoneEmail = action.pageState.zellePhoneEmail;
    ProfileDao.update(profile);
  }

  void saveZelleFullName(Store<AppState> store, NextDispatcher next, SaveZelleFullNameInput action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.zelleFullName = action.pageState.zelleFullName;
    ProfileDao.update(profile);
  }

  void saveVenmoInput(Store<AppState> store, NextDispatcher next, SaveVenmoInput action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.venmoLink = action.pageState.venmoLink;
    ProfileDao.update(profile);
  }

  void saveCashAppInput(Store<AppState> store, NextDispatcher next, SaveCashAppInput action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.cashAppLink = action.pageState.cashAppLink;
    ProfileDao.update(profile);
  }

  void saveApplePayPhone(Store<AppState> store, NextDispatcher next, SaveApplePayInput action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.applePayPhone = action.pageState.applePayPhone;
    ProfileDao.update(profile);
  }
}