import 'dart:convert';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/repositories/ClientPortalRepository.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Proposal.dart';
import 'package:dandylight/models/Question.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/PdfUtil.dart';
import 'package:pdf/widgets.dart';
import 'package:redux/redux.dart';
import '../../data_layer/api_clients/DandylightFunctionsClient.dart';
import '../../models/Client.dart';
import '../../models/Contract.dart';
import '../../models/Invoice.dart';
import '../../models/JobStage.dart';
import '../../models/LineItem.dart';
import '../../models/Pose.dart';
import '../../utils/ContractUtils.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import 'ClientPortalActions.dart';
import 'package:http/http.dart' as http;
import '../../models/LocationDandy.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;


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
    ClientPortalRepository? repository = ClientPortalRepository(functions: DandylightFunctionsApi(httpClient: http.Client()));
    Profile? profile = await repository.fetchProfile(action.userId!, action.jobId);
    Job? job;
    if(action.isBrandingPreview!) {
      job = buildExampleJob();
      job.invoice = buildExampleInvoice();
      job.proposal = buildExampleProposal(profile.previewJsonContract, profile.firstName);
      profile.venmoLink = profile.venmoLink != null ? profile.venmoLink : 'https://venmo.com/code?user_id=';
      profile.venmoEnabled = true;
      profile.zelleEnabled = true;
      profile.phone = profile.phone != null ? profile.phone : '(888)888-8888';
      profile.cashEnabled = true;
      profile.selectedColorTheme = profile.previewColorTheme;
      profile.selectedFontTheme = profile.previewFontTheme;  //test preview from onboarding with new account
      profile.bannerImageSelected = profile.previewBannerImageSelected;
      profile.bannerMobileUrl = profile.previewBannerMobileUrl;
      profile.bannerWebUrl = profile.previewBannerWebUrl;
      profile.logoUrl = profile.previewLogoUrl;
      profile.logoSelected = profile.previewLogoSelected;
      profile.logoCharacter = profile.previewLogoCharacter;
    } else {
      job = await repository.fetchJob(action.userId!, action.jobId!);
      job = populateContractsWithJobData(job, profile);
      if(job.invoice != null && (job.invoice!.salesTaxRate ?? 0) > 0 && job.invoice!.salesTaxAmount == 0) {
        job.invoice!.salesTaxAmount = (job.invoice!.subtotal! * job.invoice!.salesTaxRate!)/100;
      }
    }

    store.dispatch(SetProposalAction(store.state.clientPortalPageState, job.proposal));
    store.dispatch(SetJobAction(store.state.clientPortalPageState, job));
    store.dispatch(SetProfileAction(store.state.clientPortalPageState, profile));
    store.dispatch(SetInvoiceAction(store.state.clientPortalPageState, job.invoice));
    store.dispatch(SetInitialLoadingStateAction(store.state.clientPortalPageState, false));
  }

  void _generateContract(Store<AppState> store, GenerateContractForClientAction action, NextDispatcher next) async{
    Document pdf = await PdfUtil.generateContract(action.contract, action.pageState!.proposal!, action.pageState!.profile!, action.pageState!.job!);
    IntentLauncherUtil.downloadWeb(await pdf.save(), downloadName: action.pageState!.job!.client!.firstName! + '_' + action.pageState!.job!.client!.lastName! + '_contract.pdf');
  }

  void _generateInvoice(Store<AppState> store, GenerateInvoiceForClientAction action, NextDispatcher next) async{
    Document? pdf = await PdfUtil.generateInvoicePdfFromInvoice(
        action.pageState!.invoice!,
        action.pageState!.job!,
        action.pageState!.job!.client!,
        action.pageState!.profile!,
    );
    IntentLauncherUtil.downloadWeb(await pdf!.save(), downloadName: action.pageState!.job!.client!.firstName! + '_' + action.pageState!.job!.client!.lastName! + '_invoice.pdf');
  }

  void _saveClientSignature(Store<AppState> store, SaveClientSignatureAction action, NextDispatcher next) async{
    Proposal proposal = action.pageState!.proposal!;


    if(proposal.contract != null) {
      if(action.signature == null || action.signature!.isEmpty) {
        store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, "Please sign the contract before saving your signature."));
        store.dispatch(SetLoadingStateAction(store.state.clientPortalPageState, false));
      } else {
        ClientPortalRepository repository = ClientPortalRepository(functions: DandylightFunctionsApi(httpClient: http.Client()));
        int errorCode = await repository.saveClientSignature(action.pageState!.userId!, action.pageState!.jobId!, action.signature!, null);
        if(errorCode != 200) {
          store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, "There was an error saving your signature. Please try again."));
        } else {
          proposal.contract!.clientSignature = action.signature;
          proposal.contract!.signedByClient = true;
          proposal.contract!.clientSignedDate = DateTime.now();
          action.pageState!.job!.proposal = proposal;
          store.dispatch(SetJobAction(store.state.clientPortalPageState, action.pageState!.job));
          store.dispatch(SetProposalAction(store.state.clientPortalPageState, proposal));
          EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CONTRACT_SIGNED);
        }
        store.dispatch(SetLoadingStateAction(store.state.clientPortalPageState, false));
      }
    } else {
      Contract contractToSave = action.contract;

      ClientPortalRepository? repository = ClientPortalRepository(functions: DandylightFunctionsApi(httpClient: http.Client()));
      Job job = await repository.fetchJob(action.pageState!.userId!, action.pageState!.jobId!);

      Contract mostUpToDateVersion = job.proposal!.contracts!.firstWhere((item) => item.documentId == contractToSave.documentId);

      if(action.signature == null || action.signature!.isEmpty || (mostUpToDateVersion.isVoid ?? false)) {
        if((mostUpToDateVersion.isVoid ?? false)) {
          store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, "This contract is marked as VOID. You cannot sign this contract."));
        } else {
          if(mostUpToDateVersion.firstSharedDate != null && contractToSave.firstSharedDate != null && mostUpToDateVersion.firstSharedDate != contractToSave.firstSharedDate) {
            store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, "Changes were made to this contract. Please refresh this page and review the contract again before signing."));
          } else {
            store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, "Please sign the contract before saving your signature."));
          }
        }
        store.dispatch(SetLoadingStateAction(store.state.clientPortalPageState, false));
      } else {
        if(action.signature != null && action.signature!.isNotEmpty && mostUpToDateVersion.firstSharedDate != null && contractToSave.firstSharedDate != null && mostUpToDateVersion.firstSharedDate != contractToSave.firstSharedDate) {
          store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, "Changes were made to this contract. Please refresh this page and review the contract again before signing."));
          store.dispatch(SetLoadingStateAction(store.state.clientPortalPageState, false));
        } else {
          ClientPortalRepository repository = ClientPortalRepository(functions: DandylightFunctionsApi(httpClient: http.Client()));
          int errorCode = await repository.saveClientSignature(action.pageState!.userId!, action.pageState!.jobId!, action.signature!, contractToSave.documentId!);
          if(errorCode != 200) {
            store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, "There was an error saving your signature. Please try again."));
          } else {
            contractToSave.clientSignature = action.signature;
            contractToSave.signedByClient = true;
            contractToSave.clientSignedDate = DateTime.now();

            if(action.pageState!.job!.proposal!.contracts == null) action.pageState!.job!.proposal!.contracts = [];

            int indexToUpdate = proposal.contracts!.indexWhere((item) => item.documentId == contractToSave.documentId);
            proposal.contracts![indexToUpdate] = contractToSave;

            action.pageState!.job!.proposal = proposal;
            store.dispatch(SetJobAction(store.state.clientPortalPageState, action.pageState!.job));
            store.dispatch(SetProposalAction(store.state.clientPortalPageState, proposal));
            EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CONTRACT_SIGNED);
          }
          store.dispatch(SetLoadingStateAction(store.state.clientPortalPageState, false));
        }
      }
    }
  }

  void _updateProposalInvoicePaid(Store<AppState> store, UpdateProposalInvoicePaidAction action, NextDispatcher next) async{
    Invoice invoice = action.pageState!.invoice!;
    invoice.invoicePaid = action.isPaid;
    if(action.isPaid!) {
      invoice.balancePaidAmount = invoice.unpaidAmount;
      invoice.unpaidAmount = invoice.calculateUnpaidAmount();
    } else {
      invoice.balancePaidAmount = 0.0;
      invoice.unpaidAmount = invoice.total! - (invoice.depositPaid! ? invoice.depositAmount! : 0.0);
    }

    store.dispatch(SetInvoiceAction(store.state.clientPortalPageState, invoice));

    if(!action.pageState!.isBrandingPreview!) {
      ClientPortalRepository repository = ClientPortalRepository(functions: DandylightFunctionsApi(httpClient: http.Client()));
      await repository.updateInvoiceAsPaid(
        action.pageState!.userId!,
        action.pageState!.jobId!,
        action.pageState!.invoice!.documentId!,
        action.isPaid!,
        invoice.balancePaidAmount!,
        invoice.unpaidAmount!,
      );
      EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_TOTAL_MARKED_AS_PAID);
    }
  }

  void _updateProposalInvoiceDepositPaid(Store<AppState> store, UpdateProposalInvoiceDepositPaidAction action, NextDispatcher next) async{
    if(!action.pageState!.invoice!.invoicePaid!) {
      Invoice invoice = action.pageState!.invoice!;
      invoice.depositPaid = action.isPaid;
      if(action.isPaid!) {
        invoice.unpaidAmount = invoice.unpaidAmount! - invoice.depositAmount!;
      } else {
        invoice.unpaidAmount = invoice.unpaidAmount! + invoice.depositAmount!;
      }
      store.dispatch(SetInvoiceAction(store.state.clientPortalPageState, invoice));

      if(!action.pageState!.isBrandingPreview!) {
        ClientPortalRepository repository = ClientPortalRepository(functions: DandylightFunctionsApi(httpClient: http.Client()));
        await repository.updateInvoiceAsDepositPaid(
            action.pageState!.userId!,
            action.pageState!.jobId!,
            action.pageState!.invoice!.documentId!,
            action.isPaid!,
            invoice.unpaidAmount!
        );
        EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_DEPOSIT_MARKED_AS_PAID);
      }
    }
  }

  Invoice buildExampleInvoice() {
    return Invoice(
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
  }

  Proposal buildExampleProposal(String? jsonContract, String? photographerName) {
    if(photographerName == null || photographerName.isEmpty) photographerName = 'Photographer Name';
    return Proposal(
      includePoses: true,
      includeContract: true,
      includeInvoice: true,
      includeQuestionnaires: true,
      detailsMessage: 'Hi (Client first name), \nWe\'re delighted to welcome you as our newest client at [Your Photography Studio Name] and look forward to capturing beautiful moments together.\n\nBefore we embark on this exciting journey, please take a moment to review and sign our photography contract. It outlines essential details to ensure a smooth experience.\n\nSelect the document icon below to view and sign the contract.\n\nFeel free to reach out if you have any questions. Once the contract is signed, we\'ll be all set to bring your vision to life.\n\nThank you for choosing us, and we can\'t wait to create lasting memories with you.\n\nBest regards,\n$photographerName',
      contract: Contract(
          photographerSignedDate: DateTime.now(),
          clientSignedDate: DateTime.now(),
          signedByClient: false,
          signedByPhotographer: true,
          clientSignature: '',
          photographerSignature: 'Your Name',
          contractName: 'Wedding Contract',
          terms: 'Disclaimer:This template is offered solely for your convenience and may not cater to your specific needs. It is crucial to understand that this template does not replace the need for legal advice. By providing this sample, neither Pixieset nor its affiliates commit to offering additional information or updating this template or rectifying any errors or omissions within it. Any user should consult their legal advisor for precise legal guidance. Pixieset and its affiliates disclaim any liability arising from or connected to the utilization of this template agreement (or any part thereof).Using this Template:Complete all mandatory fields and highlighted sections.Remove any clauses that do not apply to your business.Ensure thorough comprehension of all contents.Remove this section and the above disclaimer.Wedding Photography Services AgreementThis AGREEMENT, as of September 26, 2023 (the "Effective Date"), is established between Jason Bent ("Client") and Vintage Vibes Photography ("Photographer").1. Engagement of Photographer1.1 Services. Subject to the provisions outlined herein, Client contracts Photographer to offer, and Photographer accepts the responsibility to provide, the photography services delineated in this Section 1.1 (the "Services") in conjunction with the wedding of Jason Bent and the Clients partner (the "Wedding").Wedding Date: Date of the weddingWedding Venue: Wedding locationService Description:[Enter service description]Within the scope of the Services, the Photographer will generate or take comparable actions to create materials from Images and provide associated deliverables (as described above) as part of the Services ("Work Product"). "Images" encompasses photographic content, whether static or moving, produced by Photographer as per this Agreement and encompasses, but is not restricted to, transparencies, negatives, prints, or digital files, captured, recorded, stored, or delivered in any medium, be it analog, photographic, optical, electronic, magnetic, digital, or any other.1.2 Exclusivity. Client recognizes and agrees that Photographer will be the sole provider of the Services covering the Wedding unless otherwise mutually agreed upon in writing by both parties.2. Fees and Deposit2.1 Fees. Client will remunerate Photographer in accordance with the fees set forth in this Section 2.1 ("Fees"), inclusive of any applicable federal or state/provincial sales or value-added taxes due on these Fees.Total Fee for Services: [XXXX]Additional Hourly Rate: [XXXX/hour]Deposit due upon agreement: [XXXX]Remaining balance due on [Final Due Date]: [XXXX]2.2 Deposit. Client acknowledges and accepts that the deposit amount specified above is payable upon the signing of this Agreement and is non-refundable ("Deposit"). This payment serves to fairly compensate Photographer for dedicating time to deliver the Services and for declining other potential projects or clients. Both parties concur that the Deposit will be applied toward the total Fees due from Client.2.3 Invoice. Photographer will issue an invoice to Client upon mutual agreement of the Services ("Invoice"). Client commits to settling all outstanding Fees on or before the due dates specified in Section 2.1. Any payment made after the due date will incur a late fee of [X%] per month on the unpaid balance. Client acknowledges that the final payable amount may be subject to change based on actual incurred expenses. Client confirms and agrees that the final calculations presented in the Invoice, if different from the total listed in Section 2.1, shall represent the ultimate amount due.3. Client Responsibilities3.1 Necessary Consents. Client is responsible for obtaining all necessary consents, as applicable, before the commencement of the Services. This includes consents required for the execution of Services and the delivery of Work Product by Photographer. Additionally, any consents needed from venues or locations where the Services will be conducted or from Wedding attendees must also be secured.3.2 Expenses. Client will either provide necessary means of travel or assume responsibility for reasonable travel expenses incurred by Photographer that are essential for the performance of the Services or travel requested by Client when the location of the Services is outside the city of [City Name]. Client is also liable for any other expenses incurred by Photographer that are necessary for the execution of the Services as detailed in Article 2.3.3 Meals. When the anticipated duration of Photographers Services exceeds [X hours], Client will either provide a meal for Photographer and Photography Staff (including employees, assistants, or other parties engaged by Photographer to assist with the Services) or be responsible for reasonable meal expenses incurred. Photographer will provide an invoice for such expenses.3.4 Waiver. Client (on behalf of themselves and any individuals whose images or recordings may be captured during the Services) hereby relinquishes all rights and claims and releases Photographer from any claims or legal actions, whether known or unknown, relating to the sale, display, license, use, and exploitation of Images pursuant to this Agreement.4. Photographer Responsibilities4.1 Equipment. Client is not obliged to provide any photography equipment to Photographer.4.2 Service Approach. Photographer will ensure that the Services are executed in a professional, efficient, skilled, and safe manner, with minimal disruption to Clients activities.4.3 Photography Staff. Photographer will ensure that all Photography Staff (including employees, assistants, or other parties assisting with the Services):Adhere to Clients reasonable directives concerning the safety of Wedding attendees and applicable health, safety, and security requirements at Service locations.Ensure that Work Product aligns with the specifications detailed in Section 1.1 to the best of their abilities.Photographer assumes full responsibility for the actions of all Photography Staff.5. Artistic Release5.1 Consistency. Photographer will make reasonable efforts to produce the Services in a style consistent with their current portfolio. They will also work closely with Client and consider any reasonable suggestions.5.2 Style. Client acknowledges and accepts that:Client has reviewed Photographers prior work and portfolio and expects Photographer to execute the Services in a similar style.Photographer will exercise artistic judgment in providing the Services, and their artistic judgment shall be final regarding the aesthetic and artistic quality of the Services.Disagreement with Photographers aesthetic judgment or artistic abilities does not constitute valid grounds for terminating this Agreement or requesting refunds.6. Term and Termination6.1 Term. This Agreement initiates on the Effective Date and continues until the later of (i) the date when all outstanding Fees under this Agreement are fully paid; or (ii) the date when all final Work Product has been delivered (the "Term").6.2 Cancellation. Client may terminate this Agreement ("Cancellation") and/or reschedule the Services ("Rescheduling") by providing Photographer with written notice at least [X days] prior to the originally scheduled Wedding date (the "Minimum Notice"). Client acknowledges and agrees that Cancellation or Rescheduling does not absolve Client of any payment obligations unless the Minimum Notice in accordance with this Article 6 is duly provided or unless both parties agree otherwise in writing.6.3 Rescheduling. In the event of Rescheduling, Photographer will make commercially reasonable efforts to accommodate Clients request. If Photographer cannot accommodate the Rescheduling despite best efforts, both parties agree that the Rescheduling will be considered a Cancellation by Client, and Photographer will not be obligated to perform the Services on any date other than the original Wedding date.6.4 No Refund. Client acknowledges and agrees that Cancellation by Client will not result in a refund of any fees paid up to the date of Cancellation.6.5 Replacement. If Photographer is unable to perform the Services, Photographer may, subject to Clients consent (which shall not be unreasonably withheld), arrange for a replacement photographer to fulfill the Services in accordance with this Agreement. If such consent is not obtained, Photographer shall terminate this Agreement, refund the Deposit and all fees paid by Client, and thereafter have no further liability to Client.7. Ownership of Work Product by Photographer7.1 Ownership of Work. Photographer will retain all rights, titles, and interests in all Work Product. Client (on behalf of themselves and any Wedding attendees) hereby grants Photographer and any service providers an exclusive, royalty-free, worldwide, irrevocable, transferable, and sublicensable license to use any materials created by Client or attendees during the Services that may be protected by copyright or any intellectual property rights ("Wedding Materials") as part of any Work Product or in connection with the marketing, advertising, or promotion of Photographers services, including in Photographers studio, portfolio, website, or social media, in any format or medium. Client acknowledges that no other party has any rights that may hinder or restrict Photographers use of Wedding Materials as outlined herein.8. Limited License to Client8.1 Personal Use. Photographer grants Client an exclusive, limited, irrevocable, royalty-free, non-transferable, and non-sublicensable license to use Work Product for Clients Personal Use. This license includes, but is not limited to, the use of photos on Clients personal social media profiles, personal creations such as scrapbooks or personal gifts, non-commercial physical displays, and personal communications like family newsletters, emails, or holiday cards. Client may not use the Work Product for any other purposes without Photographers prior written consent, including but not limited to commercial sale.9. Indemnity and Limitation of Liability9.1 Indemnification. Client agrees to indemnify, defend, and hold harmless Photographer and its affiliates, employees, agents, and independent contractors from any injury, property damage, liability, claim, or other cause of action arising from or related to the Services and Work Product provided by Photographer.9.2 Force Majeure. Neither party shall be held in breach of or liable under this Agreement for any delay or non-performance due to conditions beyond their control, such as illness, emergencies, fires, strikes, pandemics, earthquakes, or other Force Majeure Events. If a Force Majeure Event persists for over 60 days, the unaffected party may terminate the Agreement, and any prepaid fees for unperformed Services (except the Deposit) shall be refunded within 15 days of termination.9.3 Failure to Deliver. Photographer shall not be liable for delays in the delivery of Work Product or for Work Product that is undeliverable due to technological malfunctions or service interruptions beyond Photographers control. Additionally, Photographer shall not be held responsible for Work Product that fails to meet the specifications outlined in Section 1.1 due to actions by Client or Wedding attendees beyond Photographers control (e.g., camera flashes).9.4 Maximum Liability. Client agrees that Photographers maximum liability related to the Services or Work Product shall not exceed the total Fees payable under this Agreement.10. General10.1 Notice. Parties shall provide effective notice to each other using the following contact information:Photographer’s Email: Vintagevibesphotography@gmail.comClient’s Email: jbent@gmail.com10.2 Survival. Articles 7, 8, 9, and 10 shall remain in force even after the termination of this Agreement.10.3 Governing Law. This Agreement shall be governed by the laws of [Your Business State].10.4 Amendment. This Agreement may only be amended, supplemented, or otherwise modified by written agreement signed by both parties.10.5 Entire Agreement. This Agreement constitutes the entire agreement between the parties regarding the Services and supersedes all previous formal and informal agreements and understandings.',
          jsonTerms: jsonContract,
      ),
      questionnaires: [
        Questionnaire(
          isComplete: false,
          isTemplate: false,
          isReviewed: false,
          title: "Engagement Session",
          questions: [
            Question(
              id: '1',
              addressRequired: true,
              cityTownRequired: true,
              countryRequired: true,
              includeFirstName: true,
              includeLastName: true,
              includeEmail: true,
              includePhone: true,
              includeInstagramName: true,
              mobileImageUrl: "https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FICUeVNh1gAcElqBowOL24lPC1Sm1%2Fquestions%2F66a6cbef-1fa7-4b67-957f-d3b5211387b9questionMobileImage.jpg?alt=media&token=b0731a71-ea4f-4c52-b093-0f3d6638ea04",
              showImage: true,
              stateRegionProvinceRequired: true,
              type: "Contact info",
              zipPostCodeRequired: true,
              question: 'Please provide your contact information.'
            ),
            Question(
              id: '2',
              choicesCheckBoxes: [
                'Text/sms',
                'Email'
              ],
              isRequired: true,
              multipleSelection: false,
              question: 'What form of communication do you prefer?',
              showImage: false,
              type: 'Checkboxes'
            ),
            Question(
              id: '3',
              type: 'Long response',
              isRequired: true,
              showImage: false,
              question: 'How did you and your partner meet?',
            ),
            Question(
              id: '4',
              type: 'Long response',
              isRequired: true,
              showImage: false,
              question: 'Do you have a special connection to any particular locations or settings for the session?',
            ),
            Question(
              id: '5',
              type: "Yes/No",
              isRequired: true,
              showImage: false,
              question: 'Do you plan on having multiple outfits?',
              yesSelected: true,
            ),
            Question(
              id: '6',
              type: 'Long response',
              isRequired: true,
              showImage: false,
              question: 'Tell us the story of your proposal, please include the location and all the details.',
            ),
            Question(
              id: '7',
              type: 'Long response',
              isRequired: true,
              showImage: false,
              question: 'What things do you love most about your partner?',
            ),
            Question(
              id: '8',
              type: 'Long response',
              isRequired: true,
              showImage: false,
              question: 'What things does your partner live most about you? (For your partner to answer)',
            ),
            Question(
                id: '9',
                choicesCheckBoxes: [
                  'Rustic',
                  'Woods/Forest',
                  'Beach',
                  'River/Natural spring',
                  'Open fields',
                  'Metro/Downtown area',
                  'Coffee shop',
                  'Lifestyle/In home',
                  'Fair/Carnival',
                  'Destination/Out of state',
                  'Other/None of the above'
                ],
                isRequired: true,
                multipleSelection: true,
                question: 'Please select all locations that sound appealing for your session:',
                showImage: false,
                type: 'Checkboxes'
            ),
            Question(
              id: '10',
              type: 'Long response',
              isRequired: true,
              showImage: false,
              question: 'Do you have a theme in mind? If you have a Pinterest board with ideas, please share the link for the board.',
            ),
            Question(
              id: '11',
              type: 'Long response',
              isRequired: true,
              showImage: false,
              question: 'Please share anything else you think we should know.',
            ),
          ]
        ),
        Questionnaire(
          isComplete: false,
          isTemplate: false,
          isReviewed: false,
          title: "Feedback",
          questions: [
            Question(
              id: '1',
              isRequired: true,
              type: 'Rating',
              showImage: true,
              mobileImageUrl: 'https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FICUeVNh1gAcElqBowOL24lPC1Sm1%2Fquestions%2F4cd1b78d-e9c0-4ba9-8baa-98499b17d193questionMobileImage.jpg?alt=media&token=a39ef146-7459-4e48-9f6e-15796391da1e',
              question: 'How satisfied are you with the overall experience of working with me?'
            ),
            Question(
                id: '2',
                isRequired: true,
                type: 'Rating',
                showImage: false,
                question: 'How would you rate the communication with me before, during and after the session?'
            ),
            Question(
                id: '3',
                isRequired: true,
                type: 'Rating',
                showImage: false,
                question: 'How would you rate my professionalism during the shoot?'
            ),
            Question(
                id: '4',
                isRequired: true,
                type: 'Rating',
                showImage: false,
                question: 'How satisfied are you with the quality of the final images?'
            ),
            Question(
                id: '6',
                choicesCheckBoxes: [
                  'Meet',
                  'Exceeded!',
                  'Did not meet'
                ],
                isRequired: true,
                multipleSelection: false,
                question: 'Did the final images meet or exceed your expectations?',
                showImage: false,
                type: 'Checkboxes'
            ),
            Question(
              id: '7',
              type: "Yes/No",
              isRequired: true,
              showImage: false,
              question: 'Did I effectively capture the style or mood you were looking for in the photos?',
              yesSelected: true,
            ),
            Question(
              id: '8',
              type: "Yes/No",
              isRequired: true,
              showImage: false,
              question: 'Do you feel the pricing for the session was fair and reasonable?',
              yesSelected: true,
            ),
            Question(
              id: '9',
              type: "Yes/No",
              isRequired: true,
              showImage: false,
              question: 'Would you consider hiring me again for future photography needs based on the value received?',
              yesSelected: true,
            ),
            Question(
              id: '10',
              type: 'Long response',
              isRequired: true,
              showImage: false,
              question: 'Is there anything I could do to improve my service?',
            )
          ]
        ),
      ],
    );
  }

  Job buildExampleJob() {
    return Job(
      selectedDate: DateTime.now(),
      selectedTime: DateTime.now(),
      selectedEndTime: DateTime.now().add(Duration(hours: 1)),
      clientName: 'Client Name',
      client: Client(
          firstName: 'Client',
          lastName: 'Name',
          email: 'clientEmail@gmail.com',
          phone: '(888)888-8888',
      ),
      location: LocationDandy.LocationDandy(
        address: '47781 Monte St. Temecula CA 92591',
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
  }

  Job populateContractsWithJobData(Job job, Profile profile) {
    if(job.proposal!.contract != null && (job.proposal!.contracts == null || job.proposal!.contracts!.isEmpty)) {
      if(job.proposal!.contracts == null) job.proposal!.contracts = [];
      job.proposal!.contracts!.add(job.proposal!.contract!);
    }

    List<Contract> contractsToShowUser = [];
    for(Contract contract in job.proposal!.contracts!) {
      if((contract.isVoid ?? false) && !(contract.signedByClient ?? false)) {
        //Do not show to photographer client
      } else {
        contractsToShowUser.add(contract);
      }
    }

    job.proposal!.contracts = contractsToShowUser;

    if(job.proposal!.contracts != null) {
      for(Contract contract in job.proposal!.contracts!) {
        String populatedJsonTerms = ContractUtils.populate(contract, profile, job);
        contract.jsonTerms = populatedJsonTerms;
      }
    }
    return job;
  }

  void replaceAll(quill.Document document, String item, String replacement) {
    while((document.search(item)).length > 0) {
      int matchOffset = document.search(item).first;
      document.replace(matchOffset, item.length, replacement);
    }
  }
}