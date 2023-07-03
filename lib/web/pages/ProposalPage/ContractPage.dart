import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';

import '../../../utils/ColorConstants.dart';
import '../../../widgets/DividerWidget.dart';

class ContractPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContractPageState();
  }
}

class _ContractPageState extends State<ContractPage> {
  bool isHoveredDirections = false;

  @override
  Widget build(BuildContext context) =>
      Container(
        alignment: Alignment.topCenter,
        width: 1080,
        color: Color(ColorConstants.getPrimaryWhite()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 32, bottom: 48),
              child: TextDandyLight(
                type: TextDandyLight.EXTRA_LARGE_TEXT,
                text: 'Contract',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16, left: 32, right: 32),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: contract,
              ),
            ),
          ],
        ),
      );

  String contract = '1. Scope of Work:\n'+
  'PHOTOGRAPHER and CLIENT are to arrive for the PHOTOSHOOT at the agreed time and location which will be confirmed 7 days prior to the photoshoot. Refer to the invoice for details regarding products, inclusions, and fees.\n'+
  '\n'+
  '2. Retainer and payment:\n'+
  'Upon your signature, PHOTOGRAPHER will reserve the time and date agreed upon, and will not make other reservations for that time and date. The CLIENT shall make a non-refundable retainer of 50% to the PHOTOGRAPHER to perform the services specified in the invoice.\n'+
  '\n'+
  'Upon payment, PHOTOGRAPHER will reserve the time and date agreed upon by both parties exclusively for you. The full amount + any agreed upon additional travel fees must be paid at least 7 days prior to the date of PHOTOSHOOT. No services will be made until full payment is made. In the event that payment is dishonoured after payment has been made, no photos shall be released until a substitute full payment is made and clear funds have been received.\n'+
  '\n'+
  '3. Work Product:\n'+
  'All photographs will be shot in digital format. Digital photos will be made available on a private online gallery available for download no later than 6 weeks after the shoot date. Photos will be delivered as high-resolution JPEG files in an online gallery. RAW files will not be provided. When the online gallery is delivered, it shall remain open for 14 days from delivery date. Requests for additional photographs or changes to images shall be made within 14 days following delivery of the online gallery. Be advised that RAW files may be destroyed at any time after the online gallery has closed. The CLIENT may download images from the online gallery for personal use only. Downloaded images must not be reproduced in any form including for the purpose of being submitted to contests, reproduced for commercial use or in any other form other than as provided for in this agreement or with the express written license of the PHOTOGRAPHER.\n'+
  '\n'+
  '4. Rescheduling/Late Arrivals:\n'+
  '4.1 - In the event that the Client requests to reschedule its session on account of illness, emergency, act of God or any cause outside its control, the retainer will be applied to a rescheduled session provided that notice is given at least 7 days prior to the scheduled PHOTOSHOOT (or reasonable notice in the case of an emergency).\n'+
  '4.2 - Requests to reschedule by Clients for any reason other than a reason under clause 4.1 is at the discretion of PHOTOGRAPHER.\n'+
  '4.3 - An additional \$50 rescheduling fee must be paid by the Client on making a rescheduling request and PHOTOGRAPHER will be entitled to retain all amounts paid under this contract until the rescheduled PHOTOSHOOT. \n'+
  '4.4 - The rescheduled session must be within 2 weeks of the original session date (or a longer period as agreed by PHOTOGRAPHER and Client in writing) and is subject to the availability of PHOTOGRAPHER. Any Client that is late arriving to the session will have the remaining amount of time allotted for the session. All additional time beyond the scheduled end time will be billed to the Client .\n'+
  '\n'+
  '5. Cancellation:\n'+
  'If Client cancels this agreement, giving less than 24 hours notice prior to the date of the PHOTOSHOOT or fails to show on time, all payments made to PHOTOGRAPHER will be forfeited and released to PHOTOGRAPHER unconditionally. \n'+
  '\n'+
  '6. Indemnification:\n'+
  '\n'+
  '6.1 - PHOTOGRAPHER and CLIENT agree that the PHOTOGRAPHER is under no obligation to capture any specific moment or pose or person(s) during the PHOTOSHOOT. The PHOTOGRAPHER is not responsible for compromised coverage due to causes beyond the control of the PHOTOGRAPHER including but not limited to obtrusive guests, lateness of the CLIENT or guests, weather conditions, schedule complications, incorrect addresses provided to the PHOTOGRAPHER, restrictions of the locations.\n'+
  '\n'+
  '6.2 - Unless specifically requested in writing prior to the commencement of the PHOTOSHOOT, the PHOTOGRAPHER is not responsible under this agreement: for backgrounds or lighting conditions which may negatively impact or restrict the photo coverage; for missed coverage of any part of the PHOTOSHOOT; or for failure to deliver images of any specific individuals or any specific objects at the PHOTOSHOOT.\n'+
  '\n'+
  '6.3 - If PHOTOGRAPHER is unable to perform the services in this contract due to illness, emergency, fire, casualty, strike, unsafe environment, threat, act of God or any cause outside its control: PHOTOGRAPHER will make reasonable efforts to arrange a substitute photographer who is prepared to perform the services under this contract for the price agreed in this contract if the PHOTOGRAPHER is unable to perform services; PHOTOGRAPHER will return in full all payments made by CLIENT to PHOTOGRAPHER in relation to this PHOTOSHOOT if a substitute photographer cannot be found; If the fees to be charged by the substitute PHOTOGRAPHER exceed the fees payable by CLIENT under this contract, CLIENT will be entitled to elect: to engage the substitute photographer (in which case, CLIENT shall be liable for any additional fees charged by the substitute photographer); or to require PHOTOGRAPHER to return in full all payments in accordance with subparagraph 2 above.\n'+
  '\n'+
  '6.4 -PHOTOGRAPHER reserves the right to substitute with another photographer in the case of failure to perform as stated above. The substitute photographer is chosen at the discretion of the PHOTOGRAPHER and does not constitute a breach of this agreement. PHOTOGRAPHER warrants the substitute photographer to be of comparable quality and professionalism.\n'+
  '\n'+
  '6.5 - If PHOTOGRAPHER is unable to deliver photographic materials due to technological malfunctions, including but not limited to camera and processing, or otherwise lost or damaged without fault of the PHOTOGRAPHER, the PHOTOGRAPHER will not be liable for any consequential loss arising from the non-delivery, and the liability of the Photographer to the Client should be limited to the repayment of amounts paid to the PHOTOGRAPHER under this Agreement.\n'+
  '\n'+
  '6.6 - CLIENT understands and agrees that PHOTOGRAPHER is not required to maintain copies of the photos from this PHOTOSHOOT 14 days after the online gallery has been delivered to CLIENT. CLIENT will have 14 days after gallery delivery to make PHOTOGRAPHER aware of any issue, discrepancy, technical problem or any other complaint regarding photos, their quality and contents, or anything relating to session coverage. After this 14-day term has expired, PHOTOGRAPHER will no longer be liable to CLIENT for any corrections, damages, refunds, re-edits or re-shoots. Re-edits after this term may be made by PHOTOGRAPHER if requested by CLIENT but the hourly fee of \$60 per hour plus GST for retouching will be billed with a minimum of one hour required.\n'+
  '\n'+
  '6.7 – CLIENT agrees to indemnify and hold PHOTOGRAPHER harmless for any and all personal injury which may occur during the course of the photography session and the immediately surrounding PHOTOSHOOT (including any personal injury arising from or connected with any negligent act or omission on the part of PHOTOGRAPHER).\n'+
  '\n'+
  '6.8 – CLIENT agrees to indemnify PHOTOGRAPHER and keep it harmless from and against all losses and claims, proceedings, action for damages, compensation, expenses, losses, legal costs (on an indemnity basis), contribution, indemnity or any other legal, equitable or statutory remedy arising from or in connection with this agreement.\n'+
  '\n'+
  '6.9 – PHOTOGRAPHER retains the right of discretion in selecting the photographic materials released to the client. \n'+
  '\n'+
  '6.10 - The final post production and editing styles, effects, and overall look of the images are left to the discretion of the PHOTOGRAPHER.\n'+
  '\n'+
  '6.11 PHOTOGRAPHER  reserves the right to terminate coverage and leave the location of the PHOTOSHOOT if the photographer experiences inappropriate, threatening, hostile or offensive behavior from anyone at the PHOTOSHOOT; or in the event that the safety of the photographer is in question.  If PHOTOGRAPHER leaves the PHOTOSHOOT in accordance with this clause, PHOTOGRAPHER will not be liable to refund any amount to CLIENT, but will be obliged to provide CLIENT with photographs taken by PHOTOGRAPHER prior to PHOTOGRAPHER leaving the PHOTOSHOOT.\n'+
  '\n'+
  '7. Timeline and Schedule:\n'+
  '\n'+
  '7.1 The client agrees to confirm the schedule one-week prior to the PHOTOSHOOT. Notification of any changes in schedule or location must be made in a timely manner and confirmation of receipt must be obtained from the PHOTOGRAPHER  by the CLIENT. The PHOTOGRAPHER is not responsible for creating or managing the timeline on the day. If the photographer must stay over the agreed number of hours, an additional fee of \$100 plus GST per hour, per photographer will be charged to the client.\n'+
  '\n'+
  '7.2 On the day of the PHOTOSHOOT, the client must provide PHOTOGRAPHER and the PHOTOGRAPHER’s assistant with meals at the same time as the bridal party.\n'+
  ' \n'+
  '\n'+
  '8. Permissions and permits:\n'+
  'CLIENT will obtain all permissions necessary for PHOTOGRAPHER to photograph at the SHOOT. PHOTOGRAPHER has no duty to obtain permission of reception centers, churches, buildings, properties, national parks or other locations. CLIENT understands and agrees that any failure to obtain these permissions resulting in fines to the photographer, or which prevent the PHOTOGRAPHER from photographing the PHOTOSHOOT is not the fault, liability, or responsibility of the PHOTOGRAPHER and CLIENT agrees: To pay to the PHOTOGRAPHER an amount equal to any fine which may be imposed upon PHOTOGRAPHER as a result of the CLIENT’s failure to obtain any required permission; and not to make any claim (including a claim for the repayment of any money paid under this agreement) arising out of or connected with any failure on the part of CLIENT to obtain any required permission.\n'+
  '\n'+
  '9. Exclusive Photographer:\n'+
  'CLIENT agrees and understands that no other party other than PHOTOGRAPHER and the PHOTOGRAPHER\'S assistant may take pictures of any poses, lighting situations, or setups made by the PHOTOGRAPHER. This slows down the PHOTOGRAPHER’S work and violates the PHOTOGRAPHER’S intellectual property in the composition of pictures of the PHOTOSHOOT. CLIENT agrees to do all things reasonably requested by PHOTOGRAPHER to ensure that no person(s) get in the way of the PHOTOGRAPHER or take pictures in these situations.\n'+
  '\n'+
  '10. Copyright and Model Release:\n'+
  'PHOTOGRAPHER shall own the copyright in all images created and shall have the exclusive right to make reproductions for, including but not limited to, marketing materials, portfolio entries, sample products, editorial submissions and use, or for display within or on the Photographer’s website, social media and/or studio. CLIENT releases PHOTOGRAPHER from all claims and liability in relation to the photographs and any use by PHOTOGRAPHER which is consistent with this agreement.\n'+
  '\n'+
  'If the PHOTOGRAPHER desires to make other commercial uses of the images to promote the commercial interests of any business other than the PHOTOGRAPHER’s own business, the PHOTOGRAPHER shall not do so without first obtaining the written permission of the CLIENT. It is understood that any duplication or alteration of original images is strictly prohibited without the written permission of the PHOTOGRAPHER\n'+
  '\n'+
  '11. Social Media and Personal Use License. \n'+
  'In consideration of the payment of monies due under this agreement, PHOTOGRAPHER grants CLIENT a perpetual non-exclusive license to print or to reproduce images downloaded from the photo gallery or delivered by the PHOTOGRAPHER as follows:\n'+
  '\n'+
  '1. CLIENT may share the web or high res photos delivered by the PHOTOGRAPHER on CLIENT’s personal and business social media accounts, provided that in each such post CLIENT must credit/tag PHOTOGRAPHER.\n'+
  '\n'+
  '2. This license does not permit CLIENT to screenshot poor quality images, or edit or alter photos in any way, or to do any other act which would infringe PHOTOGRAPHER’S moral rights.\n'+
  '\n'+
  '3. CLIENT may print web or high res photos delivered by the PHOTOGRAPHER or downloaded from the photo gallery for their personal use, and:\n'+
  'a: must not sell, license, sub-license, transfer, or otherwise distribute the printed photos;\n'+
  'b: must not use the printed photos for advertising or commercial purposes; and\n'+
  'c: must not submit or enter the photos into any competition.\n'+
  '\n'+
  '12. Pricing & Additional Products:\n'+
  'Services or merchandise not included in this initial contract will be sold at the current price when the order is placed. All prices are subject to change at any time without notice. Credit vouchers have no intrinsic cash value and may only be applied toward products or services purchased.\n';
}