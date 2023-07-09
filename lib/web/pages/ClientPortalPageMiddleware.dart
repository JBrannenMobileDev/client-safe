import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/LineItem.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Proposal.dart';
import 'package:redux/redux.dart';
import '../../models/Contract.dart';
import '../../models/Invoice.dart';
import '../../models/Job.dart';
import '../../models/Location.dart';
import '../../models/Pose.dart';
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
      includePoses: true,
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
        poses: [
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e'),
          Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F03185ef0-b339-11ed-b747-d351e53325e2.jpg?alt=media&token=e429e4be-df7e-4011-b331-7a1100de8d0e')
        ]
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
      ),
      invoice: Invoice(
        depositPaid: false,
        invoicePaid: false,
        dueDate: DateTime.now(),
        depositDueDate: DateTime.now(),
        depositAmount: 150.0,
        unpaidAmount: 516.56,
        invoiceId: 1001,
        subtotal: 525,
        total: 516.56,
        discount: 50,
        salesTaxRate: 8.75,
        salesTaxAmount: 41.56,
        lineItems: [
          LineItem(
            itemName: 'Standard 1 hr',
            itemPrice: 450,
          ),
          LineItem(
            itemName: 'Second location',
            itemPrice: 75,
          )
        ],
      ),
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
//TODO rest call to update actual proposal
    Proposal proposal = action.pageState.proposal;
    proposal.invoice.invoicePaid = action.isPaid;
    proposal.invoice.unpaidAmount = action.isPaid ? 0 : proposal.invoice.calculateUnpaidAmount();
    store.dispatch(SetUpdatedProposalAction(store.state.clientPortalPageState, proposal));
  }

  void _updateProposalInvoiceDepositPaid(Store<AppState> store, UpdateProposalInvoiceDepositPaidAction action, NextDispatcher next) async{
    //TODO rest call to update actual proposal
    Proposal proposal = action.pageState.proposal;
    proposal.invoice.depositPaid = action.isPaid;
    if(action.isPaid) {
      proposal.invoice.unpaidAmount = proposal.invoice.unpaidAmount - proposal.invoice.depositAmount;
    } else {
      proposal.invoice.unpaidAmount = proposal.invoice.unpaidAmount + proposal.invoice.depositAmount;
    }
    store.dispatch(SetUpdatedProposalAction(store.state.clientPortalPageState, proposal));
  }
}