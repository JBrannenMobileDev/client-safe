import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/questionnaires_page/QuestionnairesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/Questionnaire.dart';
import '../../widgets/TextDandyLight.dart';

class JobSelectionListItem extends StatelessWidget {
  final int index;
  final Questionnaire questionnaire;

  JobSelectionListItem(this.index, this.questionnaire);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, QuestionnairesPageState>(
      converter: (store) => QuestionnairesPageState.fromStore(store),
      builder: (BuildContext context, QuestionnairesPageState pageState) =>
          TextButton(
            style: Styles.getButtonStyle(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              color: Colors.transparent,
            ),

        onPressed: () {
          pageState.onSaveToJobSelected(questionnaire, pageState.activeJobs.elementAt(index).documentId);
          Navigator.of(context).pop();
          NavigationUtil.onJobSelected(context, pageState.activeJobs.elementAt(index).documentId);
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 8.0, right: 16.0, top: 2.0, bottom: 2.0),
              height: 44.0,
              width: 44.0,
              child: pageState.activeJobs.elementAt(index).stage.getStageImage(Color(ColorConstants.getPeachDark())),
            ),
            Expanded(
              child: Container(
                height: 64.0,
                margin: const EdgeInsets.only(right: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: pageState.activeJobs.elementAt(index).jobTitle,
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
