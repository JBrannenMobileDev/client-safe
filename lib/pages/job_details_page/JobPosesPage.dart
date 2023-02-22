import 'dart:io';

import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsSingleImageViewPager.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../../AppState.dart';
import '../../../models/JobReminder.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/styles/Styles.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'JobDetailsPageState.dart';
import 'JobPoseListWidget.dart';

class JobPosesPage extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, JobDetailsPageState>(
      converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) => Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Color(ColorConstants.getPeachDark()), //change your color here
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: false,
                    forceElevated: false,
                    centerTitle: true,
                    title: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: pageState.job.jobTitle,
                      color: const Color(ColorConstants.primary_black),
                    ),
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            NavigationUtil.onPosesSelected(context, pageState.job);
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
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Container(
                            height: (MediaQuery.of(context).size.height),
                            child: GridView.builder(
                                padding: new EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 300.0),
                                gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 2 / 2.45,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                                itemCount: pageState.poseImages.length,
                                controller: _controller,
                                physics: AlwaysScrollableScrollPhysics(),
                                key: _listKey,
                                shrinkWrap: true,
                                reverse: false,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(builder: (context) => JobDetailsSingleImageViewPager(
                                          pageState.poseImages,
                                          index,
                                          pageState.onDeletePoseSelected,
                                          'Job Poses',
                                      )),
                                    );
                                  },
                                  child: JobPoseListWidget(index),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    List<String> filePaths = pageState.poseImages.map((groupImage) => groupImage.file.path).toList();
                    Share.shareFiles(
                        filePaths,
                        subject: 'Example Poses');
                    EventSender().sendEvent(eventName: EventNames.BT_SHARE_JOB_POSES);
                  },
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