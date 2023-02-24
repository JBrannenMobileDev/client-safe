import 'dart:io';

import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/pages/IncomeAndExpenses/InvoiceItem.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class PosesCard extends StatelessWidget {

  PosesCard({this.pageState});
  
  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(pageState.poseImages.length > 0) {
          NavigationUtil.onJobPosesSelected(context);
          EventSender().sendEvent(eventName: EventNames.NAV_TO_JOB_POSES_FROM_JOB_DETAILS);
        } else {
          NavigationUtil.onPosesSelected(context, pageState.job);
          EventSender().sendEvent(eventName: EventNames.NAV_TO_POSES_ADD_POSE_TO_JOB);
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 26.0),
        child: Container(
          width: double.maxFinite,
          height: pageState.poseImages.length == 0 ? 216 : 184.0,
          margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          decoration: new BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: new BorderRadius.all(Radius.circular(24.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 24.0),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Poses',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
              pageState.poseImages.length > 0 ? Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    pageState.poseImages.length > 0 ? Container(
                      margin: EdgeInsets.only(left: 24, right: 24),
                      alignment: Alignment.centerLeft,
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: '+' + pageState.poseImages.length.toString(),
                        color: Color(ColorConstants.getPeachDark()),
                        textAlign: TextAlign.center,
                      ),
                    ) : SizedBox(),
                    pageState.poseImages.length >= 6 ? Container(
                      margin: EdgeInsets.only(left: 194),
                      height: 66,
                      width: 66,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: pageState.poseImages.isNotEmpty ? FileImage(File(pageState.poseImages.elementAt(5).file.path))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                    ) : SizedBox(),
                    pageState.poseImages.length >= 5 ? Container(
                      margin: EdgeInsets.only(left: 168),
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: pageState.poseImages.isNotEmpty ? FileImage(File(pageState.poseImages.elementAt(4).file.path))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                    ) : SizedBox(),
                    pageState.poseImages.length >= 4 ? Container(
                      margin: EdgeInsets.only(left: 142),
                      height: 78,
                      width: 78,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: pageState.poseImages.isNotEmpty ? FileImage(File(pageState.poseImages.elementAt(3).file.path))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                    ) : SizedBox(),
                    pageState.poseImages.length >= 3 ? Container(
                      margin: EdgeInsets.only(left: 116),
                      height: 84,
                      width: 84,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: pageState.poseImages.isNotEmpty ? FileImage(File(pageState.poseImages.elementAt(2).file.path))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                    ) : SizedBox(),
                    pageState.poseImages.length >= 2 ? Container(
                      margin: EdgeInsets.only(left: 90),
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: pageState.poseImages.isNotEmpty ? FileImage(File(pageState.poseImages.elementAt(1).file.path))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                    ) : SizedBox(),
                    pageState.poseImages.length >= 1 ? Container(
                      margin: EdgeInsets.only(left: 64),
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: pageState.poseImages.isNotEmpty ? FileImage(File(pageState.poseImages.elementAt(0).file.path))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                    ) : SizedBox(),
                    Container(
                      height: 64,
                      margin: EdgeInsets.only(right: 16),
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_right,
                        color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      ),
                    ),
                  ],
              ) : SizedBox(),
              pageState.poseImages.length == 0 ? Container(
                margin: EdgeInsets.only(top: 12, left: 24, right: 24),
                alignment: Alignment.center,
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Select the button below to add poses to this job.',
                  color: Color(ColorConstants.getPrimaryBlack()),
                  textAlign: TextAlign.center,
                ),
              ) : SizedBox(),
              pageState.poseImages.length == 0 ? Container(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 32),
                    alignment: Alignment.center,
                    height: 48,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(ColorConstants.getBlueDark()),
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Select Poses',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
              ) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
