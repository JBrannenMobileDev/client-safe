import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:redux/redux.dart';

class IncomeAndExpensePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadAllInvoicesAction){
      fetchInvoices(store, next);
    }
    if(action is LoadAllJobsAction){
      fetchJobs(store, next);
    }
    if(action is InvoiceEditSelected){
      onEditInvoice(store, action, next);
    }
    if(action is DeleteInvoiceAction){
      deleteInvoice(store, action, next);
    }
    if(action is OnInvoiceSentAction){
      updateInvoiceToSent(store, action, next);
    }
    if(action is SaveTipIncomeChangeAction){
      _updateJobTip(store, action, next);
    }
    if(action is FetchSingleExpenses){
      _fetchSingleExpenses(store, action, next);
    }
    if(action is FetchRecurringExpenses){
      _fetchRecurringExpenses(store, action, next);
    }
    if(action is UpdateSelectedRecurringChargeAction){
      _updateRecurringExpenseCharge(store, action, next);
    }
    if(action is SaveCancelledSubscriptionAction){
      _updateRecurringExpenseChargeCancelDate(store, action, next);
    }
    if(action is SaveResumedSubscriptionAction){
      _updateRecurringExpenseChargeResumeDate(store, action, next);
    }
    if(action is FetchMileageExpenses){
      _fetchMileageExpenses(store, action, next);
    }
  }

  void _updateRecurringExpenseChargeCancelDate(Store<AppState> store, SaveCancelledSubscriptionAction action, NextDispatcher next) async{
    action.expense.cancelDate = DateTime.now();
    action.expense.resumeDate = null;
    await RecurringExpenseDao.insertOrUpdate(action.expense);

    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();
    _updateSaveAndSetRecurringExpenses(store, recurringExpenses);
  }

  void _updateRecurringExpenseChargeResumeDate(Store<AppState> store, SaveResumedSubscriptionAction action, NextDispatcher next) async{
    action.expense.resumeDate = DateTime.now();
    action.expense.cancelDate = null;
    await RecurringExpenseDao.insertOrUpdate(action.expense);

    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();
    _updateSaveAndSetRecurringExpenses(store, recurringExpenses);
  }

  void _updateRecurringExpenseCharge(Store<AppState> store, UpdateSelectedRecurringChargeAction action, NextDispatcher next) async{
    int indexToUpdate = action.expense.charges.reversed.toList().indexWhere((charge) => charge.chargeDate == action.charge.chargeDate);
    action.expense.charges.reversed.toList().elementAt(indexToUpdate).isPaid = action.isChecked;
    await RecurringExpenseDao.insertOrUpdate(action.expense);

    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();
    _updateSaveAndSetRecurringExpenses(store, recurringExpenses);
  }

  void _updateJobTip(Store<AppState> store, SaveTipIncomeChangeAction action, NextDispatcher next) async{
    Job jobToSave = Job(
      id: store.state.incomeAndExpensesPageState.selectedJob.id,
      clientId: store.state.incomeAndExpensesPageState.selectedJob.clientId,
      clientName: store.state.incomeAndExpensesPageState.selectedJob.clientName,
      jobTitle: store.state.incomeAndExpensesPageState.selectedJob.jobTitle,
      selectedDate: store.state.incomeAndExpensesPageState.selectedJob.selectedDate,
      selectedTime: store.state.incomeAndExpensesPageState.selectedJob.selectedTime,
      type: store.state.incomeAndExpensesPageState.selectedJob.type,
      stage: store.state.incomeAndExpensesPageState.selectedJob.stage,
      invoice: store.state.incomeAndExpensesPageState.selectedJob.invoice,
      completedStages: store.state.incomeAndExpensesPageState.selectedJob.completedStages,
      location: store.state.incomeAndExpensesPageState.selectedJob.location,
      priceProfile: store.state.incomeAndExpensesPageState.selectedJob.priceProfile,
      depositAmount: store.state.incomeAndExpensesPageState.selectedJob.depositAmount,
      tipAmount: action.pageState.unsavedTipAmount,
      createdDate: store.state.incomeAndExpensesPageState.selectedJob.createdDate,
    );
    await JobDao.insertOrUpdate(jobToSave);
    store.dispatch(LoadAllJobsAction(store.state.incomeAndExpensesPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void deleteInvoice(Store<AppState> store, DeleteInvoiceAction action, NextDispatcher next) async {
    await InvoiceDao.deleteByInvoice(action.invoice);
    store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void fetchJobs(Store<AppState> store, NextDispatcher next) async {
    store.dispatch(SetTipTotalsAction(store.state.incomeAndExpensesPageState, await JobDao.getAllJobs()));
  }

  void _fetchSingleExpenses(Store<AppState> store, FetchSingleExpenses action, NextDispatcher next) async {
    List<SingleExpense> singleExpenses = await SingleExpenseDao.getAll();
    store.dispatch(SetSingleExpensesAction(store.state.incomeAndExpensesPageState, singleExpenses));
  }

  void _fetchRecurringExpenses(Store<AppState> store, FetchRecurringExpenses action, NextDispatcher next) async {
    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();
    _updateSaveAndSetRecurringExpenses(store, recurringExpenses);
  }

  void _fetchMileageExpenses(Store<AppState> store, FetchMileageExpenses action, NextDispatcher next) async {
    List<MileageExpense> mileageExpenses = await MileageExpenseDao.getAll();
    store.dispatch(SetMileageExpensesAction(store.state.incomeAndExpensesPageState, mileageExpenses));
  }

  void fetchInvoices(Store<AppState> store, NextDispatcher next) async{
    //use this code to delete all invoice in the app for testing only.
//    List<Invoice> invoices = await InvoiceDao.getAllSortedByDueDate();
//    for(Invoice invoice in invoices){
//      await InvoiceDao.deleteByInvoice(invoice);
//    }
      List<Profile> profiles = await ProfileDao.getAll();
      if(profiles != null && profiles.length > 0) {
        store.dispatch(SetProfileAction(store.state.incomeAndExpensesPageState, profiles.elementAt(0)));
      }else {
        Profile profile = Profile(latDefaultHome: 0.0, lngDefaultHome: 0.0);
        await ProfileDao.insertOrUpdate(profile);
        store.dispatch(SetProfileAction(store.state.incomeAndExpensesPageState, profile));
      }
      store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
  }

  void onEditInvoice(Store<AppState> store, InvoiceEditSelected action, NextDispatcher next) async {
    Job job = await JobDao.getJobById(action.invoice.jobId);
    store.dispatch(SetShouldClearAction(store.state.newInvoicePageState, false));
    store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, job));
  }

  void updateInvoiceToSent(Store<AppState> store, OnInvoiceSentAction action, NextDispatcher next) async {
    action.invoice.sentDate = DateTime.now();
    await InvoiceDao.update(action.invoice);
    Job invoiceJob = await JobDao.getJobById(action.invoice.jobId);
    store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
    store.dispatch(SaveStageCompleted(store.state.jobDetailsPageState, invoiceJob, 7));
  }

  void _updateSaveAndSetRecurringExpenses(Store<AppState> store, List<RecurringExpense> recurringExpenses) async{
    for(RecurringExpense recurringExpense in recurringExpenses) {
      recurringExpense.updateChargeList();
      await RecurringExpenseDao.insertOrUpdate(recurringExpense);
    }
    store.dispatch(SetRecurringExpensesAction(store.state.incomeAndExpensesPageState, recurringExpenses));
  }
}