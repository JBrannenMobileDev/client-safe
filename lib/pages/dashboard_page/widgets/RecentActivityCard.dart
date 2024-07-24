import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../../models/Contract.dart';
import '../../../models/Job.dart';
import '../../../models/Questionnaire.dart';
import '../../../utils/DeviceType.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>  Container(
      margin: const EdgeInsets.only(bottom: 16, top: 0, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              NavigationUtil.onStageStatsSelected(context, pageState, 'Jobs This Week', null, false);
            },
            child: Container(
              height: 84,
              padding: const EdgeInsets.only(left: 8, right: 8),
              width: MediaQuery.of(context).size.width/3 - 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    color: Color(ColorConstants.getPrimaryGreyDark()),
                    text: 'Jobs This Week',
                    textAlign: TextAlign.center,
                  ),
                  TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    color: Color(ColorConstants.getPrimaryBlack()),
                    text: pageState.jobsThisWeek != null ? pageState.jobsThisWeek!.length.toString() : '',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   height: 72,
          //   width: 132,
          //   margin: const EdgeInsets.only(left: 8),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(16),
          //     color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
          //   ),
          //   child: Column(
          //     children: [
          //       const SizedBox(height: 4),
          //       TextDandyLight(
          //         type: TextDandyLight.SMALL_TEXT,
          //         color: Color(ColorConstants.getPrimaryGreyDark()),
          //         text: 'New Bookings',
          //         textAlign: TextAlign.center,
          //       ),
          //       const SizedBox(height: 4),
          //       TextDandyLight(
          //         type: TextDandyLight.LARGE_TEXT,
          //         color: Color(ColorConstants.getPrimaryBlack()),
          //         text: '1',
          //         textAlign: TextAlign.center,
          //       ),
          //     ],
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              NavigationUtil.onDashboardContractsSelected(context, pageState, true);
              pageState.markContractsAsReviewed!();
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 84,
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  width: MediaQuery.of(context).size.width/3 - 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        color: Color(ColorConstants.getPrimaryGreyDark()),
                        text: 'Signed Contracts',
                        textAlign: TextAlign.center,
                      ),
                      TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: pageState.activeSignedContract != null ? pageState.activeSignedContract?.length.toString() : '0',
                        textAlign: TextAlign.center,
                        color: Color(areContractResultsNew(pageState.activeSignedContract ?? []) ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: areContractResultsNew(pageState.activeSignedContract ?? []) ? const Color(ColorConstants.error_red) : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              NavigationUtil.onDashboardQuestionnairesSelected(context, 1);
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 84,
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  width: MediaQuery.of(context).size.width/3 - 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        color: Color(ColorConstants.getPrimaryGreyDark()),
                        text: 'Questionnaire Responses',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        color: Color(ColorConstants.getPrimaryBlack()),
                        text: pageState.completedQuestionnaires != null ? pageState.completedQuestionnaires!.length.toString() : '0',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  width: 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: areQuestionnaireResultsNew(pageState.completedQuestionnaires ?? []) ? const Color(ColorConstants.error_red) : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  bool areContractResultsNew(List<Contract> contracts) {
    bool result = false;
    for(Contract contract in contracts) {
      if(!(contract.isReviewed ?? false)) result = true;
    }
    return result;
  }

  bool areQuestionnaireResultsNew(List<Questionnaire> questionnaires) {
    bool result = false;
    for(Questionnaire questionnaire in questionnaires) {
      if(!(questionnaire.isReviewed ?? false)) result = true;
    }
    return result;
  }
}

