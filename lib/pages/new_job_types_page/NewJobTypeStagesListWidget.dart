import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypePageState.dart';
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

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(ColorConstants.getPrimaryBlack());
      }
      return Color(ColorConstants.getPeachDark());
    }

    return StoreConnector<AppState, NewJobTypePageState>(
      converter: (store) => NewJobTypePageState.fromStore(store),
      builder: (BuildContext context, NewJobTypePageState pageState) =>
          Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 2.0, bottom: 2.0),
              height: 38.0,
              width: 38.0,
              child: Image.asset(
                pageState.selectedJobStages.elementAt(index).imageLocation,
                color: Color(ColorConstants.getPeachDark()),
              ),
            ),
            Expanded(
              child: Container(
                height: 64.0,
                margin: EdgeInsets.only(right: 32.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: pageState.selectedJobStages.elementAt(index).id <= 14 ? JobStage.getStageText(pageState.selectedJobStages.elementAt(index)) : pageState.selectedJobStages.elementAt(index).stage,
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
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
