import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/ColorConstants.dart';
import '../ClientPortalPageState.dart';
import 'package:redux/redux.dart';

class ContractPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContractPageState();
  }
}

class _ContractPageState extends State<ContractPage> {
  TextEditingController _clientSignatureController = TextEditingController();
  bool isHoveredSubmit = false;
  bool isHoveredDownloadPDF = false;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ClientPortalPageState>(
        onInit: (current) {
          _clientSignatureController.text = current.state.clientPortalPageState.proposal.contract.clientSignature;
        },
        onDidChange: (previous, current) {
          if(previous.errorMsg.isEmpty && current.errorMsg.isNotEmpty) {
            DandyToastUtil.showErrorToast(current.errorMsg);
            current.resetErrorMsg();
          }
        },
        converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
        builder: (BuildContext context, ClientPortalPageState pageState) =>
            Container(
              alignment: Alignment.topCenter,
              width: 1080,
              color: Color(ColorConstants.getPrimaryWhite()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 32, bottom: 48),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Client Service Agreement',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24, right: 16),
                        alignment: Alignment.centerRight,
                        width: 1080,
                        child: MouseRegion(
                          child: GestureDetector(
                            onTap: () {
                              pageState.onDownloadContractSelected();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 116 : 48,
                              height: 48,
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Color(ColorConstants.getPeachDark())),
                              child: Row(
                                mainAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 24,
                                    width: 24,
                                    child: Image.asset(
                                      "images/icons/download.png",
                                      color:
                                          Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                  DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'PDF',
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    isBold: isHoveredDownloadPDF,
                                  ) : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          cursor: SystemMouseCursors.click,
                          onHover: (event) {
                            setState(() {
                              isHoveredDownloadPDF = true;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              isHoveredDownloadPDF = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 64, left: 32, right: 32),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: pageState.proposal.contract.terms,
                      isBold: false,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 32, left: 32, right: 32),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'I acknowledge that I have read and understood the contents of this agreement, and I hereby agree to all the terms and conditions outlined within it by signing this document.',
                      isBold: true,
                    ),
                  ),
                  DeviceType.getDeviceTypeByContext(context) == Type.Website
                      ? Row(
                          children: signatures(pageState),
                        )
                      : Column(
                          children: signatures(pageState),
                        ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: MouseRegion(
                      child: GestureDetector(
                        onTap: () {
                          if(!pageState.proposal.contract.signedByClient) {
                            pageState.onClientSignatureSaved(_clientSignatureController.text);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 48,
                          margin: EdgeInsets.only(bottom: 0, top: 32, right: 32),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(pageState.proposal.contract.signedByClient ? ColorConstants.getPrimaryBackgroundGrey() : ColorConstants.getPeachDark())),
                          child: pageState.isLoading ? LoadingAnimationWidget.fourRotatingDots(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            size: 26,
                          ) : TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: pageState.proposal.contract.signedByClient ? 'Signature Saved' : 'Save Signature',
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                      cursor: pageState.proposal.contract.signedByClient ? SystemMouseCursors.basic : SystemMouseCursors.click,
                      onHover: (event) {
                        if(!pageState.proposal.contract.signedByClient) {
                          setState(() {
                            isHoveredSubmit = true;
                          });
                        }
                      },
                      onExit: (event) {
                        if(!pageState.proposal.contract.signedByClient) {
                          setState(() {
                            isHoveredSubmit = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 164,
                  )
                ],
              ),
            ),
      );

  List<Widget> signatures(ClientPortalPageState pageState) {
    return [
      Container(
        width: 410,
        margin: EdgeInsets.only(bottom: 64, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Date: ',
                    isBold: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text:
                    DateFormat('EEE, MMMM dd, yyyy').format(pageState.proposal.contract.photographerSignedDate),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Photographer Name: ',
                    isBold: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: pageState.profile.firstName + ' ' + pageState.profile.lastName,
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Photographer Signature:',
                textAlign:
                    DeviceType.getDeviceTypeByContext(context) == Type.Website
                        ? TextAlign.start
                        : TextAlign.center,
                isBold: true,
              ),
            ),
            TextFormField(
              initialValue: pageState.profile.firstName + ' ' + pageState.profile.lastName,
              enabled: false,
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                  fontFamily: 'Sig',
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryBlack())),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryBlack())),
                ),
              ),
            )
          ],
        ),
      ),
      Container(
        width: 410,
        margin: EdgeInsets.only(bottom: 64, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Date: ',
                    isBold: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: DateFormat('EEE, MMMM dd, yyyy').format(pageState.proposal.contract.clientSignedDate != null ? pageState.proposal.contract.clientSignedDate : DateTime.now()),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Client Name: ',
                    isBold: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: pageState.job.client.getClientFullName(),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Client Signature:',
                textAlign:
                    DeviceType.getDeviceTypeByContext(context) == Type.Website
                        ? TextAlign.start
                        : TextAlign.center,
                isBold: true,
              ),
            ),
            TextField(
              enabled: !pageState.proposal.contract.signedByClient,
              controller: _clientSignatureController,
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                  fontFamily: 'Sig',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(ColorConstants.getPrimaryBlack())),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryBlack())),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(ColorConstants.getPrimaryBlack())),
                ),
              ),
            )
          ],
        ),
      )
    ];
  }

  String contract = 'Photography Services Contract  \n' +
      '  THIS AGREEMENT is entered into as of July 4, 2023 (the "Effective Date") by and between Jason Bent, having a primary contact address at Client AddressClient Address FILL ("Client"), and Vintage Vibes Photography ("Photographer").  \n' +
      '    \n' +
      '  Engagement of Photographer  \n' +
      '  1.1 Provision of Services. Client hereby engages Photographer to render and Photographer agrees to provide the photography services described in this Section 1.1 (referred to as the "Services"), subject to the terms and conditions set forth herein.  \n' +
      '  Description of Services:  \n' +
      '    \n' +
      '  [Provide a detailed description of the services]  \n' +
      '    \n' +
      '  As part of the Services, Photographer shall create materials from Images or take similar actions to produce deliverables as outlined above, which shall be considered the "Work Product." For the purposes of this Agreement, "Images" refers to photographic material, both still and moving, generated by Photographer under this Agreement, encompassing transparencies, negatives, prints or digital files captured, recorded, stored or delivered in any form or medium, including but not limited to analogue, photographic, optical, electronic, magnetic, or digital formats.  \n' +
      '    \n' +
      '  1.2 Exclusivity. It is agreed that Photographer shall be the sole provider of the Services, unless otherwise mutually agreed upon in writing by the parties.  \n' +
      '    \n' +
      '  Fees and Payment  \n' +
      '  2.1 Compensation. Client shall remit the fees specified in this Section 2.1 ("Fees"), inclusive of any applicable federal or state/provincial sales or value-added taxes due on said Fees, to Photographer.  \n' +
      '  Total Service Fee: \$400  \n' +
      '    \n' +
      '  Additional Hourly Rate: \$5/hour  \n' +
      '    \n' +
      '  Retainer Payment upon execution: \$40  \n' +
      '    \n' +
      '  Remaining balance due by [Final Due Date]: \$400  \n' +
      '    \n' +
      '  2.2 Retainer. Client acknowledges that the retainer amount indicated above, payable upon execution of this Agreement, is non-refundable ("Retainer"). The Retainer serves as fair compensation to Photographer for dedicating time to providing the Services and for foregoing other potential projects or clients. Both parties agree that the Retainer shall be credited toward the total Fees payable by Client.  \n' +
      '    \n' +
      '  2.3 Invoice. Upon acceptance of the Services, Photographer shall issue an invoice ("Invoice") to Client. Client agrees to remit all outstanding Fees on or before the due dates specified in Section 2.1. Late payments shall incur a monthly late fee of [X%] on the outstanding balance. Client acknowledges that the final amount payable may be subject to change based on actual expenses incurred. Client confirms and agrees that the final amount indicated in the Invoice, even if different from the total listed in Section 2.1, shall be considered the final payment.  \n' +
      '    \n' +
      '  Client Responsibilities  \n' +
      '  3.1 Necessary Consents. Client shall ensure that all required consents, if applicable, are obtained prior to the commencement of the Services. This includes obtaining consents for the performance of Services, delivery of Work Product by Photographer, and any consents required from venues, locations, attendees, or participants involved in the photo shoot.  \n' +
      '  3.2 Expenses. Client shall either provide means of travel or be responsible for reasonable travel expenses incurred by Photographer that are necessary for the provision of Services, or as requested by Client if the Services are to be performed outside the city of [City Name]. Additionally, Client shall be responsible for any other necessary expenses incurred by Photographer, as specified in Article 2.  \n' +
      '    \n' +
      '  3.3 Waiver. Client, on behalf of themselves and any other individual whose image or recording may be captured during the Services, hereby waives all rights and claims and releases Photographer from any claims or causes of action, whether presently known or unknown, relating to the sale, display, license, use, or exploitation of Images under this Agreement.  \n' +
      '    \n' +
      '  Photographer Responsibilities  \n' +
      '  4.1 Equipment. Photographer shall not require Client to provide any photography equipment.  \n' +
      '  4.2 Service Standards. Photographer shall perform the Services in a proficient, timely, and safe manner, ensuring minimal interference with Client\'s activities.  \n' +
      '    \n' +
      '  4.3 Photography Staff. Photographer and any Photography Staff (employees, assistants, or other individuals engaged by Photographer to assist with the Services) shall:  \n' +
      '    \n' +
      '  Adhere to Client\'s reasonable directions concerning the safety of photo shoot attendees or participants, as well as applicable health, safety, and security requirements at the shoot locations.  \n' +
      '  Ensure that the Work Product meets the specifications outlined in Section 1.1 to a satisfactory extent.  \n' +
      '  Photographer shall be accountable for the actions of all Photography Staff.  \n' +
      '    \n' +
      '  Artistic Release  \n' +
      '  5.1 Consistency. Photographer shall make reasonable efforts to produce the Services in a manner consistent with their existing portfolio and style. Photographer shall also consult with Client and consider any reasonable suggestions.  \n' +
      '  5.2 Client Acknowledgment. Client acknowledges and agrees to the following:  \n' +
      '    \n' +
      '  Client has reviewed Photographer\'s previous work and portfolio and has a reasonable expectation that the Services shall be rendered in a similar style.  \n' +
      '  Photographer shall exercise artistic judgment when providing the Services and shall have final authority regarding the aesthetic and artistic quality of the Services.  \n' +
      '  Disagreements with Photographer\'s aesthetic judgment or artistic ability shall not constitute valid grounds for terminating this Agreement or requesting a refund.  \n' +
      '  Term and Termination  \n' +
      '  6.1 Duration. This Agreement shall commence on the Effective Date and shall remain in effect until the later of (i) the date on which all outstanding Fees under this Agreement are fully paid; or (ii) the date on which all final Work Product has been delivered ("Term").  \n' +
      '  6.2 Cancellation. Client may terminate this Agreement ("Cancellation") or request a rescheduling of the Services ("Rescheduling") by providing written notice to Photographer no later than [X days] prior to the original Service date (referred to as the "Minimum Notice"). Client acknowledges and agrees that payment obligations shall not be waived for Cancellations or Rescheduling unless Minimum Notice, as outlined in this Article 6, is duly provided or unless otherwise mutually agreed upon in writing by the parties.  \n' +
      '    \n' +
      '  6.3 Rescheduling. In the event of a Rescheduling, Photographer shall make commercially reasonable efforts to accommodate Client\'s request. If Photographer is unable to fulfill the revised date despite reasonable efforts, the Rescheduling shall be treated as a Cancellation by Client, and Photographer shall have no obligation to perform the Services other than on the original date.  \n' +
      '    \n' +
      '  6.4 Refund Policy. Client acknowledges and agrees that Cancellation by Client shall not entitle them to a refund of any fees paid prior to the Cancellation date.  \n' +
      '    \n' +
      '  6.5 Replacement Photographer. If Photographer is unable to provide the Services, Photographer may, with Client\'s consent (which shall not be unreasonably withheld), arrange for a substitute photographer to fulfill the Services as per this Agreement. In the event that consent is not obtained, Photographer may terminate this Agreement, refund the Retainer and any fees already paid by Client, and shall bear no further liability towards Client.  \n' +
      '    \n' +
      '  Ownership of Work Product by Photographer  \n' +
      '  7.1 Work Ownership. Photographer shall retain all rights, title, and interest in the Work Product. Client (on behalf of themselves and any attendees or participants at the photo shoot) grants Photographer and any of its service providers an exclusive, royalty-free, worldwide, irrevocable, transferable, and sublicensable license to use any Client Materials (i.e., materials created by Client or attendees during the Services that may be protected by copyright or other intellectual property rights) as part of the Work Product or in connection with the marketing, advertising, or promotion of Photographer\'s services. This includes use in connection with Photographer\'s studio, portfolio, website, or social media, across all formats and mediums. Client confirms that no other person or entity possesses rights that may impede or restrict Photographer from utilizing Client Materials as specified herein.  \n' +
      '    \n' +
      '  Limited License to Client  \n' +
      '  8.1 Personal Use. Photographer grants Client an exclusive, limited, irrevocable, royalty-free, non-transferable, and non-sublicensable license to use the Work Product for personal use ("Personal Use"). Personal Use includes, but is not limited to, utilizing photos on personal social media pages or profiles, incorporating them into personal creations (e.g., scrapbooks, albums, or personal gifts), displaying them non-commercially, and utilizing them in personal communications (e.g., family newsletters, emails, or holiday cards). Client shall not make any other use of the Work Product without prior written consent from Photographer, including commercial use or sale.  \n' +
      '    \n' +
      '  Indemnity and Limitation of Liability  \n' +
      '  9.1 Indemnification. Client agrees to indemnify, defend, and hold harmless Photographer, its affiliates, employees, agents, and independent contractors from any injury, property damage, liability, claim, or other cause of action arising from or related to the Services or Work Product provided by Photographer.  \n' +
      '    \n' +
      '  9.2 Force Majeure. Neither party shall be deemed in breach or liable under this Agreement for any delay or non-performance of obligations caused by illness, emergency, fire, strike, pandemic, earthquake, or any other conditions beyond the reasonable control of the non-performing party (each a "Force Majeure Event"). The time for performing such obligations, if applicable, shall be extended for a duration equal to the conditions preventing performance. If a Force Majeure Event persists for more than 60 days, the non-affected party may terminate the Agreement, and any prepaid fees for unperformed Services (excluding the Retainer) shall be returned within 15 days of the termination date.  \n' +
      '    \n' +
      '  9.3 Failure to Deliver. Photographer shall not be held liable for delays in delivering the Work Product or for undeliverable Work Product due to technological malfunctions, service interruptions beyond Photographer\'s control (including delays in receiving instructions from Client), or Work Product failing to meet the specifications in Section 1.1 due to actions by Client or photo shoot attendees/participants beyond Photographer\'s control (e.g., camera flashes).  \n' +
      '    \n' +
      '  9.4 Maximum Liability. Notwithstanding anything to the contrary, Client agrees that Photographer\'s maximum liability arising from the Services or Work Product shall not exceed the total Fees payable under this Agreement.  \n' +
      '    \n' +
      '  General  \n' +
      '  10.1 Notice. Parties shall deliver effective notices ("Notice") to each other via either of the following methods:  \n' +
      '  Photographer\'s Email: Vintagevibesphotography@gmail.com  \n' +
      '    \n' +
      '  Client\'s Email: jbent@gmail.com  \n' +
      '    \n' +
      '  10.2 Survival. Articles 7, 8, 9, and 10 shall survive the termination of this Agreement.  \n' +
      '    \n' +
      '  10.3 Governing Law. This Agreement shall be governed by the laws of [State/Country].  \n' +
      '    \n' +
      '  10.4 Amendment. This Agreement may only be amended, supplemented, or otherwise modified through a written agreement signed by both parties.  \n' +
      '    \n' +
      '  10.5 Entire Agreement. This Agreement constitutes the entire agreement between the parties regarding the Services and supersedes all prior agreements and understandings, whether formal or informal.  \n' +
      '    \n' +
      '  10.6 Severability. If any provision of this Agreement is deemed illegal, invalid, or unenforceable in whole or in part by an arbitrator or a court of competent jurisdiction, that provision or part thereof shall be severed from this Agreement, and the remaining provisions shall continue to be in full force and effect.  \n';
}
