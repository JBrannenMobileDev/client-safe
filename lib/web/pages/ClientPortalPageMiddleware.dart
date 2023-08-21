import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/repositories/FileStorage.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/LineItem.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Proposal.dart';
import 'package:dandylight/utils/PdfUtil.dart';
import 'package:pdf/widgets.dart';
import 'package:redux/redux.dart';
import '../../models/Branding.dart';
import '../../models/Contract.dart';
import '../../models/Invoice.dart';
import '../../models/Job.dart';
import '../../models/JobStage.dart';
import '../../models/Location.dart';
import '../../models/Pose.dart';
import '../../utils/ColorConstants.dart';
import 'ClientPortalActions.dart';

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
    Job job = Job(
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
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2Fcfd51300-b340-11ed-9fb2-f91ec5f5c2e7.jpg?alt=media&token=424e417e-72f3-499a-bdaf-608bb3c1e1c7'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F2d944fa0-b30b-11ed-8a6e-657612667ae6.jpg?alt=media&token=1baabb62-1430-4456-a20a-86e2726998bb'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F526757f0-b30b-11ed-bfff-3fdd62ec8ca8.jpg?alt=media&token=abed2ce9-8dd5-4e55-b1ce-ff5b1305d182'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F7355ac00-b30b-11ed-839b-9ba74d939bf5.jpg?alt=media&token=127d92ab-044f-45cf-b22f-28bbc6077993'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F736849a0-b30b-11ed-9828-833a36aa2c26.jpg?alt=media&token=045b58ef-562d-4b23-8efb-12c90ca34e6d'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F8203e960-b30b-11ed-a896-9f7a6d27d18e.jpg?alt=media&token=f2c73f32-d848-4e0d-bce5-a4dd6ecb25ec'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F9a32b520-b30b-11ed-ba94-dd9cf87a4eb3.jpg?alt=media&token=39f94d71-f714-4c6c-874d-c89640c94e0e'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2Fafebc5f0-b30b-11ed-84b6-177555d69286.jpg?alt=media&token=bcca2f7b-f5ba-4541-9acb-75e084ae637b'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2Fcd117940-b30b-11ed-8b2a-fb5a221df60f.jpg?alt=media&token=284de7b7-dd15-4f89-9edb-ac83b1aad461'),
        Pose(imageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FlibraryPoses%2F5e3674c0-b30c-11ed-be70-1579791391ca.jpg?alt=media&token=8c2a640d-c03b-4492-ad93-70d5c7f62412'),
      ],
      completedStages: [
        JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED),
        JobStage(stage: JobStage.STAGE_2_FOLLOWUP_SENT)
      ],
    );
    Profile profile = Profile(
        businessName: 'Vintage Vibes Photography',
        email: 'vintagevibesphotography@gmail.com',
        firstName: 'Shawna',
        lastName: 'Brannen',
        phone: '(951)295-0348'
    );
    Invoice invoice = Invoice(
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
          itemQuantity: 1,
        ),
        LineItem(
          itemName: 'Second location',
          itemPrice: 75,
          itemQuantity: 1,
        )
      ],
    );
    Proposal proposal = Proposal(
      logoUrl: null,
      includePoses: true,
      bannerUrl: '',
      detailsMessage: 'Hi Jason, \nI\'m so excited to book in your photoshoot! Let\'s make this official.\n\nTo lock in your date, please review and sign the contract and pay the deposit.\n\nChat soon,\nShawna Brannen',
      contract: Contract(
        photographerSignedDate: DateTime.now(),
        clientSignedDate: DateTime.now(),
        signedByClient: false,
        clientSignature: '',
        photographerSignature: 'Shawna Brannen',
        contractName: 'Wedding Contract',
        terms: 'THIS AGREEMENT is made as of July 4, 2023 (the “Effective Date”) between Jason Bent with a primary contact address of Client AddressClient Address FILL (“Client”), and Vintage Vibes Photography (“Photographer”).\n'+
      '\n'+
      '\n'+
      '\n'+
      '1. Engagement of Photographer\n'+
      '1.1 Services. Subject to the terms set out herein, Client engages Photographer to provide, and Photographer agrees to provide, the photography services described in this Section 1.1 (the “Services”).\n'+
      '\n'+
      '\n'+
      '\n'+
      'Description of Services:\n'+
      '\n'+
      '[Enter description of services]\n'+
      '\n'+
      '\n'+
      'As part of the Services, the Photographer will produce or take similar action to create materials from Images and provide related deliverables (as set out above) pursuant to the provision of the Services (“Work Product”). “Images” means photographic material, whether still or moving, created by Photographer pursuant to this Agreement and includes, but is not limited to, transparencies, negatives, prints or digital files, captured, recorded, stored or delivered in any type of analogue, photographic, optical, electronic, magnetic, digital or any other medium.\n'+
      '\n'+
      '1.2 Exclusivity. Client acknowledges and agrees that Photographer will be the exclusive provider of the Services, unless otherwise agreed to by the parties in writing.\n'+
      '\n'+
      '2. Fees and Payment\n'+
      '2.1 Fees. Client will pay Photographer the fees set out herein in this Section 2.1 (“Fees”), including any applicable federal or state/provincial sales or value-added taxes due on such Fees.\n'+
      '\n'+
      'Total Fee for Services: \$450.00\n'+
      '\n'+
      'Retainer due upon signing: \$150.00\n'+
      '\n'+
      'Remaining amount due on July 25, 2023: \$300.00\n'+
      '\n'+
      '2.2 Retainer. Client acknowledges and agrees that the retainer amount set out above is due upon the signing of this Agreement and is not refundable (“Retainer”), so as to fairly compensate Photographer for committing his/her time to provide the Services and turning down other potential projects or clients. Both parties agree that the Retainer will be credited towards the total Fees payable by Client.\n'+
      '\n'+
      '2.3 Invoice. Photographer will issue an invoice to Client upon agreement of the Services (“Invoice”). Client agrees to pay all Fees outstanding on or prior to the due dates set out in Section 2.1. Any payment after the due date will incur a late fee of [X%] per month on the outstanding balance. Client acknowledges that the final amount payable may be subject to change depending on the amount actual expenses incurred. Client confirms and agrees that the final calculations provided in the Invoice, should they be different from the total listed in Section 2.1, will be the final amount payable.\n'+
      '\n'+
      '3. Client Responsibilities\n'+
      '3.1 Required Consents. Client will ensure that all required consents, as applicable, have been obtained prior to performance of the Services, including any consents required for the performance of Services and the delivery of Work Product by Photographer and, as applicable, from venues or locales where the Services are to be performed or from attendees or participants of the photo shoot.\n'+
      '\n'+
      '3.2 Expenses. Client will provide the means of travel or be responsible for reasonable travel expenses incurred by Photographer that are necessary for the performance of the Services or travel that is otherwise requested by Client where the location of the performance of the Services is not in the city of [City Name]. Client will be responsible for any other expenses incurred by Photographer that are necessary for the performance of the Services as more particularly set out in Article 2.\n'+
      '\n'+
      '3.3 Waiver. Client (on behalf of himself/herself and any other participant whose image or recording may be captured by the Services) hereby waives all rights and claims, and releases Photographer from any claim or cause of action, whether now known or unknown, relating to the sale, display, license, use and exploitation of Images pursuant to this Agreement.\n'+
      '\n'+
      '4. Photographer Responsibilities\n'+
      '4.1 Equipment. Client will not be required to supply any photography equipment to Photographer.\n'+
      '\n'+
      '4.2 Manner of Service. Photographer will ensure that the Services are performed in a good, expedient, workmanlike and safe manner, and in such a manner as to avoid unreasonable interference with Client’s activities.\n'+
      '\n'+
      '4.3 Photography Staff. Photographer will, and will ensure that all Photography Staff (employees, assistants or other parties engaged by Photographer to assist with the Services):\n'+
      '\n'+
      'comply with the reasonable directions of Client from time to time regarding the safety of attendees or participants at the photo shoot and applicable health, safety and security requirements of any locations where the Services are provided;\n'+
      '\n'+
      'ensure that Work Product meets the specifications set out in Section 1.1 in all material respects.\n'+
      '\n'+
      'Photographer will be responsible in every respect for the actions of all Photography Staff.\n'+
      '\n'+
      '5. Artistic Release\n'+
      '5.1 Consistency. Photographer will use reasonable efforts to ensure that the Services are produced in a style consistent with Photographer’s current portfolio, and Photographer will use reasonable efforts to consult with Client and incorporate any reasonable suggestions.\n'+
      '\n'+
      '5.2 Style. Client acknowledges and agrees that:\n'+
      '\n'+
      'Client has reviewed Photographer’s previous work and portfolio and has a reasonable expectation that Photographer will perform the Services in a similar style\n'+
      '\n'+
      'Photographer will use its artistic judgement when providing the Services, and shall have final say regarding the aesthetic judgement and artistic quality of the Services; and\n'+
      '\n'+
      'Disagreement with Photographer’s aesthetic judgement or artistic ability are not valid reasons for termination of this Agreement or request of any monies returned.\n'+
      '\n'+
      '6. Term and Termination\n'+
      '6.1 Term. This Agreement will begin on the Effective Date and continue until the latter of (i) the date where all outstanding Fees under this Agreement are paid in full; or (ii) the date where all final Work Product has been delivered (“Term”).\n'+
      '\n'+
      '6.2 Cancellation. Client may terminate the Agreement (“Cancellation”) and/or reschedule the Services (“Rescheduling”) by providing Photographer with written notice no later than [X days] before the original date of the Services (the “Minimum Notice”). Client acknowledges and agrees that Client is not relieved of any payment obligations for Cancellations and Rescheduling unless the Minimum Notice in accordance with this Article 6 is duly provided or unless the parties otherwise agree in writing.\n'+
      '\n'+
      '\n'+
      '\n'+
      '6.3 Rescheduling. In the event of Rescheduling, Photographer will use commercially reasonable efforts to accommodate Client’s change. If Photographer is not able to accommodate Client’s change despite using commercially reasonable efforts, the parties agree that such Rescheduling will be deemed as Cancellation by Client and that Photographer will be under no obligation to perform the Services other than on the original date of the Services.\n'+
      '\n'+
      '6.4 No Refund. Client acknowledges and agrees that Cancellation by Client will not result in a refund of any fees paid on or prior to the date of Cancellation by Client.\n'+
      '\n'+
      '6.5 Replacement. In the event that Photographer is unable to perform the Services, Photographer, subject to Client’s consent, which is not to be reasonably withheld, shall cause a replacement photographer to perform the Services in accordance with the terms of this Agreement. In the event that such consent is not obtained, Photographer shall terminate this Agreement and shall return the Retainer and all fees paid by Client, and thereafter shall have no further liability to Client.\n'+
      '\n'+
      '7. Ownership of Work Product by Photographer\n'+
      '7.1 Ownership of Work. Photographer will own all right, title and interest in all Work Product. Client (on behalf of itself and any attendees or participants at the photo shoot) hereby grants Photographer and any of its service providers an exclusive, royalty-free, worldwide, irrevocable, transferable and sublicensable license to use any materials created by Client or attendees, during the performance of the Services, that may be protected by copyright or any intellectual property rights (“Client Materials”) as part of any Work Product or in connection with the marketing, advertising or promotion of Photographer’s services, including in connection with Photographer’s studio, portfolio, website or social media, in any format or medium. Client acknowledges and affirms that no other person or entity has any rights that may prevent or restrict Photographer from using Client Materials as provided herein.\n'+
      '\n'+
      '8. Limited License to Client\n'+
      '8.1 Personal Use. Photographer hereby grants Client an exclusive, limited, irrevocable, royalty-free, non-transferable and non-sublicensable license to use Work Product for Client’s Personal Use, provided that Client does not remove any attribution notices or copyright notices included by Photographer in any Work Product. “Personal Use” includes, but is not limited to, use (i) of photos on Client’s personal social media pages or profiles; (ii) in Client’s personal creations, such as scrapbooks, albums or personal gifts; (iii) in non-commercial physical display; and (iv) in personal communications, such as family newsletter, email, or holiday card. Client will not make any other use of the Work Product without Photographer’s prior written consent, including but not limited to use of the Work Product for commercial sale.\n'+
      '\n'+
      '9. Indemnity and Limitation of Liability\n'+
      '9.1 Indemnification. Client agrees to indemnify, defend and hold harmless Photographer and its affiliates, employees, agents and independent contractors for any injury, property damage, liability, claim or other cause of action arising out of or related to the Services and or Work Product Photographer provides to Client.\n'+
      '\n'+
      '9.2 Force Majeure. Neither party shall be held in breach of or liable under this Agreement for any delay or non-performance of any provision of this Agreement caused by illness, emergency, fire, strike, pandemic, earthquake, or any other conditions beyond the reasonable control of the non-performing party (each a “Force Majeure Event”), and the time of performance of such provision, if any, shall be deemed to be extended for a period equal to the duration of the conditions preventing performance. If such Force Majeure Event persists for more than 60 days, the party not affected by the Force Majeure Event may terminate the Agreement and any prepaid fees for Services not performed (other than the Retainer) shall be returned within 15 days of the date of termination of the Agreement.\n'+
      '\n'+
      '9.3 Failure to Deliver . Photographer shall not be held liable for delays in the delivery of such Work Product, or any Work Product undeliverable, due to technological malfunctions, service interruptions that are beyond the control of Photographer (including as a result of delays in receipt of instructions from Client) and for Work Product that fails to meet the specifications set out in Section 1.1 due to the actions of Client or attendees or participants at the photo shoot that are beyond the control of Photographer (e.g., camera flashes).\n'+
      '\n'+
      '9.4 Maximum Liability. Notwithstanding anything to the contrary, Client agrees that Photographer’s maximum liability arising out of or related to the Services or the Work Product shall not exceed the total Fees payable under this Agreement.\n'+
      '\n'+
      '10. General\n'+
      '10.1 Notice. Parties shall provide effective notice (“Notice”) to each other via either of the following methods of delivery at the date and time which the Notice is sent:\n'+
      '\n'+
      'Photographer’s Email: Vintagevibesphotography@gmail.com\n'+
      '\n'+
      'Client’s Email: jbent@gmail.com\n'+
      '\n'+
      '\n10.2 Survival. Articles 7, 8, 9 and 10 will survive termination of this Agreement.\n'+
      '\n'+
      '10.3 Governing Law. This Agreement will be governed by the laws of [State/Country]\n'+
      '\n'+
      '10.4 Amendment. This Agreement may only be amended, supplemented or otherwise modified by written agreement signed by each of the parties.\n'+
      '\n'+
      '10.5 Entire Agreement. This Agreement constitutes the entire agreement between the parties with respect to the Services and supersedes all prior agreements and understandings both formal and informal.\n'+
      '\n'+
      '10.6 Severability. If any provision of this Agreement is determined to be illegal, invalid or unenforceable, in whole or in part, by an arbitrator or any court of competent jurisdiction, that provision or part thereof will be severed from this Agreement and the remaining part of such provision and all other provisions will continue in full force and effect.\n'
      ),
    );
    store.dispatch(SetProposalAction(store.state.clientPortalPageState, proposal));
    store.dispatch(SetJobAction(store.state.clientPortalPageState, job));
    store.dispatch(SetProfileAction(store.state.clientPortalPageState, profile));
    store.dispatch(SetInvoiceAction(store.state.clientPortalPageState, invoice));
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
        action.pageState.proposal.logoUrl,
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
    proposal.contract.clientSignature = action.signature;
    proposal.contract.signedByClient = true;
    proposal.contract.clientSignedDate = DateTime.now();
    store.dispatch(SetProposalAction(store.state.clientPortalPageState, proposal));
    //TODO rest call to update actual proposal
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