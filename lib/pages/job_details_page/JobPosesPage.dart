import 'package:dandylight/pages/job_details_page/JobDetailsSingleImageViewPager.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'JobDetailsPageState.dart';
import 'JobPoseListWidget.dart';

class JobPosesPage extends StatelessWidget{

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => JobDetailsSingleImageViewPager(
                  pageState.job!.poses,
                  index,
                  pageState.onDeletePoseSelected,
                  'Job Poses',
                )),
              );
            },
            child: JobPoseListWidget(index),
          ),
    );
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, JobDetailsPageState>(
      converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) => Scaffold(
      backgroundColor: Color(ColorConstants.getPrimaryWhite()),
      body: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Color(ColorConstants.getPeachDark()), //change your color here
                    ),
                    backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                    elevation: 4.0,
                    snap: true,
                    floating: true,
                    forceElevated: false,
                    centerTitle: true,
                    title: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: pageState.job!.jobTitle,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            NavigationUtil.onPosesSelected(context, pageState.job, false, false);
                            EventSender().sendEvent(eventName: EventNames.NAV_TO_POSES_ADD_POSE_TO_JOB);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            height: 24.0,
                            width: 24.0,
                            child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPeachDark()),),
                          ),
                        ),
                    ],
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 128),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2 / 2.45,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16),
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return Container(
                          height: (MediaQuery.of(context).size.height),
                          child: _buildItem(context, index),
                        );
                      },
                        childCount: pageState.job!.poses!.length, // 1000 list items
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    NavigationUtil.onShareWIthClientSelected(context, pageState.job!);
                    EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_FROM_JOB_POSES_PAGE);                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 36),
                    alignment: Alignment.center,
                    height: 48,
                    width: 232,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(ColorConstants.getPeachDark())
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      textAlign: TextAlign.center,
                      text: 'SHARE WITH CLIENT',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              )
            ],
          ),
      ),
  );

}