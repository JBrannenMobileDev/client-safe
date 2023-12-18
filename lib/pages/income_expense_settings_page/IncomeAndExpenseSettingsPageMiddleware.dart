import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:pdf/widgets.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/JobDao.dart';
import '../../models/Job.dart';
import '../../models/JobStage.dart';
import '../../models/RecurringExpense.dart';
import '../../utils/PdfUtil.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import 'IncomeAndExpenseSettingsPageActions.dart';


class IncomeAndExpenseSettingsPageMiddleware extends MiddlewareClass<AppState> {

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
    if(action is LoadIncomeExpenseReportsAction) {
      loadIncomeAndExpenseReportsAction(store, next, action);
    }
    if(action is LoadMileageReportsAction) {
      loadMileageReportsAction(store, next, action);
    }
    if(action is GenerateIncomeExpenseReportAction) {
      _generateIncomeExpenseReport(store, action, next);
    }
    if(action is GenerateMileageReportAction) {
      _generateMileageReport(store, action, next);
    }
  }

  void _generateMileageReport(Store<AppState> store, GenerateMileageReportAction action, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    Document pdf = await PdfUtil.generateMileageReport(profile, action.report);
    IntentLauncherUtil.downloadWeb(await pdf.save(), downloadName: 'MileageReport_${action.report.year}.pdf');
  }

  void _generateIncomeExpenseReport(Store<AppState> store, GenerateIncomeExpenseReportAction action, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    Document pdf = await PdfUtil.generateIncomeAndExpenses(profile, action.report);
    IntentLauncherUtil.sharePdfMobile(pdf, 'IncomeExpenseReport_${action.report.year}.pdf');
  }

  void loadIncomeAndExpenseReportsAction(Store<AppState> store, NextDispatcher next, LoadIncomeExpenseReportsAction action)async{
    List<Job> allJobs = await JobDao.getAllJobs();
    List<SingleExpense> singleExpenses = await SingleExpenseDao.getAll();
    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();
    store.dispatch(BuildIncomeExpenseReportAction(store.state.incomeAndExpenseSettingsPageState, allJobs, singleExpenses, recurringExpenses));
  }

  void loadMileageReportsAction(Store<AppState> store, NextDispatcher next, LoadMileageReportsAction action)async{
    List<MileageExpense> mileageExpenses = await MileageExpenseDao.getAll();
    store.dispatch(BuildMileageReportAction(store.state.incomeAndExpenseSettingsPageState, mileageExpenses));
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SaveZelleStateAction(store.state.incomeAndExpenseSettingsPageState, !(profile.zellePhoneEmail?.isEmpty == true && profile.zelleFullName?.isEmpty == true)));
    store.dispatch(SetZellePhoneEmailTextAction(store.state.incomeAndExpenseSettingsPageState, profile.zellePhoneEmail));
    store.dispatch(SetZelleFullNameTextAction(store.state.incomeAndExpenseSettingsPageState, profile.zelleFullName));
    store.dispatch(SaveVenmoStateAction(store.state.incomeAndExpenseSettingsPageState, profile.venmoLink?.isNotEmpty));
    store.dispatch(SetVenmoLinkTextAction(store.state.incomeAndExpenseSettingsPageState, profile.venmoLink));
    store.dispatch(SaveCashAppStateAction(store.state.incomeAndExpenseSettingsPageState, profile.cashAppLink?.isNotEmpty));
    store.dispatch(SetCashAppLinkTextAction(store.state.incomeAndExpenseSettingsPageState, profile.cashAppLink));
    store.dispatch(SaveApplePayStateAction(store.state.incomeAndExpenseSettingsPageState, profile.venmoLink?.isNotEmpty));
    store.dispatch(SetApplePayPhoneTextAction(store.state.incomeAndExpenseSettingsPageState, profile.applePayPhone));
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