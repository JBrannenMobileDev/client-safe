import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shimmer/shimmer.dart';
import '../../../AppState.dart';
import '../../../models/Contract.dart';
import '../../../models/Job.dart';
import '../../../models/Questionnaire.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../widgets/TextDandyLight.dart';

class BookingActivityCard extends StatelessWidget {
  const BookingActivityCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) => Container(
      margin: const EdgeInsets.only(bottom: 8, top: 0),
      child: GestureDetector(
        onTap: () {

        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          padding: const EdgeInsets.only(left: 0),
          height: 54.0,
          decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryGreyDark()),
              borderRadius: const BorderRadius.all(Radius.circular(12.0))),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 54,
                    alignment: Alignment.center,
                    child: Shimmer.fromColors(
                      baseColor: Color(ColorConstants.getPrimaryWhite()),
                      highlightColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: '2 New bookings!',
                        isBold: true,
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ],
              ),
              // Container(
              //   width: 24,
              //   margin: const EdgeInsets.only(right: 8),
              //   alignment: Alignment.center,
              //   child: Icon(
              //     Icons.chevron_right,
              //     color: Color(ColorConstants.getPrimaryBackgroundGrey()),
              //   ),
              // )
            ],
          ),
        ),
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

