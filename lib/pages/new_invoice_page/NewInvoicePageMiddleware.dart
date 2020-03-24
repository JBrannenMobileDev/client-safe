import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ClientDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:redux/redux.dart';

class NewInvoicePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllInvoiceJobsAction) {
      _loadAll(store, action, next);
    }
    if(action is SaveNewLineItemAction){
      _saveNewLineItem(store, action, next);
    }
    if(action is DeleteLineItemAction){
      _deleteLineItem(store, action, next);
    }
    if(action is SaveNewDiscountAction){
      _saveNewDiscount(store, action, next);
    }
    if(action is DeleteDiscountAction){
      _deleteDiscount(store, action, next);
    }
  }

  void _loadAll(Store<AppState> store, action, NextDispatcher next) async {
    List<Client> allClients = await ClientDao.getAllSortedByFirstName();
    List<Job> allJobs = await JobDao.getAllJobs();
    allJobs = allJobs.where((job) => job.invoice == null).toList();
    store.dispatch(SetAllJobsAction(store.state.newInvoicePageState, allJobs, allClients));
  }

  void _saveNewLineItem(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }

  void _deleteLineItem(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }

  void _saveNewDiscount(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }

  void _deleteDiscount(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }
}