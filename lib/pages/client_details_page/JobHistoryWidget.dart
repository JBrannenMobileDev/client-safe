import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../AppState.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_contact_pages/NewContactPageState.dart';
import '../new_contact_pages/NewContactTextField.dart';

class JobHistoryWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ClientDetailsPageState>(
      converter: (store) => ClientDetailsPageState.fromStore(store),
      builder: (BuildContext context, ClientDetailsPageState pageState) =>
          GestureDetector(
            onTap: () {
              NavigationUtil.onJobHistorySelected(context);
            },
            child: Container(
              height: 104,
              margin: EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                        left: 24.0, bottom: 8.0, right: 24),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Job History',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: 24, right: 18.0),
                        height: 38.0,
                        width: 38.0,
                        child: Image.asset(
                          'assets/images/icons/job_type.png',
                          color: Color(ColorConstants.peach_dark),),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: 4.0, top: 4.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: (pageState.clientJobs != null &&
                                    pageState.clientJobs.length > 0) ? pageState.clientJobs.length == 1 ? '1 Job' : pageState.clientJobs.length.toString() + ' Jobs' : '0 Jobs',
                                textAlign: TextAlign.start,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.chevron_right,
                                color: Color(ColorConstants
                                    .getPrimaryBackgroundGrey()),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
