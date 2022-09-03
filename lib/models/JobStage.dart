import 'package:flutter/cupertino.dart';

class JobStage {
  static const String STAGE_1_INQUIRY_RECEIVED = "Inquiry Received";
  static const String STAGE_2_FOLLOWUP_SENT = "Followup Sent";
  static const String STAGE_3_PROPOSAL_SENT = "Contract Sent";
  static const String STAGE_4_PROPOSAL_SIGNED = "Contract Signed";
  static const String STAGE_5_DEPOSIT_RECEIVED = "Deposit received";
  static const String STAGE_6_PLANNING_COMPLETE = "Planning Complete";
  static const String STAGE_7_SESSION_COMPLETE = "Session Complete";
  static const String STAGE_8_PAYMENT_REQUESTED = "Invoice Sent";
  static const String STAGE_9_PAYMENT_RECEIVED = "Payment Received";
  static const String STAGE_10_EDITING_COMPLETE = "Editing Complete";
  static const String STAGE_11_GALLERY_SENT = "Gallery Sent";
  static const String STAGE_12_FEEDBACK_REQUESTED = "Feedback Requested";
  static const String STAGE_13_FEEDBACK_RECEIVED = "Feedback Received";
  static const String STAGE_14_JOB_COMPLETE = "Job Complete";
  static const String STAGE_COMPLETED_CHECK = "Completed";


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStage &&
          runtimeType == other.runtimeType &&
          stage == other.stage &&
          imageLocation == other.imageLocation;

  int compareTo(JobStage b) {
    int indexOfA = getIndexOfStageInStages(this, AllStages());
    int indexOfB = getIndexOfStageInStages(b, AllStages());
    int result = 0;
    if(indexOfA < indexOfB) result = -1;
    if(indexOfB == indexOfB) result = 0;
    if(indexOfA > indexOfB) result = 1;
    return result;
  }

  static getIndexOfStageInStages(JobStage completedStage, List<JobStage> stages) {
    for(int i=0 ; i <= stages.length; i++) {
      if(stages.elementAt(i).stage == completedStage.stage) return i;
    }
    return 0;
  }

  @override
  int get hashCode => stage.hashCode ^ imageLocation.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'stage' : stage,
      'imageLocation' : imageLocation,
    };
  }

  static JobStage fromMap(Map<String, dynamic> map) {
    return JobStage(
      id: map['id'],
      stage: map['stage'],
      imageLocation: map['imageLocation'],
    );
  }

  JobStage({this.id, this.stage, this.imageLocation});

  int id;
  String stage;
  String imageLocation;

  AssetImage getStageImage() {
    String imageLocation = 'assets/images/job_progress/inquiry_received.png';
    switch(stage) {
      case STAGE_1_INQUIRY_RECEIVED:
        imageLocation = 'assets/images/job_progress/inquiry_received.png';
        break;
      case STAGE_2_FOLLOWUP_SENT:
        imageLocation = 'assets/images/job_progress/followup_sent.png';
        break;
      case STAGE_3_PROPOSAL_SENT:
        imageLocation = 'assets/images/job_progress/proposal_sent.png';
        break;
      case STAGE_4_PROPOSAL_SIGNED:
        imageLocation = 'assets/images/job_progress/proposal_signed.png';
        break;
      case STAGE_5_DEPOSIT_RECEIVED:
        imageLocation = 'assets/images/job_progress/deposit_received.png';
        break;
      case STAGE_6_PLANNING_COMPLETE:
        imageLocation = 'assets/images/job_progress/planning_complete.png';
        break;
      case STAGE_7_SESSION_COMPLETE:
        imageLocation = 'assets/images/job_progress/session_complete.png';
        break;
      case STAGE_8_PAYMENT_REQUESTED:
        imageLocation = 'assets/images/job_progress/payment_requested.png';
        break;
      case STAGE_9_PAYMENT_RECEIVED:
        imageLocation = 'assets/images/job_progress/payment_received.png';
        break;
      case STAGE_10_EDITING_COMPLETE:
        imageLocation = 'assets/images/job_progress/editing_complete.png';
        break;
      case STAGE_11_GALLERY_SENT:
        imageLocation = 'assets/images/job_progress/gallery_sent.png';
        break;
      case STAGE_12_FEEDBACK_REQUESTED:
        imageLocation = 'assets/images/job_progress/feedback_requested.png';
        break;
      case STAGE_13_FEEDBACK_RECEIVED:
        imageLocation = 'assets/images/job_progress/feedback_received.png';
        break;
      case STAGE_14_JOB_COMPLETE:
        imageLocation = 'assets/images/job_progress/job_complete.png';
        break;
      case STAGE_COMPLETED_CHECK:
        imageLocation = 'assets/images/job_progress/job_complete.png';
        break;
    }
    return AssetImage(imageLocation);
  }

  AssetImage getNextStageImage() {
    String imageLocation = 'assets/images/job_progress/inquiry_received.png';
    switch(stage) {
      case STAGE_1_INQUIRY_RECEIVED:
        imageLocation = 'assets/images/job_progress/followup_sent.png';
        break;
      case STAGE_2_FOLLOWUP_SENT:
        imageLocation = 'assets/images/job_progress/proposal_sent.png';
        break;
      case STAGE_3_PROPOSAL_SENT:
        imageLocation = 'assets/images/job_progress/proposal_signed.png';
        break;
      case STAGE_4_PROPOSAL_SIGNED:
        imageLocation = 'assets/images/job_progress/deposit_received.png';
        break;
      case STAGE_5_DEPOSIT_RECEIVED:
        imageLocation = 'assets/images/job_progress/planning_complete.png';
        break;
      case STAGE_6_PLANNING_COMPLETE:
        imageLocation = 'assets/images/job_progress/session_complete.png';
        break;
      case STAGE_7_SESSION_COMPLETE:
        imageLocation = 'assets/images/job_progress/payment_requested.png';
        break;
      case STAGE_8_PAYMENT_REQUESTED:
        imageLocation = 'assets/images/job_progress/payment_received.png';
        break;
      case STAGE_9_PAYMENT_RECEIVED:
        imageLocation = 'assets/images/job_progress/editing_complete.png';
        break;
      case STAGE_10_EDITING_COMPLETE:
        imageLocation = 'assets/images/job_progress/gallery_sent.png';
        break;
      case STAGE_11_GALLERY_SENT:
        imageLocation = 'assets/images/job_progress/feedback_requested.png';
        break;
      case STAGE_12_FEEDBACK_REQUESTED:
        imageLocation = 'assets/images/job_progress/feedback_received.png';
        break;
      case STAGE_13_FEEDBACK_RECEIVED:
        imageLocation = 'assets/images/job_progress/job_complete.png';
        break;
      case STAGE_14_JOB_COMPLETE:
        imageLocation = 'assets/images/job_progress/job_complete.png';
        break;
      case STAGE_COMPLETED_CHECK:
        imageLocation = 'assets/images/job_progress/job_complete.png';
        break;
    }
    return AssetImage(imageLocation);
  }

  static AssetImage getStageImageStatic(String stage) {
    String imageLocation = 'assets/images/job_progress/inquiry_received.png';
    switch(stage) {
      case STAGE_1_INQUIRY_RECEIVED:
        imageLocation = 'assets/images/job_progress/inquiry_received.png';
        break;
      case STAGE_2_FOLLOWUP_SENT:
        imageLocation = 'assets/images/job_progress/followup_sent.png';
        break;
      case STAGE_3_PROPOSAL_SENT:
        imageLocation = 'assets/images/job_progress/proposal_sent.png';
        break;
      case STAGE_4_PROPOSAL_SIGNED:
        imageLocation = 'assets/images/job_progress/proposal_signed.png';
        break;
      case STAGE_5_DEPOSIT_RECEIVED:
        imageLocation = 'assets/images/job_progress/deposit_received.png';
        break;
      case STAGE_6_PLANNING_COMPLETE:
        imageLocation = 'assets/images/job_progress/planning_complete.png';
        break;
      case STAGE_7_SESSION_COMPLETE:
        imageLocation = 'assets/images/job_progress/session_complete.png';
        break;
      case STAGE_8_PAYMENT_REQUESTED:
        imageLocation = 'assets/images/job_progress/payment_requested.png';
        break;
      case STAGE_9_PAYMENT_RECEIVED:
        imageLocation = 'assets/images/job_progress/payment_received.png';
        break;
      case STAGE_10_EDITING_COMPLETE:
        imageLocation = 'assets/images/job_progress/editing_complete.png';
        break;
      case STAGE_11_GALLERY_SENT:
        imageLocation = 'assets/images/job_progress/gallery_sent.png';
        break;
      case STAGE_12_FEEDBACK_REQUESTED:
        imageLocation = 'assets/images/job_progress/feedback_requested.png';
        break;
      case STAGE_13_FEEDBACK_RECEIVED:
        imageLocation = 'assets/images/job_progress/feedback_received.png';
        break;
      case STAGE_14_JOB_COMPLETE:
        imageLocation = 'assets/images/job_progress/job_complete.png';
        break;
      case STAGE_COMPLETED_CHECK:
        imageLocation = 'assets/images/job_progress/job_complete.png';
        break;
    }
    return AssetImage(imageLocation);
  }

  static String getImageLocation(String stage) {
    String imageLocation = 'assets/images/job_progress/inquiry_received.png';
    switch(stage) {
      case STAGE_1_INQUIRY_RECEIVED:
        imageLocation = 'assets/images/job_progress/inquiry_received.png';
        break;
      case STAGE_2_FOLLOWUP_SENT:
        imageLocation = 'assets/images/job_progress/followup_sent.png';
        break;
      case STAGE_3_PROPOSAL_SENT:
        imageLocation = 'assets/images/job_progress/proposal_sent.png';
        break;
      case STAGE_4_PROPOSAL_SIGNED:
        imageLocation = 'assets/images/job_progress/proposal_signed.png';
        break;
      case STAGE_5_DEPOSIT_RECEIVED:
        imageLocation = 'assets/images/job_progress/deposit_received.png';
        break;
      case STAGE_6_PLANNING_COMPLETE:
        imageLocation = 'assets/images/job_progress/planning_complete.png';
        break;
      case STAGE_7_SESSION_COMPLETE:
        imageLocation = 'assets/images/job_progress/session_complete.png';
        break;
      case STAGE_8_PAYMENT_REQUESTED:
        imageLocation = 'assets/images/job_progress/payment_requested.png';
        break;
      case STAGE_9_PAYMENT_RECEIVED:
        imageLocation = 'assets/images/job_progress/payment_received.png';
        break;
      case STAGE_10_EDITING_COMPLETE:
        imageLocation = 'assets/images/job_progress/editing_complete.png';
        break;
      case STAGE_11_GALLERY_SENT:
        imageLocation = 'assets/images/job_progress/gallery_sent.png';
        break;
      case STAGE_12_FEEDBACK_REQUESTED:
        imageLocation = 'assets/images/job_progress/feedback_requested.png';
        break;
      case STAGE_13_FEEDBACK_RECEIVED:
        imageLocation = 'assets/images/job_progress/feedback_received.png';
        break;
      case STAGE_14_JOB_COMPLETE:
        imageLocation = 'assets/images/job_progress/job_complete.png';
        break;
    }
    return imageLocation;
  }

  static int getIndexOfCurrentStage(String stage, List<JobStage> stages){
    int currentStageIndex = 0;
    for(int i=0; i < stages.length; i++) {
      if(stages.elementAt(i).stage == stage){
        currentStageIndex = i;
      }
    }
    if(stage == JobStage.STAGE_COMPLETED_CHECK) return stages.length;
    return currentStageIndex;
  }

  static String getStageFromValue(int value){
    switch(value) {
      case 1:
        return STAGE_1_INQUIRY_RECEIVED;
        break;
      case 2:
        return STAGE_2_FOLLOWUP_SENT;
        break;
      case 3:
        return STAGE_3_PROPOSAL_SENT;
        break;
      case 4:
        return STAGE_4_PROPOSAL_SIGNED;
        break;
      case 5:
        return STAGE_5_DEPOSIT_RECEIVED;
        break;
      case 6:
        return STAGE_6_PLANNING_COMPLETE;
        break;
      case 7:
        return STAGE_7_SESSION_COMPLETE;
        break;
      case 8:
        return STAGE_8_PAYMENT_REQUESTED;
        break;
      case 9:
        return STAGE_9_PAYMENT_RECEIVED;
        break;
      case 10:
        return STAGE_10_EDITING_COMPLETE;
        break;
      case 11:
        return STAGE_11_GALLERY_SENT;
        break;
      case 12:
        return STAGE_12_FEEDBACK_REQUESTED;
        break;
      case 13:
        return STAGE_13_FEEDBACK_RECEIVED;
        break;
      case 14:
        return STAGE_14_JOB_COMPLETE;
        break;
      case 15:
        return STAGE_COMPLETED_CHECK;
        break;
    }
    return STAGE_1_INQUIRY_RECEIVED;
  }

  static bool containsJobStageIcon(List<JobStage> selectedStages, String jobIcon){
    for(JobStage selectedStage in selectedStages) {
      if(selectedStage.stage == getStageFromIcon(jobIcon)) return true;
    }
    return false;
  }

  static String getStageFromIcon(String iconLocation) {
    switch(iconLocation){
      case 'assets/images/job_progress/inquiry_received.png':
        return STAGE_1_INQUIRY_RECEIVED;
      case 'assets/images/job_progress/followup_sent.png':
        return STAGE_2_FOLLOWUP_SENT;
      case 'assets/images/job_progress/proposal_sent.png':
        return STAGE_3_PROPOSAL_SENT;
      case 'assets/images/job_progress/proposal_signed.png':
        return STAGE_4_PROPOSAL_SIGNED;
      case 'assets/images/job_progress/deposit_received.png':
        return STAGE_5_DEPOSIT_RECEIVED;
      case 'assets/images/job_progress/planning_complete.png':
        return STAGE_6_PLANNING_COMPLETE;
      case 'assets/images/job_progress/session_complete.png':
        return STAGE_7_SESSION_COMPLETE;
      case 'assets/images/job_progress/payment_requested.png':
        return STAGE_8_PAYMENT_REQUESTED;
      case 'assets/images/job_progress/payment_received.png':
        return STAGE_9_PAYMENT_RECEIVED;
      case 'assets/images/job_progress/editing_complete.png':
        return STAGE_10_EDITING_COMPLETE;
      case 'assets/images/job_progress/gallery_sent.png':
        return STAGE_11_GALLERY_SENT;
      case 'assets/images/job_progress/feedback_requested.png':
        return STAGE_12_FEEDBACK_REQUESTED;
      case 'assets/images/job_progress/feedback_received.png':
        return STAGE_13_FEEDBACK_RECEIVED;
      case 'assets/images/job_progreaa/job_complete.png':
        return STAGE_14_JOB_COMPLETE;
    }
    return '';
  }

  static String getStageText(JobStage stage) {
    switch(stage.stage){
      case STAGE_1_INQUIRY_RECEIVED:
        return 'Receive inquiry';
      case STAGE_2_FOLLOWUP_SENT:
        return 'Send followup';
      case STAGE_3_PROPOSAL_SENT:
        return 'Send contract';
      case STAGE_4_PROPOSAL_SIGNED:
        return 'Receive signed contract';
      case STAGE_5_DEPOSIT_RECEIVED:
        return 'Receive deposit';
      case STAGE_6_PLANNING_COMPLETE:
        return 'Complete planning';
      case STAGE_7_SESSION_COMPLETE:
        return 'Complete session';
      case STAGE_8_PAYMENT_REQUESTED:
        return 'Send invoice';
      case STAGE_9_PAYMENT_RECEIVED:
        return 'Receive payment';
      case STAGE_10_EDITING_COMPLETE:
        return 'Complete editing';
      case STAGE_11_GALLERY_SENT:
        return 'Send gallery';
      case STAGE_12_FEEDBACK_REQUESTED:
        return 'Request feedback';
      case STAGE_13_FEEDBACK_RECEIVED:
        return 'Receive feedback';
      case STAGE_14_JOB_COMPLETE:
        return 'Job complete';
    }
    return '';
  }

  static JobStage getNextStage(JobStage last) {
    switch(last.stage) {
      case STAGE_1_INQUIRY_RECEIVED:
        return JobStage(stage: STAGE_2_FOLLOWUP_SENT);
        break;
      case STAGE_2_FOLLOWUP_SENT:
        return JobStage(stage: STAGE_3_PROPOSAL_SENT);
        break;
      case STAGE_3_PROPOSAL_SENT:
        return JobStage(stage: STAGE_4_PROPOSAL_SIGNED);
        break;
      case STAGE_4_PROPOSAL_SIGNED:
        return JobStage(stage: STAGE_5_DEPOSIT_RECEIVED);
        break;
      case STAGE_5_DEPOSIT_RECEIVED:
        return JobStage(stage: STAGE_6_PLANNING_COMPLETE);
        break;
      case STAGE_6_PLANNING_COMPLETE:
        return JobStage(stage: STAGE_7_SESSION_COMPLETE);
        break;
      case STAGE_7_SESSION_COMPLETE:
        return JobStage(stage: STAGE_8_PAYMENT_REQUESTED);
        break;
      case STAGE_8_PAYMENT_REQUESTED:
        return JobStage(stage: STAGE_9_PAYMENT_RECEIVED);
        break;
      case STAGE_9_PAYMENT_RECEIVED:
        return JobStage(stage: STAGE_10_EDITING_COMPLETE);
        break;
      case STAGE_10_EDITING_COMPLETE:
        return JobStage(stage: STAGE_11_GALLERY_SENT);
        break;
      case STAGE_11_GALLERY_SENT:
        return JobStage(stage: STAGE_12_FEEDBACK_REQUESTED);
        break;
      case STAGE_12_FEEDBACK_REQUESTED:
        return JobStage(stage: STAGE_13_FEEDBACK_RECEIVED);
        break;
      case STAGE_13_FEEDBACK_RECEIVED:
        return JobStage(stage: STAGE_14_JOB_COMPLETE);
        break;
      case STAGE_14_JOB_COMPLETE:
        return JobStage(stage: STAGE_COMPLETED_CHECK);
        break;
    }
    return JobStage(stage: STAGE_1_INQUIRY_RECEIVED);
  }

  static JobStage getStageFromIndex(int stageIndex, List<JobStage> stages) {

    return JobStage(stage: STAGE_1_INQUIRY_RECEIVED);
  }

  static List<JobStage> AllStages() {
    List<JobStage> allStages = [];
    allStages.add(JobStage(id: 1, stage: STAGE_1_INQUIRY_RECEIVED, imageLocation: getImageLocation(STAGE_1_INQUIRY_RECEIVED)));
    allStages.add(JobStage(id: 2, stage: STAGE_2_FOLLOWUP_SENT, imageLocation: getImageLocation(STAGE_2_FOLLOWUP_SENT)));
    allStages.add(JobStage(id: 3, stage: STAGE_3_PROPOSAL_SENT, imageLocation: getImageLocation(STAGE_3_PROPOSAL_SENT)));
    allStages.add(JobStage(id: 4, stage: STAGE_4_PROPOSAL_SIGNED, imageLocation: getImageLocation(STAGE_4_PROPOSAL_SIGNED)));
    allStages.add(JobStage(id: 5, stage: STAGE_5_DEPOSIT_RECEIVED, imageLocation: getImageLocation(STAGE_5_DEPOSIT_RECEIVED)));
    allStages.add(JobStage(id: 6, stage: STAGE_6_PLANNING_COMPLETE, imageLocation: getImageLocation(STAGE_6_PLANNING_COMPLETE)));
    allStages.add(JobStage(id: 7, stage: STAGE_7_SESSION_COMPLETE, imageLocation: getImageLocation(STAGE_7_SESSION_COMPLETE)));
    allStages.add(JobStage(id: 8, stage: STAGE_8_PAYMENT_REQUESTED, imageLocation: getImageLocation(STAGE_8_PAYMENT_REQUESTED)));
    allStages.add(JobStage(id: 9, stage: STAGE_9_PAYMENT_RECEIVED, imageLocation: getImageLocation(STAGE_9_PAYMENT_RECEIVED)));
    allStages.add(JobStage(id: 10, stage: STAGE_10_EDITING_COMPLETE, imageLocation: getImageLocation(STAGE_10_EDITING_COMPLETE)));
    allStages.add(JobStage(id: 11, stage: STAGE_11_GALLERY_SENT, imageLocation: getImageLocation(STAGE_11_GALLERY_SENT)));
    allStages.add(JobStage(id: 12, stage: STAGE_12_FEEDBACK_REQUESTED, imageLocation: getImageLocation(STAGE_12_FEEDBACK_REQUESTED)));
    allStages.add(JobStage(id: 13, stage: STAGE_13_FEEDBACK_RECEIVED, imageLocation: getImageLocation(STAGE_13_FEEDBACK_RECEIVED)));
    allStages.add(JobStage(id: 14, stage: STAGE_14_JOB_COMPLETE, imageLocation: getImageLocation(STAGE_14_JOB_COMPLETE)));
    return allStages;
  }

  static List<JobStage> AllStagesForNewJobTypeSelection() {
    List<JobStage> allStages = [];
    allStages.add(JobStage(id: 2, stage: STAGE_2_FOLLOWUP_SENT, imageLocation: getImageLocation(STAGE_2_FOLLOWUP_SENT)));
    allStages.add(JobStage(id: 3, stage: STAGE_3_PROPOSAL_SENT, imageLocation: getImageLocation(STAGE_3_PROPOSAL_SENT)));
    allStages.add(JobStage(id: 4, stage: STAGE_4_PROPOSAL_SIGNED, imageLocation: getImageLocation(STAGE_4_PROPOSAL_SIGNED)));
    allStages.add(JobStage(id: 5, stage: STAGE_5_DEPOSIT_RECEIVED, imageLocation: getImageLocation(STAGE_5_DEPOSIT_RECEIVED)));
    allStages.add(JobStage(id: 6, stage: STAGE_6_PLANNING_COMPLETE, imageLocation: getImageLocation(STAGE_6_PLANNING_COMPLETE)));
    allStages.add(JobStage(id: 7, stage: STAGE_7_SESSION_COMPLETE, imageLocation: getImageLocation(STAGE_7_SESSION_COMPLETE)));
    allStages.add(JobStage(id: 8, stage: STAGE_8_PAYMENT_REQUESTED, imageLocation: getImageLocation(STAGE_8_PAYMENT_REQUESTED)));
    allStages.add(JobStage(id: 9, stage: STAGE_9_PAYMENT_RECEIVED, imageLocation: getImageLocation(STAGE_9_PAYMENT_RECEIVED)));
    allStages.add(JobStage(id: 10, stage: STAGE_10_EDITING_COMPLETE, imageLocation: getImageLocation(STAGE_10_EDITING_COMPLETE)));
    allStages.add(JobStage(id: 11, stage: STAGE_11_GALLERY_SENT, imageLocation: getImageLocation(STAGE_11_GALLERY_SENT)));
    allStages.add(JobStage(id: 12, stage: STAGE_12_FEEDBACK_REQUESTED, imageLocation: getImageLocation(STAGE_12_FEEDBACK_REQUESTED)));
    allStages.add(JobStage(id: 13, stage: STAGE_13_FEEDBACK_RECEIVED, imageLocation: getImageLocation(STAGE_13_FEEDBACK_RECEIVED)));
    return allStages;
  }
}