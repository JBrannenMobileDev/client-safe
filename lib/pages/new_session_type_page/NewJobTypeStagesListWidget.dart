import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_session_type_page/NewSessionTypePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class NewJobTypeStagesListWidget extends StatelessWidget {
  final int index;

  NewJobTypeStagesListWidget(this.index);

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, NewSessionTypePageState>(
      converter: (store) => NewSessionTypePageState.fromStore(store),
      builder: (BuildContext context, NewSessionTypePageState pageState) =>
          Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16.0, top: 2.0, bottom: 2.0),
              height: 26.0,
              width: 26.0,
              child: Image.asset(
                pageState.selectedJobStages!.elementAt(index).imageLocation!,
                color: Color(ColorConstants.getPeachDark()),
              ),
            ),
            Expanded(
              child: Container(
                height: 64.0,
                margin: EdgeInsets.only(right: 16.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: pageState.selectedJobStages!.elementAt(index).id! <= 14 ? '${index + 1}. ${JobStage.getStageText(pageState.selectedJobStages!.elementAt(index))}' : '${index + 1}. ${pageState.selectedJobStages!.elementAt(index).stage}',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 0.0, top: 2.0, bottom: 2.0),
              child: Container(
                height: 26,
                child: Image.asset('assets/images/icons/reorder.png', color: Color(ColorConstants.getPrimaryGreyMedium()),),
              ),
            )
          ],
        ),
    );
  }
}
