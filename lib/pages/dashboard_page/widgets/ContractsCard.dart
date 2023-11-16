import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/Shadows.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../../../widgets/TextDandyLight.dart';

class ContractsCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>  Container(
      margin: EdgeInsets.only(bottom: 32, top: 0),
      child: Container(
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
            padding: EdgeInsets.only(bottom: 16),
            height: 108.0,
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Active Contracts',
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
                        NavigationUtil.onDashboardContractsSelected(context, pageState, false);
                        EventSender().sendEvent(eventName: EventNames.NAV_TO_UNSIGNED_CONTRACTS);
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: new BorderRadius.all(Radius.circular(42.0))),
                        width: (MediaQuery.of(context).size.width - 33) / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: pageState.activeJobsWithUnsignedContract != null ? pageState.activeJobsWithUnsignedContract.length.toString() : '0',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Unsigned',
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
                        NavigationUtil.onDashboardContractsSelected(context, pageState, true);
                        EventSender().sendEvent(eventName: EventNames.NAV_TO_SIGNED_CONTRACTS);
                      },
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: new BorderRadius.all(Radius.circular(42.0))),
                        width: (MediaQuery.of(context).size.width - 33) / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: pageState.activeJobsWithSignedContract != null ? pageState.activeJobsWithSignedContract.length.toString() : '0',
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Signed',
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
