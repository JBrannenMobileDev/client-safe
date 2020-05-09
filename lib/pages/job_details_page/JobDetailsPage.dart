import 'dart:async';
import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/job_details_page/ClientDetailsCard.dart';
import 'package:client_safe/pages/job_details_page/DocumentsCard.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsActions.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/job_details_page/JobInfoCard.dart';
import 'package:client_safe/pages/job_details_page/RemindersCard.dart';
import 'package:client_safe/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:client_safe/pages/job_details_page/scroll_stage_items/StageItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/Shadows.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
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

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

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
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() {
      setDialVisible(_scrollController.position.userScrollDirection == ScrollDirection.forward);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
        converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
        onInit: (appState) => {
          appState.dispatch(FetchTimeOfSunsetJobAction(appState.state.jobDetailsPageState)),
          appState.dispatch(FetchJobDetailsPricePackagesAction(appState.state.jobDetailsPageState)),
          appState.dispatch(FetchJobDetailsLocationsAction(appState.state.jobDetailsPageState)),
        },
        onDidChange: (pageState) {
          pageStateLocal = pageState;
        },
        builder: (BuildContext context, JobDetailsPageState pageState) {
          if(pageState.newStagAnimationIndex != -1 || scrollPosition == -2) {
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
              return Scaffold(
                floatingActionButton: SpeedDial(
                  // both default to 16
                  marginRight: 18,
                  marginBottom: 20,
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
                            'Feedback',
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
                            'Questionaire',
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
                            'Contract',
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

                      },
                    ),
                  ],
                ),
                body: Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.getBlueLight()),
                        image: DecorationImage(
                          image: AssetImage(ImageUtil.JOB_DETAILS_BG),
                          repeat: ImageRepeat.repeat,
                          fit: BoxFit.contain,
                        ),
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
                          expandedHeight: 325.0,
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
                                        fontSize: 20.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w800,
                                        color: Color(ColorConstants.getPrimaryWhite()),
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
                              JobInfoCard(pageState: pageState),
                              ClientDetailsCard(pageState: pageState),
                              DocumentsCard(pageState: pageState, onSendInvoiceSelected: onSendInvoiceSelected),
                              RemindersCard(),
                            ])),
                      ],
                    ),
                  ],
                ),
              ),
            );
        },
      );
  }

  void onSendInvoiceSelected() {
    pageStateLocal.onInvoiceSent(pageStateLocal.invoice);
    pageStateLocal.onStageCompleted(pageStateLocal.job, 7);
    pageStateLocal.removeExpandedIndex(7);
    pageStateLocal.setNewIndexForStageAnimation((JobStage.getStageValue(pageStateLocal.job.stage.stage)));
    VibrateUtil.vibrateHeavy();
  }

  void _onAddButtonPressed(BuildContext context) {
    UserOptionsUtil.showDashboardOptionsSheet(context);
  }

  bool get _isMinimized {
    return _scrollController.hasClients && _scrollController.offset > 260.0;
  }

  double _getScrollToOffset(JobDetailsPageState pageState) {
    if(pageState.job != null) {
      switch (pageState.job.stage.stage) {
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

  getFabIcon() {
    if(isFabExpanded){
      return Icon(Icons.close, color: Color(ColorConstants.getPrimaryWhite()));
    }else{
      return Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite()));
    }
  }
}
