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
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

import '../../utils/NavigationUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import '../contracts_page/ContractsPage.dart';
import 'IncomeCard.dart';
import 'JobDetailsCard.dart';
import 'JobNotesWidget.dart';
import 'LocationCard.dart';
import 'PosesCard.dart';
import 'SunsetWeatherCard.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({Key key, this.destination, this.comingFromOnBoarding}) : super(key: key);
  final JobDetailsPage destination;
  final bool comingFromOnBoarding;

  @override
  State<StatefulWidget> createState() {
    return _JobDetailsPageState(comingFromOnBoarding);
  }
}

class _JobDetailsPageState extends State<JobDetailsPage> with TickerProviderStateMixin{
  final GlobalKey<AnimatedListState> _listKeyVertical = GlobalKey<AnimatedListState>();
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  ScrollController _stagesScrollController = ScrollController(keepScrollOffset: true);
  double scrollPosition = -2;
  bool comingFromOnBoarding;
  _JobDetailsPageState(this.comingFromOnBoarding);
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
          content: new Text('All data for this job will be permanently deleted!'),
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
          content: new Text('All data for this job will be permanently deleted!'),
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
            appState.dispatch(FetchTimeOfSunsetJobAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchJobDetailsPricePackagesAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchJobDetailsLocationsAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchJobRemindersAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchAllJobTypesAction(appState.state.jobDetailsPageState)),
            appState.dispatch(FetchJobPosesAction(appState.state.jobDetailsPageState)),
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
                floatingActionButton: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpeedDial(
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
                  backgroundColor: Color(ColorConstants.getBlueDark()),
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
                    //         'Questionnaire',
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
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Contract',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) => ContractsPage(jobDocumentId: pageState.job.documentId)),
                        );
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
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Invoice',
                            color: Color(ColorConstants.getPrimaryBlack()),
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
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Reminder',
                            color: Color(ColorConstants.getPrimaryBlack()),
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
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Tip',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showTipChangeDialog(context);
                      },
                    ),
                  ],
                ),
                      GestureDetector(
                        onTap: () {
                          NavigationUtil.onShareWIthClientSelected(context, pageState.job);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
                          width: 200,
                          alignment: Alignment.center,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color(ColorConstants.getPeachDark()),
                            boxShadow: ElevationToShadow[6],
                          ),
                          child: TextDandyLight(
                              type: TextDandyLight.LARGE_TEXT,
                              color: Color(ColorConstants.getPrimaryWhite()),
                              text: "Share With Client"
                          ),
                        ),
                      )
                ],
                ),
                body: Container(
                child: Stack(
                  alignment: Alignment.bottomCenter,
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
                            color: Color(ColorConstants.getBlueDark()), //change your color here
                          ),
                          systemOverlayStyle: SystemUiOverlayStyle.light,
                          title: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: pageState.job.jobTitle,
                            color: Color(ColorConstants.getBlueDark()),
                            overflow: TextOverflow.fade,
                          ),
                          centerTitle: true,
                          titleSpacing: 48.0,
                          backgroundColor:
                          Colors.transparent,
                          elevation: 0.0,
                          pinned: false,
                          floating: false,
                          forceElevated: false,
                          expandedHeight: 305.0,
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
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Job Stages',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getBlueDark()),
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
                              PosesCard(pageState: pageState),
                              JobDetailsCard(),
                              SunsetWeatherCard(),
                              LocationCard(),
                              ClientDetailsCard(pageState: pageState),
                              // IncomeCard(onSendInvoiceSelected: onSendInvoiceSelected),
                              JobNotesWidget(),
                              DocumentsCard(pageState: pageState, onSendInvoiceSelected: onSendInvoiceSelected),
                              RemindersCard(pageState: pageState),
                            ])),
                      ],
                    ),
                    comingFromOnBoarding ? GestureDetector(
                      onTap: () async {
                        pageState.setOnBoardingComplete();
                        EventSender().sendEvent(eventName: EventNames.ON_BOARDING_COMPLETE, properties: {
                          EventNames.ON_BOARDING_COMPLETED_BY_PARAM : 'View sample job complete',
                        });
                        await UserPermissionsUtil.showPermissionRequest(permission: Permission.notification, context: context);
                        NavigationUtil.onSuccessfulLogin(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0, bottom: 32.0),
                        alignment: Alignment.center,
                        height: 54.0,
                        width: 96,
                        decoration: BoxDecoration(
                            color: Color(ColorConstants.getPeachDark()),
                            borderRadius: BorderRadius.circular(36.0),
                        ),
                        child: TextDandyLight(
                          text: 'DONE',
                          type: TextDandyLight.LARGE_TEXT,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ) : SizedBox(),
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
