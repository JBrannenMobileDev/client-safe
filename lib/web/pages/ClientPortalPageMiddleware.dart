import 'package:dandylight/AppState.dart';
import 'package:redux/redux.dart';
import 'ClientPortalActions.dart';

class ClientPortalMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is UpdateProposalContractSignedAction){
      _updateProposalContractSigned(store, action, next);
    }
    if(action is UpdateProposalInvoicePaidAction) {
      _updateProposalInvoicePaid(store, action, next);
    }
    if(action is UpdateProposalInvoiceDepositPaidAction) {
      _updateProposalInvoiceDepositPaid(store, action, next);
    }
    if(action is FetchProposalAction) {
      _fetchProposal(store, action, next);
    }
  }

  void _fetchProposal(Store<AppState> store, FetchProposalAction action, NextDispatcher next) async{

  }

  void _updateProposalContractSigned(Store<AppState> store, UpdateProposalContractSignedAction action, NextDispatcher next) async{

  }

  void _updateProposalInvoicePaid(Store<AppState> store, UpdateProposalInvoicePaidAction action, NextDispatcher next) async{

  }

  void _updateProposalInvoiceDepositPaid(Store<AppState> store, UpdateProposalInvoiceDepositPaidAction action, NextDispatcher next) async{

  }
}