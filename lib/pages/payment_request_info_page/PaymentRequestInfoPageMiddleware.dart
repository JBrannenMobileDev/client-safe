import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../share_with_client_page/ShareWithClientActions.dart';
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
    if(action is SaveOtherInput){
      saveOtherMessage(store, next, action);
    }
    if(action is SaveWireInput){
      saveWireMessage(store, next, action);
    }
    if(action is SaveCashInput){
      saveCashMessage(store, next, action);
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
    if(action is UpdateProfileWithOtherStateAction) {
      updateOtherSelection(store, next, action);
    }
    if(action is UpdateProfileWithWireStateAction) {
      updateWireSelection(store, next, action);
    }
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SaveZelleStateAction(store.state.paymentRequestInfoPageState, profile!.zelleEnabled));
    store.dispatch(SetZellePhoneEmailTextAction(store.state.paymentRequestInfoPageState, profile.zellePhoneEmail));
    store.dispatch(SetZelleFullNameTextAction(store.state.paymentRequestInfoPageState, profile.zelleFullName));
    store.dispatch(SaveVenmoStateAction(store.state.paymentRequestInfoPageState, profile.venmoEnabled));
    store.dispatch(SetVenmoLinkTextAction(store.state.paymentRequestInfoPageState, profile.venmoLink));
    store.dispatch(SaveCashAppStateAction(store.state.paymentRequestInfoPageState, profile.cashAppEnabled));
    store.dispatch(SetCashAppLinkTextAction(store.state.paymentRequestInfoPageState, profile.cashAppLink));
    store.dispatch(SaveApplePayStateAction(store.state.paymentRequestInfoPageState, profile.applePayEnabled));
    store.dispatch(SetApplePayPhoneTextAction(store.state.paymentRequestInfoPageState, profile.applePayPhone));
    store.dispatch(SetOtherTextAction(store.state.paymentRequestInfoPageState, profile.otherMessage));
    store.dispatch(SaveOtherStateAction(store.state.paymentRequestInfoPageState, profile.otherEnabled));
    store.dispatch(SetWireTextAction(store.state.paymentRequestInfoPageState, profile.wireMessage));
    store.dispatch(SaveWireStateAction(store.state.paymentRequestInfoPageState, profile.wireEnabled));
    store.dispatch(SaveCashStateAction(store.state.paymentRequestInfoPageState, profile.cashEnabled));
    store.dispatch(SetCashTextAction(store.state.paymentRequestInfoPageState, profile.cashMessage));

  }

  void updateZelleSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithZelleStateAction action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.zelleEnabled = action.enabled;
    updateProfile(profile, store);
  }

  void updateVenmoSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithVenmoStateAction action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.venmoEnabled = action.enabled;
    updateProfile(profile, store);
  }

  void updateCashAppSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithCashAppStateAction action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.cashAppEnabled = action.enabled;
    updateProfile(profile, store);
  }

  void updateApplePaySelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithApplePayStateAction action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.applePayEnabled = action.enabled;
    updateProfile(profile, store);
  }

  void updateCashSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithCashStateAction action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.cashEnabled = action.enabled;
    updateProfile(profile, store);
  }

  void updateOtherSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithOtherStateAction action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.otherEnabled = action.enabled;
    updateProfile(profile, store);
  }

  void updateWireSelection(Store<AppState> store, NextDispatcher next, UpdateProfileWithWireStateAction action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.wireEnabled = action.enabled;
    updateProfile(profile, store);
  }

  void saveZellePhoneEmail(Store<AppState> store, NextDispatcher next, SaveZellePhoneEmailInput action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.zellePhoneEmail = action.pageState!.zellePhoneEmail;
    updateProfile(profile, store);
  }

  void saveZelleFullName(Store<AppState> store, NextDispatcher next, SaveZelleFullNameInput action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.zelleFullName = action.pageState!.zelleFullName;
    updateProfile(profile, store);
  }

  void saveVenmoInput(Store<AppState> store, NextDispatcher next, SaveVenmoInput action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.venmoLink = action.pageState!.venmoLink;
    updateProfile(profile, store);
  }

  void saveCashAppInput(Store<AppState> store, NextDispatcher next, SaveCashAppInput action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.cashAppLink = action.pageState!.cashAppLink;
    updateProfile(profile, store);
  }

  void saveApplePayPhone(Store<AppState> store, NextDispatcher next, SaveApplePayInput action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.applePayPhone = action.pageState!.applePayPhone;
    updateProfile(profile, store);
  }

  void saveOtherMessage(Store<AppState> store, NextDispatcher next, SaveOtherInput action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.otherMessage = action.pageState!.otherMessage;
    updateProfile(profile, store);
  }

  void saveWireMessage(Store<AppState> store, NextDispatcher next, SaveWireInput action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.wireMessage = action.pageState!.wireMessage;
    updateProfile(profile, store);
  }

  void saveCashMessage(Store<AppState> store, NextDispatcher next, SaveCashInput action)async{
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.cashMessage = action.pageState!.cashMessage;
    updateProfile(profile, store);
  }

  void updateProfile(Profile profile, Store<AppState> store) async {
    await ProfileDao.update(profile);
    store.dispatch(FetchProfileAction(store.state.shareWithClientPageState!));

    if(profile.paymentOptionsSelected()) {
      EventSender().setUserProfileData(EventNames.IS_PAYMENT_OPTIONS_SETUP_COMPLETE, true);
    } else {
      EventSender().setUserProfileData(EventNames.IS_PAYMENT_OPTIONS_SETUP_COMPLETE, false);
    }
  }
}