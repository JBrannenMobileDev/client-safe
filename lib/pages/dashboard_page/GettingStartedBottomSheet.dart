import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_store/open_store.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../models/Progress.dart';
import '../../navigation/routes/RouteNames.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'DashboardPageState.dart';


class GettingStartedBottomSheet extends StatefulWidget {
  const GettingStartedBottomSheet({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _GettingStartedBottomSheetState();
  }
}

class _GettingStartedBottomSheetState extends State<GettingStartedBottomSheet> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>
         Container(
           height: MediaQuery.of(context).size.height - 116,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16),
             child: Column(
               children: [
                  TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Getting Started Progress',
                  ),
                 TextDandyLight(
                   type: TextDandyLight.LARGE_TEXT,
                   text: '${pageState.profile?.progress.getProgressString() ?? '0'}% Complete',
                   color: ((pageState.profile?.progress.getProgressString()) == '100') ? Color(ColorConstants.getBlueDark()) : Color(ColorConstants.getPeachDark()),
                 ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        buildProgressCategory(
                            'Step 1 - Look professional',
                            (pageState.profile?.progress.setupBrand ?? false) && (pageState.profile?.progress.previewClientPortal ?? false)
                        ),
                        GestureDetector(
                          onTap: () async {
                            await canLaunchUrl(Uri.parse('https://dandylight.com/${RouteNames.BRANDING_PREVIEW}/${UidUtil().getUid()}')) ? await launchUrl(Uri.parse('https://dandylight.com/${RouteNames.BRANDING_PREVIEW}/${UidUtil().getUid()}'), mode: LaunchMode.externalApplication) : throw 'Could not launch';
                            pageState.updateProgressItemComplete!(Progress.PREVIEW_CLIENT_PORTAL);
                          },
                          child: buildProgressItem(
                              'Preview Client Portal',
                              'The Client Portal, tailor-made for each job, serves as a branded website where all job details and documents are securely shared.',
                              pageState.profile?.progress.previewClientPortal ?? false
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            NavigationUtil.onEditBrandingSelected(context);
                          },
                          child: buildProgressItem(
                              'Setup your brand',
                              'Your brand will be used to style your client portal along with any documents you add to your job.',
                              pageState.profile?.progress.setupBrand ?? false
                          ),
                        ),
                        buildProgressCategory(
                            'Step 2 - Create your first job',
                            (pageState.profile?.progress.createJobType ?? false) &&
                            (pageState.profile?.progress.createPricePackage ?? false) &&
                            (pageState.profile?.progress.addClient ?? false) &&
                            (pageState.profile?.progress.createJob ?? false)
                        ),
                        GestureDetector(
                          onTap: () {
                            UserOptionsUtil.showNewJobTypePage(context, null);
                          },
                          child: buildProgressItem(
                              'Create a job type',
                              'A job type will be used to help organize your jobs. Also, each job type can be setup with unique reminders.',
                              pageState.profile?.progress.createJobType ?? false
                          ),
                        ),
                        buildProgressItem(
                            'Create a price package',
                            'A pricing package streamlines your workflow by establishing predefined prices, deposits, and sales tax rates, which can then be readily applied to future jobs, saving you valuable time.',
                            pageState.profile?.progress.createPricePackage ?? false
                        ),
                        buildProgressItem(
                            'Add a client',
                            'Adding a client is crucial for tracking work history efficiently, simplifying communication and sharing of details and poses. Additionally, you can monitor the origin of your client (Lead source) for valuable insights.',
                            pageState.profile?.progress.addClient ?? false
                        ),
                        buildProgressItem(
                            'Create a job',
                            'After a job is created, you can include poses, invoices, contracts, and questionnaires. These can all be managed directly from the "Job Details" page, granting you access to the Client Portal tailored for this particular job.',
                            pageState.profile?.progress.createJob ?? false
                        ),
                        buildProgressCategory(
                            'Step 3 - Adding to a job',
                            (pageState.profile?.progress.addPosesToJob ?? false) &&
                            (pageState.profile?.progress.addInvoiceToJob ?? false) &&
                            (pageState.profile?.progress.addQuestionnaireToJob ?? false) &&
                            (pageState.profile?.progress.createLocation ?? false) &&
                            (pageState.profile?.progress.addLocationToJob ?? false) &&
                            (pageState.profile?.progress.createContract ?? false) &&
                            (pageState.profile?.progress.addContractToJob ?? false) &&
                            (pageState.profile?.progress.createSingleExpense ?? false)
                        ),
                        buildProgressItem(
                            'Add poses to a job',
                            'Adding poses to a job enables you to share pose ideas with your client prior to the session. This is a great way to prepare your clients ahead of time.',
                            pageState.profile?.progress.addPosesToJob ?? false
                        ),
                        buildProgressItem(
                            'Add an invoice to a job',
                            'Including an invoice with your job expedites payment and enhances clarity by placing it within the Client Portal, ensuring accurate and efficient sharing of payment details.',
                            pageState.profile?.progress.addInvoiceToJob ?? false
                        ),
                        buildProgressItem(
                            'Add a questionnaire to a job',
                            'Client questionnaires benefit photographers by providing insights into client preferences, streamlining planning, enhancing communication, enabling personalization, saving time, and fostering stronger client relationships.',
                            pageState.profile?.progress.addQuestionnaireToJob ?? false
                        ),
                        buildProgressItem(
                            'Create a location',
                            'Dandylight\'s locations offer a convenient solution for saving time when utilizing frequently visited spots. It provides access to driving directions and automatically tracks mileage driven.',
                            pageState.profile?.progress.createLocation ?? false
                        ),
                        buildProgressItem(
                            'Add a location to a job',
                            'Once a location is added to a job, its details will be accessible to your client through the Client Portal.',
                            pageState.profile?.progress.addLocationToJob ?? false
                        ),
                        buildProgressItem(
                            'Create a contract',
                            'Client contracts are vital for photographers as they provide legal protection, clarify expectations, ensure payment security, define copyright and usage rights, and enhance professionalism, ultimately contributing to successful client interactions and minimizing disputes.',
                            pageState.profile?.progress.createContract ?? false
                        ),
                        buildProgressItem(
                            'Add a contract to a job',
                            'Once a contract is added to a job, e-signing will be available to your client through the Client Portal.',
                            pageState.profile?.progress.addContractToJob ?? false
                        ),
                        buildProgressCategory(
                            'Step 4 - Manage expenses',
                            (pageState.profile?.progress.createSingleExpense ?? false) &&
                            (pageState.profile?.progress.createRecurringExpense ?? false)
                        ),
                        buildProgressItem(
                            'Create a single expense',
                            'Single expenses are great for any time you have a one-off business expense.',
                            pageState.profile?.progress.createSingleExpense ?? false
                        ),
                        buildProgressItem(
                            'Create a recurring expense',
                            'Recurring expenses are perfect for those monthly business bills you have setup on auto-pay.',
                            pageState.profile?.progress.createRecurringExpense ?? false
                        ),
                        buildProgressCategory('Step 5 - Share with a friend', false),
                        GestureDetector(
                          onTap: () {
                            Share.share('Checkout DandyLight:\n\nhttps://dandylight.com');
                            pageState.updateProgressItemComplete!(Progress.SHARED_WITH_FRIEND);
                          },
                          child: buildProgressItem(
                              'Share Dandylight with a friend',
                              'Hey ${pageState.profile?.firstName}! 👋 Loving Dandylight? We\'d greatly appreciate it if you could spread the word to your photographer friends who might find it useful too! Sharing is caring, and it helps us grow and support more photographers like you. Thanks a bunch! 📸✨',
                              pageState.profile?.progress.sharedWithFriend ?? false
                          ),
                        ),
                        const SizedBox(height: 124)
                      ],
                    ),
                  )
               ],
             ),
         ),
    );

  Widget buildProgressCategory(String title, bool isComplete) {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 8),
      alignment: Alignment.centerLeft,
      child: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: title,
        textAlign: TextAlign.start,
        isBold: true,
        color: isComplete ? Color(ColorConstants.getPrimaryGreyMedium()) : Color(ColorConstants.getPeachDark()),
      ),
    );
  }

  Widget buildProgressItem(String title, String description, bool complete) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(complete ? 'assets/images/icons/checkbox.png' : 'assets/images/icons/checkbox_empty.png', color: Color(complete ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryGreyMedium()), height: 32),
                    const SizedBox(width: 8),
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: title,
                      textAlign: TextAlign.start,
                      isBold: !complete,
                      color: Color(complete ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 41),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: description,
                    maxLines: 10,
                    textAlign: TextAlign.start,
                    color: Color(complete ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 24,
            alignment: Alignment.center,
            child: Icon(
              Icons.chevron_right,
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
          )
        ],
      ),
    );
  }
}