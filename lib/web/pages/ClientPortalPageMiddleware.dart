import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Proposal.dart';
import 'package:redux/redux.dart';
import '../../models/Contract.dart';
import '../../models/Job.dart';
import '../../models/Location.dart';
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
    if(action is GenerateContractForClientAction) {
      _generateContract(store, action, next);
    }
    if(action is GenerateInvoiceForClientAction) {
      _generateInvoice(store, action, next);
    }
  }

  void _fetchProposal(Store<AppState> store, FetchProposalAction action, NextDispatcher next) async{
    Proposal proposal = Proposal(
      logoUrl: null,
      detailsMessage: 'Hi Jason, \nI\'m so excited to book in your photoshoot! Let\'s make this official.\n\nTo lock in your date, please review and sign the contract and pay the deposit.\n\nChat soon,\nShawna Brannen',
      job: Job(
        selectedDate: DateTime.now(),
        selectedTime: DateTime.now(),
        selectedEndTime: DateTime.now(),
        client: Client(
          firstName: 'Jason',
          lastName: 'Bent',
          email: 'jbent@gmail.com',
          phone: '(951)295-0348'
        ),
        location: Location(
          address: '42161 Delmonte St. Temecula CA 92591',
          latitude: 28374634,
          longitude: 28374643,
        ),
      ),
      profile: Profile(
        businessName: 'Vintage Vibes Photography',
        email: 'vintagevibesphotography@gmail.com',
        firstName: 'Shawna',
        lastName: 'Brannen',
        phone: '(951)295-0348'
      ),
      contract: Contract(
        photographerSignedDate: DateTime.now(),
        clientSignedDate: DateTime.now(),
        signedByClient: true,
        clientSignature: 'Jason Bent',
        photographerSignature: 'Shawna Brannen',
        contractName: 'Wedding Contract',
        terms: 'I acknowledge that I have read and understood the contents of the contract, and I hereby agree to all the terms and conditions outlined within it by signing this document.',
      )
    );
    store.dispatch(SetUpdatedProposalAction(store.state.clientPortalPageState, proposal));
  }

  void _generateContract(Store<AppState> store, GenerateContractForClientAction action, NextDispatcher next) async{

  }

  void _generateInvoice(Store<AppState> store, GenerateInvoiceForClientAction action, NextDispatcher next) async{

  }

  void _updateProposalContractSigned(Store<AppState> store, UpdateProposalContractSignedAction action, NextDispatcher next) async{

  }

  void _updateProposalInvoicePaid(Store<AppState> store, UpdateProposalInvoicePaidAction action, NextDispatcher next) async{

  }

  void _updateProposalInvoiceDepositPaid(Store<AppState> store, UpdateProposalInvoiceDepositPaidAction action, NextDispatcher next) async{

  }
}