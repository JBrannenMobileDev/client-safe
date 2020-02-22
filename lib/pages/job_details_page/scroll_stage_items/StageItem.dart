import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/Shadows.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class StageItem extends StatefulWidget {
  final int index;
  final Job job;
  StageItem(
      this.index,
      this.job,
  );

  @override
  State<StatefulWidget> createState() {
    return _StageItemState(index, job);
  }
}

class _StageItemState extends State<StageItem>
    with TickerProviderStateMixin{
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

  AssetImage stageImage;
  String stageTitle;
  String stageSubtitle;
  String actionButtonText;
  IconData actionIcon;
  bool isCurrentStage;
  bool isStageCompleted;
  int index;
  Job job;

  _StageItemState(
      this.index,
      this.job,
      );

  @override
  void initState() {
    super.initState();
    isCurrentStage = false;
    isStageCompleted = false;
    _setStageStatus(job, index);

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

    _checkCircleBgColor = ColorTween(begin: Colors.white, end: Color(ColorConstants.getCollectionColor2())).animate(_stageCompleteAnimation);
    _checkCircleBgColorCompleted = ColorTween(begin: Color(ColorConstants.getCollectionColor2()), end: Color(ColorConstants.getCollectionColor1())).animate(_newStageCompleteAnimation);
    _textColor = ColorTween(begin: Color(ColorConstants.getPrimaryBlack()), end: Color(ColorConstants.getPrimaryDarkColor())).animate(_stageCompleteAnimation);
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
    _textMarginTop = Tween<double>(begin: 188.0, end: 172.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _mainTextSize = Tween<double>(begin: 16.0, end: 14.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _subtextSize = Tween<double>(begin: 14.0, end: 10.0).animate(CurvedAnimation(
      parent: _stageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));

    _textColorReversed = ColorTween(begin: Color(ColorConstants.getPrimaryDarkColor()), end: Color(ColorConstants.getPrimaryBlack())).animate(_newStageCompleteAnimation);
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
    _checkCircleMarginBottomReversed = Tween<double>(begin: 78.0, end: 97.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _textMarginTopReversed = Tween<double>(begin: 172.0, end: 188.0).animate(CurvedAnimation(
      parent: _newStageCompleteAnimation,
      curve: Curves.fastOutSlowIn,
    ));
    _mainTextSizeReversed = Tween<double>(begin: 14.0, end: 16.0).animate(CurvedAnimation(
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
    return StoreConnector<AppState, JobDetailsPageState>(
        onDidChange: (pageState) => {
          setState(() {
            _setStageStatus(job, index);
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
                        right: index == 13 ? 72.0 : 0.0,
                    ),
                    height: 4.0,
                    color: Colors.white,
                  ),
                  isCurrentStage ? FadeTransition(
                    opacity: _pulsingCircleOpacity,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 32.0),
                      alignment: Alignment.center,
                      height: _pulsingCircleSize.value,
                      width: _pulsingCircleSize.value,
                      decoration: new BoxDecoration(
                        color: Colors.white30,
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
                      color: Colors.white,
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ImageUtil.getJobStageImage(index),
                            fit: BoxFit.contain,
                          ),
                        ),
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
                          }else{
                            Timer(Duration(milliseconds: 300), () => {
                              pageState.onStageCompleted(pageState.job, index),
                              isStageCompleted = true,
                              isCurrentStage = (index == 13) ? true : false,
                              pageState.removeExpandedIndex(index),
                              if(JobStage.getStageValue(pageState.job.stage.stage) < 14){
                                pageState.setNewIndexForStageAnimation((JobStage.getStageValue(pageState.job.stage.stage))),
                              },
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
                                image: isStageCompleted ? (_isExpanded(index, pageState) ? ImageUtil.getUndoImageAsset() : ImageUtil.getJobStageCompleteIconWhite()) : ImageUtil.getJobStageCompleteIconBlack(),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ) : isStageCompleted ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 56.0, bottom: 78.0),
                      height: 24.0,
                      width: 24.0,
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.getCollectionColor2()),
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
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w800,
                            color: isCurrentStage ? _textColor.value : _textColorReversed.value,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: isCurrentStage ? 1.0 : _subtextOpacityReversed.value,
                        child: Container(
                          width: 165.0,
                          padding: EdgeInsets.only(
                              top: 8.0),
                          child: Text(
                            _isExpanded(index, pageState) || isCurrentStage ? stageSubtitle : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w600,
                              color: isCurrentStage ? _textColor.value : _textColorReversed.value,
                            ),
                          ),
                        ),
                      ),
//                      isCurrentStage && _getActionForStage(job.stage, pageState) != null ?
                      (_isExpanded(index, pageState) && actionButtonText.length > 0) || (isCurrentStage &&  actionButtonText.length > 0) ?
                      Opacity(
                          opacity: isCurrentStage ? 1.0 : _subtextOpacityReversed.value,
                          child: Container(
                        alignment: Alignment.center,
                        height: 36.0,
                        width: 125.0,
                        margin: EdgeInsets.only(top: 8.0),
                        padding: EdgeInsets.only(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0),
                        decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(8.0),
                            color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                        child: GestureDetector(
                          onTap: () => {
                            _getActionForStage(job.stage, pageState),
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                actionIcon,
                                color: Colors.white,
                                size: 18.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  actionButtonText,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ), ) : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
      );
  }

  bool _containsStage(List<JobStage> completedStages, String stageConstant) {
    bool contains = false;
    for(JobStage stage in completedStages){
      if(stage.stage == stageConstant){
        contains = true;
      }
    }
    return contains;
  }

  _getActionForStage(JobStage stage, JobDetailsPageState pageState) {
    switch(stage.stage){
      case JobStage.STAGE_1_INQUIRY_RECEIVED:
        return pageState.onStage1Selected;
      case JobStage.STAGE_2_FOLLOWUP_SENT:
        return pageState.onStage2Selected;
      case JobStage.STAGE_3_PROPOSAL_SENT:
        return pageState.onStage3Selected;
      case JobStage.STAGE_4_PROPOSAL_SIGNED:
        return pageState.onStage4Selected;
      case JobStage.STAGE_5_DEPOSIT_RECEIVED:
        return pageState.onStage5Selected;
      case JobStage.STAGE_6_PLANNING_COMPLETE:
        return pageState.onStage6Selected;
      case JobStage.STAGE_7_SESSION_COMPLETE:
        return pageState.onStage7Selected;
      case JobStage.STAGE_8_PAYMENT_REQUESTED:
        return pageState.onStage8Selected;
      case JobStage.STAGE_9_PAYMENT_RECEIVED:
        return pageState.onStage9Selected;
      case JobStage.STAGE_10_EDITING_COMPLETE:
        return pageState.onStage10Selected;
      case JobStage.STAGE_11_GALLERY_SENT:
        return pageState.onStage11Selected;
      case JobStage.STAGE_12_FEEDBACK_REQUESTED:
        return pageState.onStage12Selected;
      case JobStage.STAGE_13_FEEDBACK_RECEIVED:
        return pageState.onStage13Selected;
      case JobStage.STAGE_14_JOB_COMPLETE:
        return pageState.onStage14Selected;
    }
  }

  bool _isExpanded(int index, JobDetailsPageState pageState) {
    return pageState.expandedIndexes.contains(index);
  }

  void _setStageStatus(Job job, int index) {
    switch(index){
      case 0:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_1_INQUIRY_RECEIVED;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_1_INQUIRY_RECEIVED);
        stageTitle = isStageCompleted ? 'Inquiry received!' : 'Receive inquiry';
        stageSubtitle = '';
        actionButtonText = '';
        break;
      case 1:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_2_FOLLOWUP_SENT;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_2_FOLLOWUP_SENT);
        stageTitle = isStageCompleted ? 'Followup sent!' : 'Followup sent?';
        stageSubtitle = 'Send followup to complete this stage.';
        actionButtonText = 'Send';
        actionIcon = Icons.message;
        break;
      case 2:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_3_PROPOSAL_SENT;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_3_PROPOSAL_SENT);
        stageTitle = isStageCompleted ? 'Contract sent!' : 'Contract sent?';
        stageSubtitle = 'Send a contract to complete this stage.';
        actionButtonText = 'Send';
        actionIcon = Icons.email;
        break;
      case 3:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_4_PROPOSAL_SIGNED;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_4_PROPOSAL_SIGNED);
        stageTitle = isStageCompleted ? 'Contract signed!' : 'Contract signed?';
        stageSubtitle = 'Receive a signed contract.';
        actionButtonText = 'Resend';
        actionIcon = Icons.email;
        break;
      case 4:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_5_DEPOSIT_RECEIVED;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_5_DEPOSIT_RECEIVED);
        stageTitle = isStageCompleted ? 'Deposit received!' : 'Deposit received?';
        stageSubtitle = 'Receive a deposit to complete this stage.';
        actionButtonText = '';
        break;
      case 5:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_6_PLANNING_COMPLETE;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_6_PLANNING_COMPLETE);
        stageTitle = isStageCompleted ? 'Planning complete' : 'Planning complete?';
        stageSubtitle = 'Finalize all the details for this job.';
        actionButtonText = 'Checklist';
        actionIcon = Icons.format_list_bulleted;
        break;
      case 6:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_7_SESSION_COMPLETE;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_7_SESSION_COMPLETE);
        stageTitle = isStageCompleted ? 'Session complete!' : 'Session complete?';
        stageSubtitle = '';
        actionButtonText = '';
        break;
      case 7:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_8_PAYMENT_REQUESTED;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_8_PAYMENT_REQUESTED);
        stageTitle = isStageCompleted ? 'Payment requested!' : 'Payment requested?';
        stageSubtitle = 'Request a payment to complete this stage.';
        actionButtonText = 'Send';
        actionIcon = Icons.attach_money;
        break;
      case 8:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_9_PAYMENT_RECEIVED;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_9_PAYMENT_RECEIVED);
        stageTitle = isStageCompleted ? 'Payment received!' : 'Payment received?';
        stageSubtitle = 'Receive full payment to complete this stage.';
        actionButtonText = 'Resend';
        actionIcon = Icons.attach_money;
        break;
      case 9:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_10_EDITING_COMPLETE;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_10_EDITING_COMPLETE);
        stageTitle = isStageCompleted ? 'Editing complete' : 'Editing complete?';
        stageSubtitle = 'Finish editing photos to somplete this stage.';
        actionButtonText = '';
        break;
      case 10:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_11_GALLERY_SENT;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_11_GALLERY_SENT);
        stageTitle = isStageCompleted ? 'Gallery sent!' : 'Gallery sent?';
        stageSubtitle = 'Send photo gallery to complete this stage.';
        actionButtonText = 'Send';
        actionIcon = Icons.photo_library;
        break;
      case 11:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_12_FEEDBACK_REQUESTED;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_12_FEEDBACK_REQUESTED);
        stageTitle = isStageCompleted ? 'Feedback requested!' : 'Feedback requested?';
        stageSubtitle = 'Request feedback to complete this stage.';
        actionButtonText = 'Send';
        actionIcon = Icons.feedback;
        break;
      case 12:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_13_FEEDBACK_RECEIVED;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_13_FEEDBACK_RECEIVED);
        stageTitle = isStageCompleted ? 'Feedback received!' : 'Feedback received?';
        stageSubtitle = 'Receive feedback to complete this stage.';
        actionButtonText = 'Resend';
        actionIcon = Icons.feedback;
        break;
      case 13:
        stageImage = ImageUtil.getJobStageImage(index);
        isCurrentStage = job.stage.stage == JobStage.STAGE_14_JOB_COMPLETE;
        isStageCompleted = _containsStage(job.completedStages, JobStage.STAGE_14_JOB_COMPLETE);
        stageTitle = isStageCompleted ? 'Job complete!' : 'Job complete?';
        stageSubtitle = '';
        actionButtonText = '';
        break;
    }
  }
}