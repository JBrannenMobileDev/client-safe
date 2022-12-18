import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/job_details_page/ClientDetailsCard.dart';
import 'package:dandylight/pages/job_details_page/DocumentsCard.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/job_details_page/JobInfoCard.dart';
import 'package:dandylight/pages/job_details_page/RemindersCard.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/pages/job_details_page/scroll_stage_items/StageItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  ScrollController _stagesScrollController = ScrollController(keepScrollOffset: true);
  double scrollPosition = 0;
  _JobDetailsPageState(this.scrollPosition);
  bool sliverCollapsed = false;
  bool isFabExpanded = false;
  bool dialVisible = true;
  JobDetailsPageState pageStateLocal;

  Future<void> _ackAlert(BuildContext context, JobDetailsPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this job will be gone forever!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
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
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
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
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
        converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
        onInit: (appState) => {
            // appState.dispatch(ClearPreviousStateAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchTimeOfSunsetJobAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchJobDetailsPricePackagesAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchJobDetailsLocationsAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchJobRemindersAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchAllJobTypesAction(appState.state.jobDetailsPageState)),
        },
        onDidChange: (prev, pageState) {
          pageStateLocal = pageState;
        },
        builder: (BuildContext context, JobDetailsPageState pageState) {
          if((pageState.newStagAnimationIndex != -1 || scrollPosition == -2) && _stagesScrollController.hasClients) {
            Timer(Duration(milliseconds: 150), () => {
              _stagesScrollController.animateTo(
                _getScrollToOffset(pageState),
                curve: Curves.easeInOutCubic,
                duration: const Duration(milliseconds: 1000),
              ),
            },
            );
            _stagesScrollController = ScrollController(initialScrollOffset: _getScrollToOffset(pageState));
            pageState.setNewIndexForStageAnimation(-1);
            if(scrollPosition == -2) scrollPosition = 0;
          }
              return pageState.job != null ? Scaffold(
                floatingActionButton: SpeedDial(
                  // both default to 16
                  childMargin: EdgeInsets.only(right: 18.0, bottom: 20.0),
                  // this is ignored if animatedIcon is non null
                   child: getFabIcon(),
                  visible: dialVisible,
                  // If true user is forced to close dial manually
                  // by tapping main button and overlay is not rendered.
                  closeManually: false,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  tooltip: 'Speed Dial',
                  heroTag: 'speed-dial-hero-tag',
                  backgroundColor: Color(ColorConstants.getPrimaryColor()),
                  foregroundColor: Colors.black,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  onOpen: () {
                    setState(() {
                      isFabExpanded = true;
                    });
                  },
                  onClose: () {
                    setState(() {
                      isFabExpanded = false;
                    });
                  },
                  children: [
                    SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                            'Tip',
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showTipChangeDialog(context);
                      },
                    ),
                    // SpeedDialChild(
                    //   child: Icon(Icons.add),
                    //   backgroundColor: Color(ColorConstants.getBlueLight()),
                    //   labelWidget: Container(
                    //     alignment: Alignment.center,
                    //     height: 42.0,
                    //     decoration: BoxDecoration(
                    //       boxShadow: ElevationToShadow[4],
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(21.0),
                    //     ),
                    //     child: Padding(
                    //       padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    //       child: Text(
                    //         'Feedback',
                    //         style: TextStyle(
                    //           fontFamily: 'simple',
                    //           fontSize: 22.0,
                    //           fontWeight: FontWeight.w600,
                    //           color: Color(ColorConstants.getPrimaryBlack()),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //
                    //   },
                    // ),
                    // SpeedDialChild(
                    //   child: Icon(Icons.add),
                    //   backgroundColor: Color(ColorConstants.getBlueLight()),
                    //   labelWidget: Container(
                    //     alignment: Alignment.center,
                    //     height: 42.0,
                    //     decoration: BoxDecoration(
                    //       boxShadow: ElevationToShadow[4],
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(21.0),
                    //     ),
                    //     child: Padding(
                    //       padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    //       child: Text(
                    //         'Questionaire',
                    //         style: TextStyle(
                    //           fontFamily: 'simple',
                    //           fontSize: 22.0,
                    //           fontWeight: FontWeight.w600,
                    //           color: Color(ColorConstants.getPrimaryBlack()),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //
                    //   },
                    // ),
                    SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                            'Reminder',
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showNewJobReminderDialog(context, pageState.job);
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                            'Invoice',
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if(pageState.job.priceProfile != null) {
                          bool containsInvoice = false;
                          for(DocumentItem document in pageState.documents){
                            if(document.getDocumentType() == DocumentItem.DOCUMENT_TYPE_INVOICE) containsInvoice = true;
                          }
                          if(!containsInvoice) {
                            pageState.onAddInvoiceSelected();
                            UserOptionsUtil.showNewInvoiceDialog(context, onSendInvoiceSelected);
                          }else{
                            UserOptionsUtil.showInvoiceOptionsDialog(context, onSendInvoiceSelected);
                          }
                        } else {
                          DandyToastUtil.showErrorToast('Please select a price package for this job before creating an invoice.');
                        }
                      },
                    ),
                    // SpeedDialChild(
                    //   child: Icon(Icons.add),
                    //   backgroundColor: Color(ColorConstants.getBlueLight()),
                    //   labelWidget: Container(
                    //     alignment: Alignment.center,
                    //     height: 42.0,
                    //     decoration: BoxDecoration(
                    //       boxShadow: ElevationToShadow[4],
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(21.0),
                    //     ),
                    //     child: Padding(
                    //       padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    //       child: Text(
                    //         'Contract',
                    //         style: TextStyle(
                    //           fontFamily: 'simple',
                    //           fontSize: 22.0,
                    //           fontWeight: FontWeight.w600,
                    //           color: Color(ColorConstants.getPrimaryBlack()),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //
                    //   },
                    // ),
                  ],
                ),
                body: Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.getBlueLight()),
                      ),
                    ),
                    CustomScrollView(
                      key: _listKeyVertical,
                      controller: _scrollController,
                      slivers: <Widget>[
                        new SliverAppBar(
                          iconTheme: IconThemeData(
                            color: Color(ColorConstants.getPrimaryWhite()), //change your color here
                          ),
                          brightness: Brightness.light,
                          title: Text(
                            pageState.job.jobTitle,
                            style: TextStyle(
                              fontSize: 26.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.fade,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                          centerTitle: true,
                          titleSpacing: 48.0,
                          backgroundColor:
                          Colors.transparent,
                          elevation: 0.0,
                          pinned: false,
                          floating: false,
                          forceElevated: false,
                          expandedHeight: 300.0,
                          actions: <Widget>[
                            new IconButton(
                              icon: ImageIcon(ImageUtil.getTrashIconWhite()),
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
                                        fontSize: 22.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w600,
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                    ),
                              ),
                            ),
                            SafeArea(
                              child: Container(
                                margin: EdgeInsets.only(top: 25.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _stagesScrollController,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 322.0,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.all(16.0),
                                          itemCount: pageState.job.type.stages.length,
                                          itemBuilder: _buildItem,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                        ),
                        new SliverList(
                            delegate: new SliverChildListDelegate(<Widget>[
                              JobInfoCard(pageState: pageState),
                              ClientDetailsCard(pageState: pageState),
                              DocumentsCard(pageState: pageState, onSendInvoiceSelected: onSendInvoiceSelected, onDeleteInvoiceSelected: onDeleteInvoiceSelected),
                              RemindersCard(pageState: pageState),
                            ])),
                      ],
                    ),
                  ],
                ),
              ),
            ) : SizedBox();
        },
      );
  }

  void onSendInvoiceSelected() {
    pageStateLocal.onInvoiceSent(pageStateLocal.invoice);
    pageStateLocal.onStageCompleted(pageStateLocal.job, 7);
    pageStateLocal.removeExpandedIndex(7);
    pageStateLocal.setNewIndexForStageAnimation((JobStage.getIndexOfCurrentStage(pageStateLocal.job.stage.stage, pageStateLocal.job.type.stages)));
    VibrateUtil.vibrateHeavy();
  }

  void onDeleteInvoiceSelected() {
    // pageStateLocal.onStageUndo(pageStateLocal.job, 7);
    // pageStateLocal.removeExpandedIndex(7);
    // pageStateLocal.setNewIndexForStageAnimation((JobStage.getIndexOfCurrentStage(pageStateLocal.job.stage.stage, pageStateLocal.job.type.stages)));
    // VibrateUtil.vibrateHeavy();
  }

  void _onAddButtonPressed(BuildContext context) {
    UserOptionsUtil.showDashboardOptionsSheet(context);
  }

  bool get _isMinimized {
    return _scrollController.hasClients && _scrollController.offset > 260.0;
  }

  double _getScrollToOffset(JobDetailsPageState pageState) {
    if(pageState.job != null) {
      int stageIndex = JobStage.getIndexOfCurrentStage(pageState.job.stage.stage, pageState.job.type.stages);

      return (stageIndex * 200.0) - ((stageIndex == pageState.job.type.stages.length - 1) ? 150 : (stageIndex == pageState.job.type.stages.length ) ? 360 : 0);
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
    return StageItem(index, job, onSendInvoiceSelected, onJobCompleteSelected);
  }

  getFabIcon() {
    if(isFabExpanded){
      return Icon(Icons.close, color: Color(ColorConstants.getPrimaryWhite()));
    }else{
      return Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite()));
    }
  }

  void onJobCompleteSelected() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(96.0),
            child: FlareActor(
              "assets/animations/success_check.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "show_check",
              callback: onFlareCompleted,
            ),
          );
        },
      );
  }

  void onFlareCompleted(String unused, ) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
