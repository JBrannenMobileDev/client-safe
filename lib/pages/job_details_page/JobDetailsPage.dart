import 'dart:async';
import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/job_details_page/ClientDetailsCard.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/job_details_page/JobInfoCard.dart';
import 'package:client_safe/pages/job_details_page/RemindersCard.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/StageItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({Key key, this.destination}) : super(key: key);
  final JobDetailsPage destination;

  @override
  State<StatefulWidget> createState() {
    return _JobDetailsPageState(-2);
  }
}

class _JobDetailsPageState extends State<JobDetailsPage> with TickerProviderStateMixin{
  final GlobalKey<AnimatedListState> _listKeyVertical = GlobalKey<AnimatedListState>();
  ScrollController _scrollController = ScrollController();
  ScrollController _stagesScrollController = ScrollController();
  double scrollPosition = 0;

  _JobDetailsPageState(this.scrollPosition);

  Future<void> _ackAlert(BuildContext context, JobDetailsPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this job will be gone forever!'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                pageState.onDeleteSelected();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this job will be gone forever!'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                pageState.onDeleteSelected();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, JobDetailsPageState>(
        converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
        builder: (BuildContext context, JobDetailsPageState pageState) {
          if(pageState.newStagAnimationIndex != -1 || scrollPosition == -2) {
            Timer(Duration(milliseconds: 150), () =>
                _stagesScrollController.animateTo(
                  _getScrollToOffset(pageState),
                  curve: Curves.easeInOutCubic,
                  duration: const Duration(milliseconds: 1000),
                ),
            );
            pageState.setNewIndexForStageAnimation(-1);
            if(scrollPosition == -2) scrollPosition = 0;
          }
              return Scaffold(
              body: Container(
                color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.getPrimaryColor()),
                        image: DecorationImage(
                          image: AssetImage(ImageUtil.DANDY_BG),
                          repeat: ImageRepeat.repeat,
                          fit: BoxFit.contain,
                        ),
                      ),
                      height: 435.0,
                    ),
                    CustomScrollView(
                      key: _listKeyVertical,
                      controller: _scrollController,
                      slivers: <Widget>[
                        new SliverAppBar(
                          brightness: Brightness.light,
                          title: Text(
                            pageState.job.jobTitle,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Blackjack',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                          centerTitle: true,
                          titleSpacing: 48.0,
                          backgroundColor:
                          _isMinimized ? _getAppBarColor() : Colors.transparent,
                          elevation: 0.0,
                          pinned: true,
                          floating: false,
                          forceElevated: false,
                          expandedHeight: 325.0,
                          actions: <Widget>[
                            new IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete Job',
                              onPressed: () {
                                _ackAlert(context, pageState);
                              },
                            ),
                          ],
                          flexibleSpace: new FlexibleSpaceBar(
                            background: Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 56.0),
                                  alignment: Alignment.topCenter,
                                  child: SafeArea(
                                    child: Text(
                                      'Job Stages',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black26,
                                      ),
                                    ),
                                  ),
                                ),
                                SafeArea(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _stagesScrollController,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                            height: 347.0,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              physics: NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.all(16.0),
                                              itemCount: 14,
                                              itemBuilder: _buildItem,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        new SliverList(
                            delegate: new SliverChildListDelegate(<Widget>[
                              RemindersCard(),
                              JobInfoCard(pageState: pageState),
                              ClientDetailsCard(pageState: pageState),
                            ])),
                      ],
                    ),
                  ],
                ),
              ),
            );
        },
      );

  void _onAddButtonPressed(BuildContext context) {
    UserOptionsUtil.showDashboardOptionsSheet(context);
  }

  bool get _isMinimized {
    return _scrollController.hasClients && _scrollController.offset > 260.0;
  }

  Color _getAppBarColor() {
    if (_scrollController.offset > 260 && _scrollController.offset <= 262) {
      return Colors.black.withOpacity(0.08);
    } else if (_scrollController.offset > 262 &&
        _scrollController.offset <= 263) {
      return Colors.black.withOpacity(0.09);
    } else if (_scrollController.offset > 263 &&
        _scrollController.offset <= 264) {
      return Colors.black.withOpacity(0.10);
    } else if (_scrollController.offset > 264 &&
        _scrollController.offset <= 265) {
      return Colors.black.withOpacity(0.11);
    } else if (_scrollController.offset > 265 &&
        _scrollController.offset <= 266) {
      return Colors.black.withOpacity(0.12);
    } else if (_scrollController.offset > 266 &&
        _scrollController.offset <= 267) {
      return Colors.black.withOpacity(0.13);
    } else if (_scrollController.offset > 267 &&
        _scrollController.offset <= 268) {
      return Colors.black.withOpacity(0.15);
    } else if (_scrollController.offset > 268 &&
        _scrollController.offset <= 269) {
      return Colors.black.withOpacity(0.17);
    } else if (_scrollController.offset > 269 &&
        _scrollController.offset <= 270) {
      return Colors.black.withOpacity(0.19);
    } else if (_scrollController.offset > 270 &&
        _scrollController.offset <= 271) {
      return Colors.black.withOpacity(0.22);
    } else if (_scrollController.offset > 272 &&
        _scrollController.offset <= 273) {
      return Colors.black.withOpacity(0.24);
    } else {
      return Colors.black.withOpacity(0.26);
    }
  }

  double _getScrollToOffset(JobDetailsPageState pageState) {
    switch(pageState.job.stage.stage){
      case JobStage.STAGE_1_INQUIRY_RECEIVED:
        return 0;
      case JobStage.STAGE_2_FOLLOWUP_SENT:
        return 200.0;
      case JobStage.STAGE_3_PROPOSAL_SENT:
        return 400.0;
      case JobStage.STAGE_4_PROPOSAL_SIGNED:
        return 600.0;
      case JobStage.STAGE_5_DEPOSIT_RECEIVED:
        return 800.0;
      case JobStage.STAGE_6_PLANNING_COMPLETE:
        return 1000.0;
      case JobStage.STAGE_7_SESSION_COMPLETE:
        return 1200.0;
      case JobStage.STAGE_8_PAYMENT_REQUESTED:
        return 1400.0;
      case JobStage.STAGE_9_PAYMENT_RECEIVED:
        return 1600.0;
      case JobStage.STAGE_10_EDITING_COMPLETE:
        return 1800.0;
      case JobStage.STAGE_11_GALLERY_SENT:
        return 2000.0;
      case JobStage.STAGE_12_FEEDBACK_REQUESTED:
        return 2200.0;
      case JobStage.STAGE_13_FEEDBACK_RECEIVED:
        return 2400.0;
      case JobStage.STAGE_14_JOB_COMPLETE:
        return 2600.0;
      case JobStage.STAGE_COMPLETED_CHECK:
        return 2600.0;
    }
    return 0.0;
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) => _getWidgetForIndex(index, pageState.job),
    );
  }

  _getWidgetForIndex(int index, Job job) {
    return StageItem(index, job);
  }
}
