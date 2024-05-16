import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../models/JobReminder.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/styles/Styles.dart';
import '../../../widgets/TextDandyLight.dart';

class ReminderNotificationsPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  ReminderNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
      converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
      builder: (BuildContext context, DashboardPageState pageState) => Scaffold(
      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
      body: Listener(
        onPointerMove: (moveEvent){

        },
        child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                    pinned: true,
                    floating: false,
                    forceElevated: false,
                    centerTitle: true,
                    title: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Notifications',
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      color: Color(ColorConstants.getPeachDark()),
                      tooltip: 'Close',
                      onPressed: () {
                        pageState.onNotificationViewClosed!();
                        Navigator.of(context).pop();
                      },
                    ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            pageState.markAllAsSeen!();
                          },
                          child: Icon(
                            Icons.done_all,
                            color: Color(ColorConstants.getBlueDark()),
                          )
                        ),
                    ], systemOverlayStyle: SystemUiOverlayStyle.dark,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        ListView.builder(
                          reverse: false,
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 64.0),
                          shrinkWrap: true,
                          controller: _controller,
                          physics: const ClampingScrollPhysics(),
                          key: _listKey,
                          itemCount: pageState.reminders!.length!,
                          itemBuilder: (context, index) {
                            return TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                if(pageState.reminders!.elementAt(index).payload == JobReminder.MILEAGE_EXPENSE_ID) {
                                  EventSender().sendEvent(eventName: EventNames.BT_VIEW_FEATURED_POSES_FROM_NOTIFICATIONS);
                                  UserOptionsUtil.showNewMileageExpenseSelected(context, null);
                                } else if(pageState.reminders!.elementAt(index).payload == JobReminder.POSE_FEATURED_ID) {
                                  EventSender().sendEvent(eventName: EventNames.BT_VIEW_FEATURED_POSES_FROM_NOTIFICATIONS);
                                  NavigationUtil.onPosesSelected(context, null, false, true, false);
                                } else {
                                  EventSender().sendEvent(eventName: EventNames.BT_VIEW_FEATURED_POSES_FROM_NOTIFICATIONS);
                                  NavigationUtil.onJobTapped(context, false);
                                }
                                pageState.onReminderSelected!(pageState.reminders!.elementAt(index));
                              },
                              child: pageState.reminders!.elementAt(index).payload == JobReminder.POSE_FEATURED_ID ? Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 24.0),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(right: 16.0),
                                          height: 32.0,
                                          width: 32.0,
                                          child: Icon(
                                            Icons.star,
                                            color: Color(pageState.reminders!.elementAt(index).hasBeenSeen! ? ColorConstants.getPrimaryBackgroundGrey() : ColorConstants.getPrimaryColor()),
                                            size: 32.0,
                                          )
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - 126,
                                          child: TextDandyLight(
                                            type: TextDandyLight.SMALL_TEXT,
                                            text: _buildSubmittedNotificationText(pageState.unseenFeaturedPoses!.length),
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            color: Color(pageState.reminders!.elementAt(index).hasBeenSeen! ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                    )
                                  ],
                                ),
                              ) : Padding(
                                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 24.0),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(right: 16.0),
                                          height: 32.0,
                                          width: 32.0,
                                          child: Image.asset(
                                            'assets/images/collection_icons/reminder_icon_white.png', color: Color(pageState.reminders!.elementAt(index).hasBeenSeen! ? ColorConstants.getPrimaryBackgroundGrey() : ColorConstants.getPeachDark()),),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 126,
                                              child: TextDandyLight(
                                                type: TextDandyLight.SMALL_TEXT,
                                                text: pageState.allJobs!.where((job) => job.documentId == pageState.reminders!.elementAt(index).jobDocumentId).first.jobTitle,
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                color: Color(pageState.reminders!.elementAt(index).hasBeenSeen! ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 126,
                                              child: TextDandyLight(
                                                type: TextDandyLight.SMALL_TEXT,
                                                text: pageState.reminders!.elementAt(index).reminder!.description,
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                color: Color(pageState.reminders!.elementAt(index).hasBeenSeen! ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 126,
                                              child: TextDandyLight(
                                                type: TextDandyLight.SMALL_TEXT,
                                                text: DateFormat('EEE, MMMM d  (h:mm aaa)').format(pageState.reminders!.elementAt(index).triggerTime!),
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                color: Color(pageState.reminders!.elementAt(index).hasBeenSeen! ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Color(ColorConstants.getPrimaryGreyMedium()),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
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

_buildSubmittedNotificationText(int numOfPoses) {
  String result = '';
  if(numOfPoses == 1) {
    result = '$numOfPoses submitted photo has been featured!';
  } else {
    result = '$numOfPoses submitted photos have been featured!';
  }
  return result;
}