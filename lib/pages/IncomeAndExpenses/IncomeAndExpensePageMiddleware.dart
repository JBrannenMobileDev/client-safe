import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/Invoice.dart';
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
import 'package:sembast/sembast.dart';

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
    await JobDao.insertOrUpdate(store.state.incomeAndExpensesPageState.selectedJob.copyWith(tipAmount: action.pageState.unsavedTipAmount));
    store.dispatch(LoadAllJobsAction(store.state.incomeAndExpensesPageState));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void deleteInvoice(Store<AppState> store, DeleteInvoiceAction action, NextDispatcher next) async {
    await InvoiceDao.deleteByInvoice(action.invoice);
    store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));

    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    store.dispatch(SetNewInvoice(store.state.jobDetailsPageState, null));
  }

  void fetchJobs(Store<AppState> store, NextDispatcher next) async {
    store.dispatch(SetTipTotalsAction(store.state.incomeAndExpensesPageState, await JobDao.getAllJobs()));

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = List();
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetTipTotalsAction(store.state.incomeAndExpensesPageState, jobs));
    });
  }

  void _fetchSingleExpenses(Store<AppState> store, FetchSingleExpenses action, NextDispatcher next) async {
    (await SingleExpenseDao.getSingleExpenseStream()).listen((expenseSnapshots) {
      List<SingleExpense> expenses = List();
      for(RecordSnapshot expenseSnapshot in expenseSnapshots) {
        SingleExpense expenseToSave = SingleExpense.fromMap(expenseSnapshot.value);
        expenseToSave.id = expenseSnapshot.key;
        expenses.add(expenseToSave);
      }
      store.dispatch(SetSingleExpensesAction(store.state.incomeAndExpensesPageState, expenses));
    });
  }

  void _fetchRecurringExpenses(Store<AppState> store, FetchRecurringExpenses action, NextDispatcher next) async {
    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();
    _updateSaveAndSetRecurringExpenses(store, recurringExpenses);

    (await RecurringExpenseDao.getRecurringExpenseStream()).listen((expenseSnapshots) async {
      List<RecurringExpense> expenses = List();
      for(RecordSnapshot expenseSnapshot in expenseSnapshots) {
        expenses.add(RecurringExpense.fromMap(expenseSnapshot.value));
      }
      store.dispatch(SetRecurringExpensesAction(store.state.incomeAndExpensesPageState, expenses));
    });
  }

  void _fetchMileageExpenses(Store<AppState> store, FetchMileageExpenses action, NextDispatcher next) async {
    (await MileageExpenseDao.getMileageExpenseStream()).listen((expenseSnapshots) {
      List<MileageExpense> expenses = List();
      for(RecordSnapshot expenseSnapshot in expenseSnapshots) {
        MileageExpense expenseToSave = MileageExpense.fromMap(expenseSnapshot.value);
        expenseToSave.id = expenseSnapshot.key;
        expenses.add(expenseToSave);
      }
      store.dispatch(SetMileageExpensesAction(store.state.incomeAndExpensesPageState, expenses));
    });
  }

  void fetchInvoices(Store<AppState> store, NextDispatcher next) async{
      List<Profile> profiles = await ProfileDao.getAll();
      if(profiles != null && profiles.length > 0) {
        store.dispatch(SetProfileAction(store.state.incomeAndExpensesPageState, profiles.elementAt(0)));
      }else {
        Profile profile = Profile(latDefaultHome: 0.0, lngDefaultHome: 0.0);
        await ProfileDao.insertOrUpdate(profile);
        store.dispatch(SetProfileAction(store.state.incomeAndExpensesPageState, profile));
      }
      store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));

      (await InvoiceDao.getInvoiceStream()).listen((invoiceSnapshots) async {
        List<Invoice> invoices = List();
        for(RecordSnapshot invoiceSnapshot in invoiceSnapshots) {
          invoices.add(Invoice.fromMap(invoiceSnapshot.value));
        }
        store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, invoices));
      });
  }

  void onEditInvoice(Store<AppState> store, InvoiceEditSelected action, NextDispatcher next) async {
    Job job = await JobDao.getJobById(action.invoice.jobDocumentId);
    store.dispatch(SetShouldClearAction(store.state.newInvoicePageState, false));
    store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, job));
  }

  void updateInvoiceToSent(Store<AppState> store, OnInvoiceSentAction action, NextDispatcher next) async {
    action.invoice.sentDate = DateTime.now();
    await InvoiceDao.update(action.invoice, await JobDao.getJobById(action.invoice.jobDocumentId));
    Job invoiceJob = await JobDao.getJobById(action.invoice.jobDocumentId);
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