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
    if(action is UpdateProfileWithZelleStateAction) {
      updateZelleSelection(store, next, action);
    }
    if(action is UpdateProfileWithVenmoStateAction) {
      updateVenmoSelection(store, next, action);
    }
    if(action is UpdateProfileWithCashAppStateAction) {
      updateCashAppSelection(store, next, action);
    }
    if(action is UpdateProfileWithApplePayStateAction) {
      updateApplePaySelection(store, next, action);
    }
    if(action is UpdateProfileWithCashStateAction) {
      updateCashSelection(store, next, action);
    }
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SaveZelleStateAction(store.state.paymentRequestInfoPageState, profile.zelleEnabled));
    store.dispatch(SetZellePhoneEmailTextAction(store.state.paymentRequestInfoPageState, profile.zellePhoneEmail));
    store.dispatch(SetZelleFullNameTextAction(store.state.paymentRequestInfoPageState, profile.zelleFullName));
    store.dispatch(SaveVenmoStateAction(store.state.paymentRequestInfoPageState, profile.venmoEnabled));
    store.dispatch(SetVenmoLinkTextAction(store.state.paymentRequestInfoPageState, profile.venmoLink));
    store.dispatch(SaveCashAppStateAction(store.state.paymentRequestInfoPageState, profile.cashAppEnabled));
    store.dispatch(SetCashAppLinkTextAction(store.state.paymentRequestInfoPageState, profile.cashAppLink));
    store.dispatch(SaveApplePayStateAction(store.state.paymentRequestInfoPageState, profile.applePayEnabled));
    store.dispatch(SetApplePayPhoneTextAction(store.state.paymentRequestInfoPageState, profile.applePayPhone));
  }

  void updateZelleSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithZelleStateAction action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.zelleEnabled = action.enabled;
    ProfileDao.update(profile);
  }

  void updateVenmoSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithVenmoStateAction action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.venmoEnabled = action.enabled;
    ProfileDao.update(profile);
  }

  void updateCashAppSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithCashAppStateAction action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.cashAppEnabled = action.enabled;
    ProfileDao.update(profile);
  }

  void updateApplePaySelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithApplePayStateAction action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.applePayEnabled = action.enabled;
    ProfileDao.update(profile);
  }

  void updateCashSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithCashStateAction action)async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.cashEnabled = action.enabled;
    ProfileDao.update(profile);
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