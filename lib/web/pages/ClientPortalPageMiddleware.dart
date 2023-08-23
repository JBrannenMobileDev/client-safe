import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/repositories/ClientPortalRepository.dart';
import 'package:dandylight/data_layer/repositories/FileStorage.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Proposal.dart';
import 'package:dandylight/utils/PdfUtil.dart';
import 'package:pdf/widgets.dart';
import 'package:redux/redux.dart';
import '../../data_layer/api_clients/DandylightFunctionsClient.dart';
import '../../models/Branding.dart';
import '../../models/Invoice.dart';
import 'ClientPortalActions.dart';
import 'package:http/http.dart' as http;

class ClientPortalMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is UpdateProposalInvoicePaidAction) {
      _updateProposalInvoicePaid(store, action, next);
    }
    if(action is UpdateProposalInvoiceDepositPaidAction) {
      _updateProposalInvoiceDepositPaid(store, action, next);
    }
    if(action is FetchProposalDataAction) {
      _fetchProposal(store, action, next);
    }
    if(action is GenerateContractForClientAction) {
      _generateContract(store, action, next);
    }
    if(action is GenerateInvoiceForClientAction) {
      _generateInvoice(store, action, next);
    }
    if(action is SaveClientSignatureAction) {
      _saveClientSignature(store, action, next);
    }
  }

  void _fetchProposal(Store<AppState> store, FetchProposalDataAction action, NextDispatcher next) async{
    ClientPortalRepository repository = ClientPortalRepository(functions: DandylightFunctionsApi(httpClient: http.Client()));
    Profile profile = await repository.fetchProfile(action.userId, action.jobId);
    Job job = await repository.fetchJob(action.userId, action.jobId);

    store.dispatch(SetProposalAction(store.state.clientPortalPageState, job.proposal));
    store.dispatch(SetJobAction(store.state.clientPortalPageState, job));
    store.dispatch(SetProfileAction(store.state.clientPortalPageState, profile));
    store.dispatch(SetInvoiceAction(store.state.clientPortalPageState, job.invoice));
  }

  void _generateContract(Store<AppState> store, GenerateContractForClientAction action, NextDispatcher next) async{
    Document pdf = await PdfUtil.generateContract(action.pageState.proposal.contract, action.pageState.proposal, action.pageState.profile, action.pageState.job);
    FileStorage.webDownload(await pdf.save(), action.pageState.job.client.firstName + '_' + action.pageState.job.client.lastName + '_contract');
  }

  void _generateInvoice(Store<AppState> store, GenerateInvoiceForClientAction action, NextDispatcher next) async{
    Document pdf = await PdfUtil.generateInvoicePdfFromInvoice(
        action.pageState.invoice,
        action.pageState.job,
        action.pageState.job.client,
        action.pageState.profile,
        action.pageState.profile.logoUrl,
        Branding(
          logoUrl: null,
          logoColor: '#d49a89',
          logoTextColor: '#ffffff'
        )
    );
    FileStorage.webDownload(await pdf.save(), action.pageState.job.client.firstName + '_' + action.pageState.job.client.lastName + '_invoice');
  }

  void _saveClientSignature(Store<AppState> store, SaveClientSignatureAction action, NextDispatcher next) async{
    Proposal proposal = action.pageState.proposal;
    store.dispatch(SetProposalAction(store.state.clientPortalPageState, proposal));

    ClientPortalRepository repository = ClientPortalRepository(functions: DandylightFunctionsApi(httpClient: http.Client()));
    int errorCode = await repository.saveClientSignature(action.pageState.userId, action.pageState.jobId, action.signature);
    if(errorCode != 200) {
      proposal.contract.clientSignature = action.signature;
      proposal.contract.signedByClient = true;
      proposal.contract.clientSignedDate = DateTime.now();
      store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, "There was an error saving your signature. Please try again."));
    }
    store.dispatch(SetLoadingStateAction(store.state.clientPortalPageState, false));
  }

  void _updateProposalInvoicePaid(Store<AppState> store, UpdateProposalInvoicePaidAction action, NextDispatcher next) async{
    Invoice invoice = action.pageState.invoice;
    invoice.invoicePaid = action.isPaid;
    invoice.unpaidAmount = action.isPaid ? 0 : invoice.calculateUnpaidAmount();
    store.dispatch(SetInvoiceAction(store.state.clientPortalPageState, invoice));
    //TODO rest call to update actual proposal
  }

  void _updateProposalInvoiceDepositPaid(Store<AppState> store, UpdateProposalInvoiceDepositPaidAction action, NextDispatcher next) async{
    Invoice invoice = action.pageState.invoice;
    invoice.depositPaid = action.isPaid;
    if(action.isPaid) {
      invoice.unpaidAmount = invoice.unpaidAmount - invoice.depositAmount;
    } else {
      invoice.unpaidAmount = invoice.unpaidAmount + invoice.depositAmount;
    }
    store.dispatch(SetInvoiceAction(store.state.clientPortalPageState, invoice));
    //TODO rest call to update actual proposal
  }
}