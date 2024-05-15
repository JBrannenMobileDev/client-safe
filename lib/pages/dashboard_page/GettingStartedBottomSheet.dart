import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_store/open_store.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
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
           padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
             child: Column(
               children: [
                  TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Getting Started Progress',
                  ),
                 TextDandyLight(
                   type: TextDandyLight.LARGE_TEXT,
                   text: '${pageState.profile?.progress.getProgressValue().toStringAsFixed(0) ?? '0'}% Complete',
                   color: ((pageState.profile?.progress.getProgressString()) == '100') ? Color(ColorConstants.getBlueDark()) : Color(ColorConstants.getPeachDark()),
                 ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        buildProgressCategory('Step 1 - Look professional'),
                        buildProgressItem(
                            'Preview Client Portal',
                            'The Client Portal, tailor-made for each job, serves as a branded website where all job details and documents are securely shared.',
                            pageState.profile?.progress.previewClientPortal ?? false
                        ),
                        buildProgressItem(
                            'Setup your brand',
                            'Your brand will be used to style your client portal along with any documents you add to your job.',
                            pageState.profile?.progress.setupBrand ?? false
                        ),
                        buildProgressCategory('Step 2 - Create your first job'),
                        buildProgressItem(
                            'Create a job type',
                            'A job type will be used to help organize your jobs. Also, each job type can be setup with unique reminders.',
                            pageState.profile?.progress.setupBrand ?? false
                        ),
                        buildProgressItem(
                            'Create a price package',
                            'A pricing package streamlines your workflow by establishing predefined prices, deposits, and sales tax rates, which can then be readily applied to future jobs, saving you valuable time.',
                            pageState.profile?.progress.setupBrand ?? false
                        ),
                        buildProgressItem(
                            'Add a client',
                            'Adding a client is crucial for tracking work history efficiently and simplifying communication and sharing of details and poses. Additionally, you can monitor the origin of your client (Lead source) for valuable insights.',
                            pageState.profile?.progress.setupBrand ?? false
                        ),
                        buildProgressItem(
                            'Create a job',
                            'After a job is created, you can include poses, invoices, contracts, and questionnaires. These can all be managed directly from the "Job Details" page, granting you access to the Client Portal tailored for this particular job.',
                            pageState.profile?.progress.setupBrand ?? false
                        ),
                        buildProgressCategory('Step 3 - Create your first job'),
                        const SizedBox(height: 124)
                      ],
                    ),
                  )
               ],
             ),
         ),
    );

  Widget buildProgressCategory(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 8),
      alignment: Alignment.centerLeft,
      child: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: title,
        textAlign: TextAlign.start,
        isBold: true,
        color: Color(ColorConstants.getPeachDark()),
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
                  margin: const EdgeInsets.only(left: 4),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    text: description,
                    maxLines: 5,
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