import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class JobReminderItemListWidget extends StatelessWidget {
  final int index;

  JobReminderItemListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          TextButton(
            style: Styles.getButtonStyle(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
              ),
            ),
        onPressed: () {
              if(index != 0){
                pageState.onReminderSelected(pageState.allReminders.elementAt(index));
              }
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
              height: 44.0,
              width: 44.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset('assets/images/icons/reminder_icon_blue_light.png').image,
                  fit: BoxFit.contain,
                ),
                color: Colors.transparent,
              ),
              child: !pageState.selectedReminders.contains(pageState.allReminders.elementAt(index)) ? Container(
                decoration: new BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                ),
              ) : SizedBox(),
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
                      Text(
                        pageState.allReminders.elementAt(index).description,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: pageState.selectedReminders.contains(pageState.allReminders.elementAt(index)) ? FontWeight.w800 : FontWeight.w600,
                          color: pageState.selectedReminders.contains(pageState.allReminders.elementAt(index)) ? Color(ColorConstants.getPrimaryBlack()) : Color(ColorConstants.getPeachDark()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pageState.selectedReminders.contains(pageState.allReminders.elementAt(index)) ? Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 2.0, bottom: 2.0),
              height: 24.0,
              width: 24.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ImageUtil.getJobStageCompleteIconBlack(),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
