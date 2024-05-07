import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/job_details_page/ClientDetailsCard.dart';
import 'package:dandylight/pages/job_details_page/DocumentsCard.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/job_details_page/RemindersCard.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/pages/job_details_page/scroll_stage_items/StageItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../navigation/routes/RouteNames.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/UidUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import '../contracts_page/ContractsPage.dart';
import 'JobDetailsCard.dart';
import 'JobNotesWidget.dart';
import 'LocationCard.dart';
import 'PosesCard.dart';
import 'SunsetWeatherCard.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({Key? key, this.destination, this.comingFromOnBoarding = false, this.jobDocumentId}) : super(key: key);
  final JobDetailsPage? destination;
  final bool? comingFromOnBoarding;
  final String? jobDocumentId;

  @override
  State<StatefulWidget> createState() {
    return _JobDetailsPageState(comingFromOnBoarding, jobDocumentId);
  }
}

class _JobDetailsPageState extends State<JobDetailsPage> with TickerProviderStateMixin{
  final GlobalKey<AnimatedListState> _listKeyVertical = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  ScrollController _stagesScrollController = ScrollController(keepScrollOffset: true);
  double scrollPosition = -2;
  bool? comingFromOnBoarding;
  _JobDetailsPageState(this.comingFromOnBoarding, this.jobDocumentId);
  bool sliverCollapsed = false;
  bool isFabExpanded = false;
  bool dialVisible = true;
  JobDetailsPageState? pageStateLocal;
  String? jobDocumentId;

  Future<void> _ackAlert(BuildContext context, JobDetailsPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('All data for this job will be permanently deleted!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected!();
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('All data for this job will be permanently deleted!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected!();
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
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
          if(jobDocumentId != null) {
            appState.dispatch(SetJobInfo(appState.state.jobDetailsPageState, jobDocumentId)),
          }
        },
        onDidChange: (prev, pageState) {
          pageStateLocal = pageState;
        },
        builder: (BuildContext context, JobDetailsPageState pageState) {
          if((pageState.newStagAnimationIndex != -1 || scrollPosition == -2) && _stagesScrollController.hasClients) {
            Timer(const Duration(milliseconds: 150), () {
              _stagesScrollController.animateTo(
                _getScrollToOffset(pageState),
                curve: Curves.easeInOutCubic,
                duration: const Duration(milliseconds: 1000),
              );
            },
            );
            _stagesScrollController = ScrollController(initialScrollOffset: _getScrollToOffset(pageState));
            pageState.setNewIndexForStageAnimation!(-1);
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
                  childMargin: const EdgeInsets.only(right: 18.0, bottom: 20.0),
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
                  backgroundColor: Color(ColorConstants.getPeachDark()),
                  foregroundColor: Colors.black,
                  elevation: 8.0,
                  shape: const CircleBorder(),
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
                    //       color: Color(ColorConstants.getPrimaryWhite()),
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
                    //       color: Color(ColorConstants.getPrimaryWhite()),
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
                      child: const Icon(Icons.add),
                      shape: const CircleBorder(),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Invoice',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        if(pageState.job!.priceProfile != null) {
                          bool containsInvoice = false;
                          for(DocumentItem document in pageState.documents!){
                            if(document.getDocumentType() == DocumentItem.DOCUMENT_TYPE_INVOICE) containsInvoice = true;
                          }
                          if(!containsInvoice) {
                            UserOptionsUtil.showNewInvoiceDialog(context, onSendInvoiceSelected, job: pageState.job);
                          }else{
                            UserOptionsUtil.showInvoiceOptionsDialog(context, onSendInvoiceSelected, job: pageState.job);
                          }
                        } else {
                          DandyToastUtil.showErrorToast('Please select a price package for this job before creating an invoice.');
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.add),
                      shape: const CircleBorder(),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Questionnaire',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () async {
                        NavigationUtil.onAddQuestionnaireToJobSelected(context, pageState.job!.documentId!);
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.add),
                      shape: const CircleBorder(),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Contract',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        bool containsContract = false;
                        for(DocumentItem document in pageState.documents!){
                          if(document.getDocumentType() == DocumentItem.DOCUMENT_TYPE_CONTRACT) containsContract = true;
                        }
                        if(!containsContract) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ContractsPage(jobDocumentId: pageState.job!.documentId)),
                          );
                        }else{
                          UserOptionsUtil.showContractOptionsDialog(context);
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.add),
                      shape: const CircleBorder(),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Reminder',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showNewJobReminderDialog(context, pageState.job!);
                      },
                    ),
                  ],
                ),
                      comingFromOnBoarding! ? GestureDetector(
                        onTap: () {
                          _launchBrandingPreviewURL(UidUtil().getUid());
                          EventSender().sendEvent(eventName: EventNames.ON_BOARDING_PREVIEW_CLIENT_PORTAL_SELECTED);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 196,
                          alignment: Alignment.center,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color(ColorConstants.getPeachDark()),
                            boxShadow: ElevationToShadow[6],
                          ),
                          child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              color: Color(ColorConstants.getPrimaryWhite()),
                              text: "Preview Client Portal"
                          ),
                        ),
                      ) : GestureDetector(
                        onTap: () {
                          NavigationUtil.onShareWIthClientSelected(context, pageState.job!);
                          EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_FROM_JOB);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 164,
                          alignment: Alignment.center,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color(ColorConstants.getPeachDark()),
                            boxShadow: ElevationToShadow[6],
                          ),
                          child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              color: Color(ColorConstants.getPrimaryWhite()),
                              text: "Share With Client"
                          ),
                        ),
                      )
                ],
                ),
                body: Stack(
                  alignment: Alignment.topRight,
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
                        SliverAppBar(
                          iconTheme: IconThemeData(
                            color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                          ),
                          systemOverlayStyle: SystemUiOverlayStyle.light,
                          title: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: pageState.job!.jobTitle,
                            color: Color(ColorConstants.getPrimaryBlack()),
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
                            !comingFromOnBoarding! ? IconButton(
                              icon: ImageIcon(ImageUtil.getTrashIconWhite()),
                              tooltip: 'Delete Job',
                              onPressed: () {
                                _ackAlert(context, pageState);
                              },
                            ) : const SizedBox(),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top: 56.0),
                                  alignment: Alignment.topCenter,
                                  child: SafeArea(
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: 'Job Stages',
                                      textAlign: TextAlign.center,
                                      color: Color(ColorConstants.getPrimaryBlack()),
                                    ),
                              ),
                            ),
                            SafeArea(
                              child: Container(
                                margin: const EdgeInsets.only(top: 25.0),
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
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.all(16.0),
                                          itemCount: pageState.job!.type!.stages!.length,
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
                        SliverList(
                            delegate: SliverChildListDelegate(<Widget>[
                              Padding(
                                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                                child: PosesCard(pageState: pageState),
                              ),
                              Padding(
                                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                                child: const JobDetailsCard(),
                              ),
                              Padding(
                                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                                child: DocumentsCard(pageState: pageState, onSendInvoiceSelected: onSendInvoiceSelected, profile: pageState.profile),
                              ),
                              Padding(
                                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                                child: const SunsetWeatherCard(),
                              ),
                              Padding(
                                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                                child: const LocationCard(),
                              ),
                              Padding(
                                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                                child: ClientDetailsCard(pageState: pageState),
                              ),
                              Padding(
                                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                                child: const JobNotesWidget(),
                              ),Padding(
                                padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                                child: RemindersCard(pageState: pageState),
                              )
                            ])),
                      ],
                    ),
                    comingFromOnBoarding! ? GestureDetector(
                      onTap: () async {
                        pageState.setOnBoardingComplete!();
                        EventSender().sendEvent(eventName: EventNames.ON_BOARDING_COMPLETE, properties: {
                          EventNames.ON_BOARDING_COMPLETED_BY_PARAM : 'View sample job complete',
                        });
                        await UserPermissionsUtil.showPermissionRequest(permission: Permission.notification, context: context);
                        NavigationUtil.onSuccessfulLogin(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        margin: const EdgeInsets.only(left: 24.0, right: 8.0, top: 66.0, bottom: 32.0),
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 96,
                        decoration: BoxDecoration(
                            color: Color(ColorConstants.getBlueDark()),
                            borderRadius: BorderRadius.circular(36.0),
                        ),
                        child: TextDandyLight(
                          text: 'DONE',
                          type: TextDandyLight.LARGE_TEXT,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ) : const SizedBox(),
                  ],
                ),
            ) : const SizedBox();
        },
      );
  }

  void onSendInvoiceSelected() {
    pageStateLocal!.onInvoiceSent!(pageStateLocal!.invoice!);
    pageStateLocal!.onStageCompleted!(pageStateLocal!.job!, 7);
    pageStateLocal!.removeExpandedIndex!(7);
    pageStateLocal!.setNewIndexForStageAnimation!((JobStage.getIndexOfCurrentStage(pageStateLocal!.job!.stage!.stage!, pageStateLocal!.job!.type!.stages!)));
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
      int stageIndex = JobStage.getIndexOfCurrentStage(pageState.job!.stage!.stage!, pageState.job!.type!.stages!);

      return (stageIndex * 200.0) - ((stageIndex == pageState.job!.type!.stages!.length - 1) ? 150 : (stageIndex == pageState.job!.type!.stages!.length ) ? 360 : 0);
    }
    return 0.0;
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) => _getWidgetForIndex(index, pageState.job!),
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
            padding: const EdgeInsets.all(96.0),
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

  void _launchBrandingPreviewURL(String uid) async {
    print('https://dandylight.com/${RouteNames.BRANDING_PREVIEW}/$uid');
    await canLaunchUrl(Uri.parse('https://dandylight.com/${RouteNames.BRANDING_PREVIEW}/$uid')) ? await launchUrl(Uri.parse('https://dandylight.com/${RouteNames.BRANDING_PREVIEW}/$uid'), mode: LaunchMode.externalApplication) : throw 'Could not launch';
  }
}
