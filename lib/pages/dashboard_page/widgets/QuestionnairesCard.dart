import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../../utils/DeviceType.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../widgets/TextDandyLight.dart';

class QuestionnairesCard extends StatelessWidget {
  const QuestionnairesCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>  Container(
      margin: const EdgeInsets.only(bottom: 32, top: 0),
      child: Container(
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
            padding: const EdgeInsets.only(bottom: 16),
            height: 108.0,
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Active Questionnaires',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigationUtil.onDashboardQuestionnairesSelected(context, 0);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: const BorderRadius.all(Radius.circular(42.0))),
                        width: (MediaQuery.of(context).size.width - 33) / 2  - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: pageState.notCompleteQuestionnaires != null ? pageState.notCompleteQuestionnaires!.length.toString() : '0',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Not completed',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 1,
                      color: Color(ColorConstants.getPrimaryGreyLight()),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationUtil.onDashboardQuestionnairesSelected(context, 1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: const BorderRadius.all(Radius.circular(42.0))),
                        width: (MediaQuery.of(context).size.width - 33) / 2 - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: pageState.completedQuestionnaires != null ? pageState.completedQuestionnaires!.length.toString() : '0',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Completed',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
      ),
    ),
  );
}
