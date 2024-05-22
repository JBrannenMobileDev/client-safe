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
      if(stages.elementAt(i).stage == completedStage.stage) {
        return i;
      }
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

  int? id;
  String? stage;
  String? imageLocation;

  Image getCompletedImage(Color color) {
    return Image.asset(
      'assets/images/icons/complete.png',
      color: color,
    );
  }

  static Image getContractImage(bool signed, Color color) {
    if(signed) {
      return Image.asset('assets/images/icons/contract_signed.png', color: color);
    } else {
      return Image.asset('assets/images/icons/contract.png', color: color);
    }
  }

  Image getStageImage(Color color) {
    String imageLocation = 'assets/images/icons/sms.png';
    switch(stage) {
      case STAGE_1_INQUIRY_RECEIVED:
        imageLocation = 'assets/images/icons/sms.png';
        break;
      case STAGE_2_FOLLOWUP_SENT:
        imageLocation = 'assets/images/icons/chat.png';
        break;
      case STAGE_3_PROPOSAL_SENT:
        imageLocation = 'assets/images/icons/contract.png';
        break;
      case STAGE_4_PROPOSAL_SIGNED:
        imageLocation = 'assets/images/icons/contract_signed.png';
        break;
      case STAGE_5_DEPOSIT_RECEIVED:
        imageLocation = 'assets/images/icons/income_received.png';
        break;
      case STAGE_6_PLANNING_COMPLETE:
        imageLocation = 'assets/images/icons/planning.png';
        break;
      case STAGE_7_SESSION_COMPLETE:
        imageLocation = 'assets/images/icons/camera.png';
        break;
      case STAGE_8_PAYMENT_REQUESTED:
        imageLocation = 'assets/images/icons/invoice.png';
        break;
      case STAGE_9_PAYMENT_RECEIVED:
        imageLocation = 'assets/images/icons/income_received.png';
        break;
      case STAGE_10_EDITING_COMPLETE:
        imageLocation = 'assets/images/icons/computer.png';
        break;
      case STAGE_11_GALLERY_SENT:
        imageLocation = 'assets/images/icons/photo.png';
        break;
      case STAGE_12_FEEDBACK_REQUESTED:
        imageLocation = 'assets/images/icons/feedback_requested.png';
        break;
      case STAGE_13_FEEDBACK_RECEIVED:
        imageLocation = 'assets/images/icons/feedback_received.png';
        break;
      case STAGE_14_JOB_COMPLETE:
        imageLocation = 'assets/images/icons/complete.png';
        break;
      case STAGE_COMPLETED_CHECK:
        imageLocation = 'assets/images/icons/complete.png';
        break;
    }
    return Image.asset(imageLocation, color: color);
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
        imageLocation = 'assets/images/icons/sms.png';
        break;
      case STAGE_2_FOLLOWUP_SENT:
        imageLocation = 'assets/images/icons/chat.png';
        break;
      case STAGE_3_PROPOSAL_SENT:
        imageLocation = 'assets/images/icons/contract.png';
        break;
      case STAGE_4_PROPOSAL_SIGNED:
        imageLocation = 'assets/images/icons/contract_signed.png';
        break;
      case STAGE_5_DEPOSIT_RECEIVED:
        imageLocation = 'assets/images/icons/income_received.png';
        break;
      case STAGE_6_PLANNING_COMPLETE:
        imageLocation = 'assets/images/icons/planning.png';
        break;
      case STAGE_7_SESSION_COMPLETE:
        imageLocation = 'assets/images/icons/camera.png';
        break;
      case STAGE_8_PAYMENT_REQUESTED:
        imageLocation = 'assets/images/icons/invoice.png';
        break;
      case STAGE_9_PAYMENT_RECEIVED:
        imageLocation = 'assets/images/icons/income_received.png';
        break;
      case STAGE_10_EDITING_COMPLETE:
        imageLocation = 'assets/images/icons/computer.png';
        break;
      case STAGE_11_GALLERY_SENT:
        imageLocation = 'assets/images/icons/photo.png';
        break;
      case STAGE_12_FEEDBACK_REQUESTED:
        imageLocation = 'assets/images/icons/feedback_requested.png';
        break;
      case STAGE_13_FEEDBACK_RECEIVED:
        imageLocation = 'assets/images/icons/feedback_received.png';
        break;
      case STAGE_14_JOB_COMPLETE:
        imageLocation = 'assets/images/icons/complete.png';
        break;
      case STAGE_COMPLETED_CHECK:
        imageLocation = 'assets/images/icons/complete.png';
        break;
    }
    return AssetImage(imageLocation);
  }

  static String getImageLocation(String stage) {
    String imageLocation = 'assets/images/job_progress/inquiry_received.png';
    switch(stage) {
      case STAGE_1_INQUIRY_RECEIVED:
        imageLocation = 'assets/images/icons/sms.png';
        break;
      case STAGE_2_FOLLOWUP_SENT:
        imageLocation = 'assets/images/icons/chat.png';
        break;
      case STAGE_3_PROPOSAL_SENT:
        imageLocation = 'assets/images/icons/contract.png';
        break;
      case STAGE_4_PROPOSAL_SIGNED:
        imageLocation = 'assets/images/icons/contract_signed.png';
        break;
      case STAGE_5_DEPOSIT_RECEIVED:
        imageLocation = 'assets/images/icons/income_received.png';
        break;
      case STAGE_6_PLANNING_COMPLETE:
        imageLocation = 'assets/images/icons/planning.png';
        break;
      case STAGE_7_SESSION_COMPLETE:
        imageLocation = 'assets/images/icons/camera.png';
        break;
      case STAGE_8_PAYMENT_REQUESTED:
        imageLocation = 'assets/images/icons/invoice.png';
        break;
      case STAGE_9_PAYMENT_RECEIVED:
        imageLocation = 'assets/images/icons/income_received.png';
        break;
      case STAGE_10_EDITING_COMPLETE:
        imageLocation = 'assets/images/icons/computer.png';
        break;
      case STAGE_11_GALLERY_SENT:
        imageLocation = 'assets/images/icons/photo.png';
        break;
      case STAGE_12_FEEDBACK_REQUESTED:
        imageLocation = 'assets/images/icons/feedback_requested.png';
        break;
      case STAGE_13_FEEDBACK_RECEIVED:
        imageLocation = 'assets/images/icons/feedback_received.png';
        break;
      case STAGE_14_JOB_COMPLETE:
        imageLocation = 'assets/images/icons/complete.png';
        break;
      case STAGE_COMPLETED_CHECK:
        imageLocation = 'assets/images/icons/complete.png';
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
        return 'Complete Job';
    }
    return '';
  }

  static JobStage getNextStage(JobStage currentStage, List<JobStage> stages) {
    JobStage nextStage = currentStage;
    if(currentStage.stage != JobStage.STAGE_14_JOB_COMPLETE) {
      for(int i=0; i< stages.length; i++) {
        if(stages.elementAt(i).stage == currentStage.stage) {
          nextStage = stages.elementAt((i + 1));
        }
      }
    }
    return nextStage;
  }

  static JobStage getStageFromIndex(int stageIndex, List<JobStage> stages) {
    return stages.elementAt(stageIndex);
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

  static List<JobStage> exampleJobStages() {
    List<JobStage> allStages = [];
    allStages.add(JobStage(id: 1, stage: STAGE_1_INQUIRY_RECEIVED, imageLocation: getImageLocation(STAGE_1_INQUIRY_RECEIVED)));
    allStages.add(JobStage(id: 2, stage: STAGE_2_FOLLOWUP_SENT, imageLocation: getImageLocation(STAGE_2_FOLLOWUP_SENT)));
    allStages.add(JobStage(id: 3, stage: STAGE_3_PROPOSAL_SENT, imageLocation: getImageLocation(STAGE_3_PROPOSAL_SENT)));
    allStages.add(JobStage(id: 4, stage: STAGE_4_PROPOSAL_SIGNED, imageLocation: getImageLocation(STAGE_4_PROPOSAL_SIGNED)));
    allStages.add(JobStage(id: 6, stage: STAGE_6_PLANNING_COMPLETE, imageLocation: getImageLocation(STAGE_6_PLANNING_COMPLETE)));
    allStages.add(JobStage(id: 7, stage: STAGE_7_SESSION_COMPLETE, imageLocation: getImageLocation(STAGE_7_SESSION_COMPLETE)));
    allStages.add(JobStage(id: 8, stage: STAGE_8_PAYMENT_REQUESTED, imageLocation: getImageLocation(STAGE_8_PAYMENT_REQUESTED)));
    allStages.add(JobStage(id: 9, stage: STAGE_9_PAYMENT_RECEIVED, imageLocation: getImageLocation(STAGE_9_PAYMENT_RECEIVED)));
    allStages.add(JobStage(id: 10, stage: STAGE_10_EDITING_COMPLETE, imageLocation: getImageLocation(STAGE_10_EDITING_COMPLETE)));
    allStages.add(JobStage(id: 11, stage: STAGE_11_GALLERY_SENT, imageLocation: getImageLocation(STAGE_11_GALLERY_SENT)));
    allStages.add(JobStage(id: 14, stage: STAGE_14_JOB_COMPLETE, imageLocation: getImageLocation(STAGE_14_JOB_COMPLETE)));
    return allStages;
  }
}