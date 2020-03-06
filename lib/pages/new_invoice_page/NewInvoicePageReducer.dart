import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:redux/redux.dart';

final newInvoicePageReducer = combineReducers<NewInvoicePageState>([
  TypedReducer<NewInvoicePageState, SetAllJobsAction>(_setJobs),
//  TypedReducer<NewInvoicePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
]);

NewInvoicePageState _setJobs(NewInvoicePageState previousState, SetAllJobsAction action) {
  return previousState.copyWith(
      jobs: action.allJobs,
      allClients: action.allClients,
  );
}

//NewJobPageState _loadWithSelectedClient(NewJobPageState previousState, InitializeNewContactPageAction action) {
//  return previousState.copyWith(
//      selectedClient: action.client,
//      shouldClear: false,
//  );
//}