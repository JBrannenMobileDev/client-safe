import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/client_details_page/SendMessageOptionsBottomSheet.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../../utils/DandyToastUtil.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../client_details_page/SelectSavedResponseBottomSheet.dart';
import '../../contracts_page/ContractsPage.dart';
import '../document_items/DocumentItem.dart';

class StageItem extends StatefulWidget {
  final int index;
  final Job job;
  final Function() onSendInvoiceSelected;
  final Function() onJobCompleteSelected;
  StageItem(
      this.index,
      this.job,
      this.onSendInvoiceSelected,
      this.onJobCompleteSelected,
  );

  @override
  State<StatefulWidget> createState() {
    return _StageItemState(index, job, onSendInvoiceSelected, onJobCompleteSelected);
  }
}

class _StageItemState extends State<StageItem>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  AnimationController _controller;
  AnimationController _pulsingRepeatController;
  AnimationController _stageCompleteAnimation;
  AnimationController _newStageCompleteAnimation;
  Animation<double> _pulsingCircleOpacity;
  Animation<double> _pulsingCircleSize;
  Animation<double> _checkCircleCheckSize;
  Animation<double> _checkCircleSize;
  Animation<double> _checkCircleMarginLeft;
  Animation<double> _checkCircleMarginBottom;
  Animation<double> _mainCircleSize;
  Animation<double> _mainCirclePadding;
  Animation<double> _mainTextSize;
  Animation<double> _subtextSize;
  Animation<double> _textMarginTop;
  Animation _textColor;
  Animation _checkCircleBgColor;
  Animation _checkCircleBgColorCompleted;

  Animation<double> _checkCircleCheckSizeReversed;
  Animation<double> _checkCircleSizeReversed;
  Animation<double> _checkCircleMarginLeftReversed;
  Animation<double> _checkCircleMarginBottomReversed;
  Animation<double> _mainCircleSizeReversed;
  Animation<double> _mainCirclePaddingReversed;
  Animation<double> _mainTextSizeReversed;
  Animation<double> _subtextOpacityReversed;
  Animation<double> _textMarginTopReversed;
  Animation _textColorReversed;

  Image stageImage;
  String stageTitle;
  String stageSubtitle;
  String actionButtonText;
  IconData actionIcon;
  bool isCurrentStage;
  bool isStageCompleted;
  int index;
  Job staleJob;
  Function() onSendInvoiceSelected;
  final Function() onJobCompleteSelected;

  _StageItemState(
      this.index,
      this.staleJob,
      this.onSendInvoiceSelected,
      this.onJobCompleteSelected
      );

  @override
  void initState() {
    super.initState();
    isCurrentStage = false;
    isStageCompleted = false;
    _setStageStatus(staleJob, index);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulsingRepeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulsingCircleOpacity =
        Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
          parent: _pulsingRepeatController,
          curve: Curves.fastOutSlowIn,
        ));
    _pulsingCircleSize =
        Tween<double>(begin: 112.0, end: 172.0).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
        ));
    if(isCurrentStage){
      _pulsingCircleSize.addListener(() => this.setState(() {}));
      _controller.repeat();
      _pulsingRepeatController.repeat();
    }
    _stageCompleteAnimation = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    );

    _newStageCompleteAnimation = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    );

    _checkCircleBgColor = ColorTween(begin: Color(ColorConstants.getPrimaryWhite()), end: Color(ColorConstants.getPrimaryWhite())).animate(_stageCompleteAnimation);
    _checkCircleBgColorCompleted = ColorTween(begin: Color(ColorConstants.getPeachDark()), end: Color(ColorConstants.getPeachDark())).animate(_newStageCompleteAnimation);
    _textColor = ColorTween(begin: Color(ColorConstants.getPeachDark()), end: Color(ColorConstants.getPeachDark())).animate(_stageCompleteAnimation);
    _checkCircleCheckSize = Tween<double>(begin: 20.0, end: 10.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _checkCircleSize = Tween<double>(begin: 48.0, end: 24.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _mainCircleSize = Tween<double>(begin: 112.0, end: 72.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _mainCirclePadding = Tween<double>(begin: 18.0, end: 12.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _checkCircleMarginLeft = Tween<double>(begin: 81.0, end: 56.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _checkCircleMarginBottom = Tween<double>(begin: 97.0, end: 78.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _textMarginTop = Tween<double>(begin: 163.0, end: 147.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _mainTextSize = Tween<double>(begin: 20.0, end: 18.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _subtextSize = Tween<double>(begin: 16.0, end: 12.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));

    _textColorReversed = ColorTween(begin: Color(ColorConstants.getBlueDark()), end: Color(ColorConstants.getBlueDark())).animate(_newStageCompleteAnimation);
    _checkCircleCheckSizeReversed = Tween<double>(begin: 10.0, end: 20.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _checkCircleSizeReversed = Tween<double>(begin: 24.0, end: 48.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _mainCircleSizeReversed = Tween<double>(begin: 72.0, end: 112.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ))..addListener(() {
      setState(() {});
    });
    _mainCirclePaddingReversed = Tween<double>(begin: 12.0, end: 18.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _checkCircleMarginLeftReversed = Tween<double>(begin: 56.0, end: 81.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _checkCircleMarginBottomReversed = Tween<double>(begin: 78.0, end: 112.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _textMarginTopReversed = Tween<double>(begin: 147.0, end: 163.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _mainTextSizeReversed = Tween<double>(begin: 18.0, end: 20.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _subtextOpacityReversed = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void dispose() {
    _pulsingRepeatController.dispose();
    _controller.dispose();
    _stageCompleteAnimation.dispose();
    _newStageCompleteAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, JobDetailsPageState>(
        onDidChange: (prev, pageState) => {
          setState(() {
            _setStageStatus(pageState.job, index);
            if(isCurrentStage){
              _pulsingCircleSize.addListener(() => this.setState(() {}));
              _controller.repeat();
              _pulsingRepeatController.repeat();
            }
            if(pageState.newStagAnimationIndex == index){
              if(!_isExpanded(index, pageState)){
                _newStageCompleteAnimation.forward();
                pageState.addExpandedIndex(index);
              }
              pageState.setNewIndexForStageAnimation(-1);
            }
          }),
        },
        converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
        builder: (BuildContext context, JobDetailsPageState pageState) =>
            Container(
              width: 200.0,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[Container(
                    margin: EdgeInsets.only(
                        bottom: 30.0,
                        left: index == 0 ? 72.0 : 0.0,
                        right: index == pageState.job.type.stages.length-1 ? 72.0 : 0.0,
                    ),
                    height: 4.0,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                  isCurrentStage ? FadeTransition(
                    opacity: _pulsingCircleOpacity,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 32.0),
                      alignment: Alignment.center,
                      height: _pulsingCircleSize.value,
                      width: _pulsingCircleSize.value,
                      decoration: new BoxDecoration(
                        color: Color(ColorConstants.getPrimaryWhite()).withOpacity(.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ) : SizedBox(),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        if(!_isExpanded(index, pageState)){
                          pageState.addExpandedIndex(index);
                          _newStageCompleteAnimation.forward();
                        }else{
                          Timer(Duration(milliseconds: 300), () => {
                            pageState.removeExpandedIndex(index),
                          });
                          _newStageCompleteAnimation.reverse();
                        }
                    })
                    },
                    child: Container(
                    margin: EdgeInsets.only(bottom: 32.0, right: 16.0, left: 16.0),
                    height: isCurrentStage ? _mainCircleSize.value : _mainCircleSizeReversed.value,
                    width: isCurrentStage ? _mainCircleSize.value : _mainCircleSizeReversed.value,
                    padding: EdgeInsets.all(isCurrentStage ? _mainCirclePadding.value : _mainCirclePaddingReversed.value),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(56.0),
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: Container(
                        padding: EdgeInsets.all(4),
                        child: pageState.job.type.stages.length > index ? ImageUtil.getJobStageImageFromStage(pageState.job.type.stages.elementAt(index), isCurrentStage) : SizedBox(),
                      ),
                    ),
                  ),
                    isCurrentStage || _isExpanded(index, pageState) ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if(isStageCompleted){
                              isStageCompleted = false;
                              isCurrentStage = false;
                              pageState.onStageUndo(pageState.job, index);
                            VibrateUtil.vibrateHeavy();
                              _stageCompleteAnimation.reset();
                            _newStageCompleteAnimation.reverse();
                              pageState.removeExpandedIndex(index);
                              pageState.setNewIndexForStageAnimation((JobStage.getIndexOfCurrentStage(pageState.job.stage.stage, pageState.job.type.stages)));
                          }else{
                            if(index >= pageState.job.type.stages.length-1) {
                              onJobCompleteSelected();
                            }
                            Timer(Duration(milliseconds: 300), () => {
                              pageState.onStageCompleted(pageState.job, index),
                              isStageCompleted = true,
                              isCurrentStage = false,
                              pageState.removeExpandedIndex(index),
                              pageState.setNewIndexForStageAnimation((JobStage.getIndexOfCurrentStage(pageState.job.stage.stage, pageState.job.type.stages))),
                            });
                            VibrateUtil.vibrateHeavy();
                            _newStageCompleteAnimation.reset();
                            _stageCompleteAnimation.forward();
                          }
                        });
                      },

                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: isCurrentStage ? _checkCircleMarginLeft.value : _checkCircleMarginLeftReversed.value,
                            bottom: isCurrentStage ? _checkCircleMarginBottom.value : _checkCircleMarginBottomReversed.value),
                        height: isCurrentStage ? _checkCircleSize.value : _checkCircleSizeReversed.value,
                        width: isCurrentStage ? _checkCircleSize.value : _checkCircleSizeReversed.value,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[8],
                          color: isStageCompleted ? _checkCircleBgColorCompleted.value : _checkCircleBgColor.value,
                          borderRadius: new BorderRadius.circular(28.0),
                        ),
                        padding: EdgeInsets.all(2.0),
                        child: Opacity(
                          opacity: isStageCompleted ? 1.0 : 0.25,
                          child: Container(
                            height: isCurrentStage ? _checkCircleCheckSize.value : _checkCircleCheckSizeReversed.value,
                            width: isCurrentStage ? _checkCircleCheckSize.value*2 : _checkCircleCheckSizeReversed.value*2,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: isStageCompleted ? (_isExpanded(index, pageState) ? ImageUtil.getJobStageCompleteIconWhite() : ImageUtil.getJobStageCompleteIconWhite()) : ImageUtil.getJobStageCompleteIconBlack(),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ) : isStageCompleted ? GestureDetector(
                      onTap: () {
                        pageState.addExpandedIndex(index);
                        _newStageCompleteAnimation.forward();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 56.0, bottom: 78.0),
                        height: 24.0,
                        width: 24.0,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getPeachDark()),
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(2.0),
                        child: Container(
                          height: 10.0,
                          width: 20.0,
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: ImageUtil.getJobStageCompleteIconWhite(),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ) : SizedBox(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: isCurrentStage ? _textMarginTop.value : _textMarginTopReversed.value),
                        child: Text(
                          stageTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isCurrentStage ? _mainTextSize.value : _mainTextSizeReversed.value,
                            fontFamily: 'Open Sans',
                            color: isCurrentStage ? Color(ColorConstants.getPeachDark()) : Color(ColorConstants.getBlueDark()),
                          ),
                        ),
                      ),
                      (_isExpanded(index, pageState) &&
                          actionButtonText.length > 0) ||
                          (isCurrentStage && actionButtonText.length > 0) ?
                      Opacity(
                        opacity: isCurrentStage ? 1.0 : _subtextOpacityReversed.value,
                        child: GestureDetector(
                          onTap: () {
                            switch (pageState.job.type.stages.elementAt(index).stage) {
                              case JobStage.STAGE_1_INQUIRY_RECEIVED:
                                break;
                              case JobStage.STAGE_2_FOLLOWUP_SENT:
                                onSMSPressed(pageState.client.phone, context, pageState);
                                EventSender().sendEvent(eventName: EventNames.BT_STAGE_ACTION, properties: {EventNames.ACTIVE_STAGE_PARAM_NAME : JobStage.STAGE_2_FOLLOWUP_SENT});
                                break;
                              case JobStage.STAGE_3_PROPOSAL_SENT:
                                if(pageState.job.proposal.contract == null) {
                                  Navigator.of(context).push(
                                    new MaterialPageRoute(builder: (context) => ContractsPage(jobDocumentId: pageState.job.documentId)),
                                  );
                                } else {
                                  NavigationUtil.onShareWIthClientSelected(context, pageState.job);
                                  EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_FROM_CONTRACT_STAGE);
                                }
                                break;
                              case JobStage.STAGE_4_PROPOSAL_SIGNED:
                                NavigationUtil.onShareWIthClientSelected(context, pageState.job);
                                EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_FROM_CONTRACT_STAGE);
                                break;
                              case JobStage.STAGE_5_DEPOSIT_RECEIVED:
                                IntentLauncherUtil.shareDepositRequest(pageState.job.depositAmount);
                                EventSender().sendEvent(eventName: EventNames.BT_STAGE_ACTION, properties: {EventNames.ACTIVE_STAGE_PARAM_NAME : JobStage.STAGE_5_DEPOSIT_RECEIVED});
                                break;
                              case JobStage.STAGE_6_PLANNING_COMPLETE:
                                Share.shareFiles(
                                    pageState.poseFilePaths,
                                    subject: 'Example Poses');
                                EventSender().sendEvent(eventName: EventNames.BT_SHARE_JOB_POSES);
                                EventSender().sendEvent(eventName: EventNames.BT_STAGE_ACTION, properties: {EventNames.ACTIVE_STAGE_PARAM_NAME : JobStage.STAGE_6_PLANNING_COMPLETE});
                                break;
                              case JobStage.STAGE_7_SESSION_COMPLETE:
                                String message = 'Hi ${pageState.job.clientName.split(' ')[0]}, here are the driving directions to the location we discussed. \n${pageState.selectedLocation.locationName}\n\nhttps://www.google.com/maps/search/?api=1&query=${pageState.selectedLocation.latitude},${pageState.selectedLocation.longitude}';
                                UserOptionsUtil.showShareOptionsSheet(context, pageState.client, message, 'Location details');
                                EventSender().sendEvent(eventName: EventNames.BT_STAGE_ACTION, properties: {EventNames.ACTIVE_STAGE_PARAM_NAME : JobStage.STAGE_7_SESSION_COMPLETE});
                                break;
                              case JobStage.STAGE_8_PAYMENT_REQUESTED:
                                if(pageState.job.invoice != null) {
                                  NavigationUtil.onShareWIthClientSelected(context, pageState.job);
                                  EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_FROM_INVOICE_STAGE);
                                  pageState.onInvoiceSent(pageState.job.invoice);
                                  pageState.onStageCompleted(
                                      pageState.job, index);
                                  isStageCompleted = true;
                                  isCurrentStage = false;
                                  pageState.removeExpandedIndex(index);
                                  pageState.setNewIndexForStageAnimation((JobStage.getIndexOfCurrentStage(pageState.job.stage.stage, pageState.job.type.stages)));
                                  VibrateUtil.vibrateHeavy();
                                  _newStageCompleteAnimation.reset();
                                  _stageCompleteAnimation.forward();
                                }else {
                                  if(pageState.job.priceProfile != null) {
                                    bool containsInvoice = false;
                                    for(DocumentItem document in pageState.documents){
                                      if(document.getDocumentType() == DocumentItem.DOCUMENT_TYPE_INVOICE) containsInvoice = true;
                                    }
                                    if(!containsInvoice) {
                                      pageState.onAddInvoiceSelected();
                                      UserOptionsUtil.showNewInvoiceDialog(context, onSendInvoiceSelected, false);
                                    }else{
                                      pageState.onAddInvoiceSelected();
                                      UserOptionsUtil.showInvoiceOptionsDialog(context, onSendInvoiceSelected);
                                    }
                                  } else {
                                    DandyToastUtil.showErrorToast('Please select a price package for this job before creating an invoice.');
                                  }
                                }
                                EventSender().sendEvent(eventName: EventNames.BT_STAGE_ACTION, properties: {EventNames.ACTIVE_STAGE_PARAM_NAME : JobStage.STAGE_8_PAYMENT_REQUESTED});
                                break;
                              case JobStage.STAGE_9_PAYMENT_RECEIVED:
                                if(pageState.invoice != null) {
                                  NavigationUtil.onShareWIthClientSelected(context, pageState.job);
                                  EventSender().sendEvent(eventName: EventNames.SHARE_WITH_CLIENT_FROM_INVOICE_STAGE);
                                  pageState.onInvoiceSent(pageState.invoice);
                                }else {
                                  pageState.onAddInvoiceSelected();
                                  UserOptionsUtil.showNewInvoiceDialog(context, onSendInvoiceSelected, true);
                                }
                                EventSender().sendEvent(eventName: EventNames.BT_STAGE_ACTION, properties: {EventNames.ACTIVE_STAGE_PARAM_NAME : JobStage.STAGE_9_PAYMENT_RECEIVED});
                                break;
                              case JobStage.STAGE_10_EDITING_COMPLETE:
                                break;
                              case JobStage.STAGE_11_GALLERY_SENT:
                                break;
                              case JobStage.STAGE_12_FEEDBACK_REQUESTED:
                                break;
                              case JobStage.STAGE_13_FEEDBACK_RECEIVED:
                                break;
                              case JobStage.STAGE_14_JOB_COMPLETE:
                                break;
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 32.0,
                            width: 142.0,
                            margin: EdgeInsets.only(top: 5.0),
                            padding: EdgeInsets.only(
                                top: 4.0, left: 8.0, bottom: 4.0, right: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(18.0),
                              color: Color(ColorConstants.getPeachDark()),
                            ),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: actionButtonText,
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),) : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
      );
  }

  bool _isExpanded(int index, JobDetailsPageState pageState) {
    return pageState.expandedIndexes.contains(index);
  }

  void onSMSPressed(String phoneNum, BuildContext context, JobDetailsPageState pageState){
    if(phoneNum != null && phoneNum.isNotEmpty) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
        builder: (context) {
          return SendMessageOptionsBottomSheet(SelectSavedResponseBottomSheet.TYPE_SMS, phoneNum);
        },
      );
    } else {
      DandyToastUtil.showToast("You have not saved a phone number yet for " + pageState.client.firstName, Color(ColorConstants.getBlueDark()));
    }
  }

  void _setStageStatus(Job job, int index) {
    switch(job.type.stages.elementAt(index).stage){
      case JobStage.STAGE_1_INQUIRY_RECEIVED:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_1_INQUIRY_RECEIVED;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_1_INQUIRY_RECEIVED);
        stageTitle = isStageCompleted ? 'Inquiry received!' : 'Receive inquiry';
        stageSubtitle = '';
        actionButtonText = '';
        break;
      case JobStage.STAGE_2_FOLLOWUP_SENT:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_2_FOLLOWUP_SENT;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_2_FOLLOWUP_SENT);
        stageTitle = isStageCompleted ? 'Followup sent!' : 'Followup sent?';
        stageSubtitle = '';
        actionButtonText = 'Send Text';
        actionIcon = Icons.message;
        break;
      case JobStage.STAGE_3_PROPOSAL_SENT:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_3_PROPOSAL_SENT;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_3_PROPOSAL_SENT);
        stageTitle = isStageCompleted ? 'Contract sent!' : 'Contract sent?';
        stageSubtitle = '';
        actionButtonText = job.proposal.contract != null ? 'Send' : 'New Contract';
        actionIcon = Icons.email;
        break;
      case JobStage.STAGE_4_PROPOSAL_SIGNED:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_4_PROPOSAL_SIGNED;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_4_PROPOSAL_SIGNED);
        stageTitle = isStageCompleted ? 'Contract signed!' : 'Contract signed?';
        stageSubtitle = '';
        actionButtonText = 'Resend';
        actionIcon = Icons.email;
        break;
      case JobStage.STAGE_5_DEPOSIT_RECEIVED:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_5_DEPOSIT_RECEIVED;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_5_DEPOSIT_RECEIVED);
        stageTitle = isStageCompleted ? 'Deposit received!' : 'Deposit received?';
        stageSubtitle = '';
        actionButtonText = job.priceProfile != null && job.priceProfile.deposit != null && job.priceProfile.deposit > 0 ? 'Request Deposit' : '';
        break;
      case JobStage.STAGE_6_PLANNING_COMPLETE:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_6_PLANNING_COMPLETE;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_6_PLANNING_COMPLETE);
        stageTitle = isStageCompleted ? 'Planning complete' : 'Planning complete?';
        stageSubtitle = '';
        actionButtonText = job.poses.length > 0 ? 'Send poses' : '';
        actionIcon = Icons.format_list_bulleted;
        break;
      case JobStage.STAGE_7_SESSION_COMPLETE:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_7_SESSION_COMPLETE;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_7_SESSION_COMPLETE);
        stageTitle = isStageCompleted ? 'Session complete!' : 'Session complete?';
        stageSubtitle = '';
        actionButtonText = job.location != null ? 'Share location' : '';
        break;
      case JobStage.STAGE_8_PAYMENT_REQUESTED:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_8_PAYMENT_REQUESTED;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_8_PAYMENT_REQUESTED);
        stageTitle = isStageCompleted ? 'Invoice sent!' : 'Invoice sent?';
        stageSubtitle = '';
        actionButtonText = isStageCompleted ? '' : job.invoice != null ? 'Send' : 'New invoice';
        actionIcon = Icons.attach_money;
        break;
      case JobStage.STAGE_9_PAYMENT_RECEIVED:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_9_PAYMENT_RECEIVED;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_9_PAYMENT_RECEIVED);
        stageTitle = isStageCompleted ? 'Payment received!' : 'Payment received?';
        stageSubtitle = '';
        actionButtonText = Job.containsStage(job.completedStages, JobStage.STAGE_8_PAYMENT_REQUESTED) ? 'Resend invoice' : '';
        actionIcon = Icons.attach_money;
        break;
      case JobStage.STAGE_10_EDITING_COMPLETE:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_10_EDITING_COMPLETE;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_10_EDITING_COMPLETE);
        stageTitle = isStageCompleted ? 'Editing complete' : 'Editing complete?';
        stageSubtitle = '';
        actionButtonText = '';
        break;
      case JobStage.STAGE_11_GALLERY_SENT:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_11_GALLERY_SENT;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_11_GALLERY_SENT);
        stageTitle = isStageCompleted ? 'Gallery sent!' : 'Gallery sent?';
        stageSubtitle = '';
        actionButtonText = '';
        break;
      case JobStage.STAGE_12_FEEDBACK_REQUESTED:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_12_FEEDBACK_REQUESTED;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_12_FEEDBACK_REQUESTED);
        stageTitle = isStageCompleted ? 'Feedback requested!' : 'Feedback requested?';
        stageSubtitle = '';
        // actionButtonText = 'Send';
        actionButtonText = '';
        actionIcon = Icons.feedback;
        break;
      case JobStage.STAGE_13_FEEDBACK_RECEIVED:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_13_FEEDBACK_RECEIVED;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_13_FEEDBACK_RECEIVED);
        stageTitle = isStageCompleted ? 'Feedback received!' : 'Feedback received?';
        stageSubtitle = '';
        // actionButtonText = 'Resend';
        actionButtonText = '';
        actionIcon = Icons.feedback;
        break;
      case JobStage.STAGE_14_JOB_COMPLETE:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.stage == JobStage.STAGE_14_JOB_COMPLETE;
        isStageCompleted = Job.containsStage(job.completedStages, JobStage.STAGE_14_JOB_COMPLETE);
        stageTitle = isStageCompleted ? 'Job complete!' : 'Job complete?';
        stageSubtitle = '';
        actionButtonText = '';
        break;
      default:
        stageImage = ImageUtil.getJobStageImageFromStage(job.type.stages.elementAt(index), isCurrentStage);
        isCurrentStage = job.stage.id == job.type.stages.elementAt(index).id;
        isStageCompleted = Job.containsStageById(job.completedStages, job.type.stages.elementAt(index).id);
        stageTitle = isStageCompleted ? job.type.stages.elementAt(index).stage + '!' : job.type.stages.elementAt(index).stage + '?';
        stageSubtitle = '';
        actionButtonText = '';
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}