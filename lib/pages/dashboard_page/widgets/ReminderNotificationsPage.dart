import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:swipedetector/swipedetector.dart';

import '../../../AppState.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/styles/Styles.dart';

class ReminderNotificationsPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
      converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
      builder: (BuildContext context, DashboardPageState pageState) => Scaffold(
      backgroundColor: Colors.white,
      body: Listener(
        onPointerMove: (moveEvent){
          if(moveEvent.delta.dx > 0) {
            pageState.onNotificationsSelected();
          }
        },
        child: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    brightness: Brightness.light,
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: false,
                    forceElevated: false,
                    centerTitle: true,
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: const Color(ColorConstants.primary_black),
                      ),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      color: Color(ColorConstants.getPrimaryColor()),
                      tooltip: 'Close',
                      onPressed: () {
                        pageState.onNotificationsSelected();
                        pageState.onNotificationViewClosed();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        ListView.builder(
                          reverse: false,
                          padding: new EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 64.0),
                          shrinkWrap: true,
                          controller: _controller,
                          physics: ClampingScrollPhysics(),
                          key: _listKey,
                          itemCount: pageState.reminders.length,
                          itemBuilder: (context, index) {
                            return TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                pageState.onReminderSelected(pageState.reminders.elementAt(index));
                                NavigationUtil.onJobTapped(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 24.0),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 16.0),
                                            height: 32.0,
                                            width: 32.0,
                                            child: Image.asset(
                                              'assets/images/collection_icons/reminder_icon_white.png', color: Color(pageState.reminders.elementAt(index).hasBeenSeen ? ColorConstants.getPrimaryBackgroundGrey() : ColorConstants.getPeachDark()),),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  pageState.allJobs.where((job) => job.documentId == pageState.reminders.elementAt(index).jobDocumentId).first.jobTitle,
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: 'simple',
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(pageState.reminders.elementAt(index).hasBeenSeen ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  pageState.reminders.elementAt(index).reminder.description,
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily: 'simple',
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(pageState.reminders.elementAt(index).hasBeenSeen ? ColorConstants.getPrimaryGreyMedium() : ColorConstants.getPrimaryBlack()),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Color(ColorConstants.getPrimaryGreyMedium()),
                                      ),
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