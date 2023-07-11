import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';

import 'JobType.dart';
import 'Pose.dart';

class Job {

  int id;
  String documentId;
  String clientDocumentId;
  String deviceEventId;
  String clientName;
  String jobTitle;
  PriceProfile priceProfile;
  Location location;
  String notes;
  DateTime paymentReceivedDate;
  DateTime depositReceivedDate;
  DateTime selectedDate;
  DateTime selectedTime;
  DateTime selectedEndTime;
  DateTime createdDate;
  JobType type;
  JobStage stage;
  Client client;
  Invoice invoice;
  int depositAmount = 0;
  double addOnCost;
  int tipAmount = 0;
  List<JobStage> completedStages;
  List<Pose> poses;

  Job({
    this.id,
    this.documentId,
    this.clientDocumentId,
    this.deviceEventId,
    this.clientName,
    this.jobTitle,
    this.notes,
    this.selectedDate,
    this.selectedTime,
    this.selectedEndTime,
    this.type,
    this.stage,
    this.completedStages,
    this.location,
    this.priceProfile,
    this.invoice,
    this.depositAmount,
    this.createdDate,
    this.tipAmount,
    this.paymentReceivedDate,
    this.depositReceivedDate,
    this.addOnCost,
    this.poses,
    this.client,
  });

  Job copyWith({
    int id,
    String documentId,
    int clientId,
    String deviceEventId,
    String clientName,
    String jobTitle,
    PriceProfile priceProfile,
    Location location,
    String notes,
    DateTime selectedDate,
    DateTime selectedTime,
    DateTime selectedEndTime,
    JobType type,
    JobStage stage,
    Invoice invoice,
    int depositAmount,
    int tipAmount = 0,
    List<JobStage> completedStages,
    DateTime createdDate,
    DateTime paymentReceivedDate,
    DateTime depositReceivedDate,
    double addOnCost,
    List<Pose> poses,
    Client client,
  }){
    return Job(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      clientDocumentId: clientId ?? this.clientDocumentId,
      deviceEventId: deviceEventId ?? this.deviceEventId,
      clientName: clientName ?? this.clientName,
      jobTitle: jobTitle ?? this.jobTitle,
      priceProfile: priceProfile ?? this.priceProfile,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedEndTime: selectedEndTime ?? this.selectedEndTime,
      paymentReceivedDate: paymentReceivedDate ?? this.paymentReceivedDate,
      type: type ?? this.type,
      stage: stage ?? this.stage,
      invoice: invoice ?? this.invoice,
      depositAmount: depositAmount ?? this.depositAmount,
      tipAmount: tipAmount ?? this.tipAmount,
      completedStages: completedStages ?? this.completedStages,
      createdDate: createdDate ?? this.createdDate,
      depositReceivedDate: depositReceivedDate ?? this.depositReceivedDate,
      addOnCost: addOnCost ?? this.addOnCost,
      poses: poses ?? this.poses,
      client: client ?? this.client,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'clientDocumentId': clientDocumentId,
      'deviceEventId' : deviceEventId,
      'clientName' : clientName,
      'jobTitle' : jobTitle,
      'notes' : notes,
      'depositReceivedDate' : depositReceivedDate?.toString() ?? "",
      'selectedDate' : selectedDate?.toString() ?? "",
      'selectedTime' : selectedTime?.toString() ?? "",
      'selectedEndTime' : selectedEndTime?.toString() ?? "",
      'createdDate' : createdDate?.toString() ?? "",
      'paymentReceivedDate' : paymentReceivedDate?.toString() ?? "",
      'type' : type?.toMap() ?? null,
      'stage' : stage?.toMap() ?? null,
      'location' : location?.toMap() ?? null,
      'priceProfile' : priceProfile?.toMap() ?? null,
      'client' : client?.toMap() ?? null,
      'invoice' : invoice?.toMap() ?? null,
      'completedStages' : convertCompletedStagesToMap(completedStages),
      'poses' : convertPosesToMap(poses),
      'depositAmount' : depositAmount,
      'tipAmount' : tipAmount,
      'addOnCost' : addOnCost,
    };
  }

  static Job fromMap(Map<String, dynamic> map) {
    return Job(
      documentId: map['documentId'],
      clientDocumentId: map['clientDocumentId'],
      deviceEventId: map['deviceEventId'],
      clientName: map['clientName'],
      jobTitle: map['jobTitle'],
      notes: map['notes'],
      addOnCost: map['addOnCost'],
      depositReceivedDate: map['depositReceivedDate'] != null && map['depositReceivedDate'] != "" ? DateTime.parse(map['depositReceivedDate']) : null,
      selectedDate: map['selectedDate'] != ""? DateTime.parse(map['selectedDate']) : null,
      selectedTime: map['selectedTime'] != "" ? DateTime.parse(map['selectedTime']) : null,
      createdDate: map['createdDate'] != "" ? DateTime.parse(map['createdDate']) : null,
      selectedEndTime: map['selectedEndTime'] != null && map['selectedEndTime'] != "" ? DateTime.parse(map['selectedEndTime']) : null,
      paymentReceivedDate: map['paymentReceivedDate'] != null && map['paymentReceivedDate'] != "" ? DateTime.parse(map['paymentReceivedDate']) : null,
      type: JobType.fromMap(map['type']),
      stage: JobStage.fromMap(map['stage']),
      client: map['client'] != null ? Client.fromMap(map['client']) : null,
      location: map['location'] != null ? Location.fromMap(map['location']) : null,
      priceProfile: map['priceProfile'] != null ? PriceProfile.fromMap(map['priceProfile']) : null,
      invoice: map['invoice'] != null ? Invoice.fromMap(map['invoice']) : null,
      completedStages: convertMapsToJobStages(map['completedStages']),
      poses: convertMapsToPoses(map['poses']),
      depositAmount: map['depositAmount'],
      tipAmount: map['tipAmount'],
    );
  }

  List<Map<String, dynamic>> convertCompletedStagesToMap(List<JobStage> completedStages){
    List<Map<String, dynamic>> listOfMaps = [];
    for(JobStage jobStage in completedStages){
      listOfMaps.add(jobStage.toMap());
    }
    return listOfMaps;
  }

  static List<JobStage> convertMapsToJobStages(List listOfMaps){
    List<JobStage> listOfJobStages = [];
    for(Map map in listOfMaps){
      listOfJobStages.add(JobStage.fromMap(map));
    }
    return listOfJobStages;
  }

  List<Map<String, dynamic>> convertPosesToMap(List<Pose> poses){
    List<Map<String, dynamic>> listOfMaps = [];
    if(poses != null) {
      for(Pose pose in poses){
        listOfMaps.add(pose.toMap());
      }
    }
    return listOfMaps;
  }

  static List<Pose> convertMapsToPoses(List listOfMaps){
    List<Pose> poses = [];
    if(listOfMaps != null) {
      for(Map map in listOfMaps){
        poses.add(Pose.fromMap(map));
      }
    }
    return poses;
  }

  bool isDepositPaid () {
    bool isDepositPaid = false;
    for(JobStage jobStage in completedStages){
      if(jobStage.stage == JobStage.STAGE_5_DEPOSIT_RECEIVED) isDepositPaid = true;
    }
    return isDepositPaid;
  }

  static int getJobStagePosition(String stage){
    switch(stage) {
      case JobStage.STAGE_1_INQUIRY_RECEIVED:
        return 1;
      case JobStage.STAGE_2_FOLLOWUP_SENT:
        return 2;
      case JobStage.STAGE_3_PROPOSAL_SENT:
        return 3;
      case JobStage.STAGE_4_PROPOSAL_SIGNED:
        return 4;
      case JobStage.STAGE_5_DEPOSIT_RECEIVED:
        return 5;
      case JobStage.STAGE_6_PLANNING_COMPLETE:
        return 6;
      case JobStage.STAGE_7_SESSION_COMPLETE:
        return 7;
      case JobStage.STAGE_8_PAYMENT_REQUESTED:
        return 8;
      case JobStage.STAGE_9_PAYMENT_RECEIVED:
        return 9;
      case JobStage.STAGE_10_EDITING_COMPLETE:
        return 10;
      case JobStage.STAGE_11_GALLERY_SENT:
        return 11;
      case JobStage.STAGE_12_FEEDBACK_REQUESTED:
        return 12;
      case JobStage.STAGE_13_FEEDBACK_RECEIVED:
        return 13;
      case JobStage.STAGE_14_JOB_COMPLETE:
        return 14;
    }
    return 1;
  }

  bool hasCompletedStage(String jobStage) {
    for(JobStage completedStage in completedStages){
      if(completedStage.stage == jobStage) return true;
    }
    return false;
  }

  bool isPaymentReceived() {
    for(JobStage completedStage in completedStages){
      if(completedStage.stage == JobStage.STAGE_9_PAYMENT_RECEIVED || completedStage.stage == JobStage.STAGE_14_JOB_COMPLETE || completedStage.stage == JobStage.STAGE_COMPLETED_CHECK) return true;
    }
    return false;
  }

  double getJobCost() {
    return (priceProfile != null && priceProfile.flatRate != null ? priceProfile.flatRate : 0) + (this.addOnCost != null ? this.addOnCost : 0);
  }

  static bool containsStage(List<JobStage> completedStages, String stageConstant) {
    bool contains = false;
    for(JobStage stage in completedStages){
      if(stage.stage == stageConstant){
        contains = true;
      }
    }
    return contains;
  }

  int getStageIndex(String stageToMatch) {
    for(int i = 0; i < type.stages.length; i++) {
      if(type.stages.elementAt(i).stage == stageToMatch) {
        return i;
      }
    }
    return 0;
  }

  static JobStage getNextUncompletedStage(List<JobStage> completedStages, List<JobStage> stages, Job job) {
    int indexOfHighestCompleted = 0;
    for(JobStage completedStage in completedStages) {
      int index = job.getStageIndex(completedStage.stage);
      if(index > indexOfHighestCompleted) {
        indexOfHighestCompleted = index;
      }
    }

    if(indexOfHighestCompleted < stages.length-1) {
      return stages.elementAt(indexOfHighestCompleted + 1);
    } else {
      return stages.elementAt(indexOfHighestCompleted);
    }
  }
}