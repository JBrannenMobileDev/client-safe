import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PriceProfile.dart';

import 'JobType.dart';
import 'Pose.dart';
import 'Proposal.dart';
import 'SessionType.dart';

class Job {
  static const String DETAIL_CLIENT_NAME = "[Client Name]";
  static const String DETAIL_CLIENT_EMAIL = "[Client Email]";
  static const String DETAIL_CLIENT_PHONE = "[Client Phone]";
  static const String DETAIL_PHOTOGRAPHER_NAME = "[Photographer Name]";
  static const String DETAIL_PHOTOGRAPHER_EMAIL = "[Photographer Email]";
  static const String DETAIL_PHOTOGRAPHER_PHONE = "[Photographer Phone]";
  static const String DETAIL_BUSINESS_NAME = '[Photographer Business Name]';
  static const String DETAIL_LOCATION_ADDRESS = "[Location Address]";
  static const String DETAIL_SESSION_DATE = "[Session Date]";
  static const String DETAIL_RETAINER_PRICE = "[Retainer]";
  static const String DETAIL_RETAINER_DUE_DATE = "[Retainer Due Date]";
  static const String DETAIL_REMAINING_BALANCE = "[Remaining Balance]";
  static const String DETAIL_TOTAL_DUE_DATE = "[Total Due Date]";
  static const String DETAIL_EFFECTIVE_DATE = "[Effective Date]";
  static const String DETAIL_START_TIME = "[Start Time]";
  static const String DETAIL_END_TIME = "[End Time]";
  static const String DETAIL_TOTAL = "[Total]";

  static String getDetailDisplayName(String detailConstant) {
    String result = '';
    switch(detailConstant) {
      case DETAIL_CLIENT_NAME:
        result = 'Client Name';
        break;
      case DETAIL_CLIENT_EMAIL:
        result = 'Client Email';
        break;
      case DETAIL_CLIENT_PHONE:
        result = 'Client Phone';
        break;
      case DETAIL_PHOTOGRAPHER_NAME:
        result = 'Photographer Name';
        break;
      case DETAIL_BUSINESS_NAME:
        result = 'Photographer Business Name';
        break;
      case DETAIL_LOCATION_ADDRESS:
        result = 'Location Address';
        break;
      case DETAIL_SESSION_DATE:
        result = 'Session Date';
        break;
      case DETAIL_RETAINER_PRICE:
        result = 'Retainer Price';
        break;
      case DETAIL_RETAINER_DUE_DATE:
        result = 'Retainer Due Date';
        break;
      case DETAIL_TOTAL:
        result = 'Total';
        break;
      case DETAIL_TOTAL_DUE_DATE:
        result = 'Total Due Date';
        break;
    }
    return result;
  }

  int? id;
  String? documentId;
  String? clientDocumentId;
  String? deviceEventId;
  String? clientName;
  String? jobTitle;
  PriceProfile? priceProfile;
  LocationDandy? location;
  String? notes;
  DateTime? paymentReceivedDate;
  DateTime? depositReceivedDate;
  DateTime? selectedDate;
  DateTime? selectedTime;
  DateTime? selectedEndTime;
  DateTime? createdDate;
  SessionType? sessionType;
  JobType? type;
  JobStage? stage;
  Client? client;
  Invoice? invoice;
  int? depositAmount = 0;
  double? addOnCost;
  int? tipAmount = 0;
  List<JobStage>? completedStages;
  List<Pose>? poses;
  Proposal? proposal;
  bool? hasAddedMileageTrip;
  bool? shouldTrackMiles = true;

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
    this.sessionType,
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
    this.proposal,
    this.hasAddedMileageTrip,
    this.shouldTrackMiles,
  });

  Job copyWith({
    int? id,
    String? documentId,
    String? clientDocumentId,
    String? deviceEventId,
    String? clientName,
    String? jobTitle,
    PriceProfile? priceProfile,
    LocationDandy? location,
    String? notes,
    DateTime? selectedDate,
    DateTime? selectedTime,
    DateTime? selectedEndTime,
    JobType? type,
    SessionType? sessionType,
    JobStage? stage,
    Invoice? invoice,
    int? depositAmount,
    int? tipAmount = 0,
    List<JobStage>? completedStages,
    DateTime? createdDate,
    DateTime? paymentReceivedDate,
    DateTime? depositReceivedDate,
    double? addOnCost,
    List<Pose>? poses,
    Client? client,
    Proposal? proposal,
    bool? hasAddedMileageTrip,
    bool? shouldTrackMiles,
  }){
    return Job(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      clientDocumentId: clientDocumentId ?? this.clientDocumentId,
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
      sessionType: sessionType ?? this.sessionType,
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
      proposal: proposal ?? this.proposal,
      hasAddedMileageTrip: hasAddedMileageTrip ?? this.hasAddedMileageTrip,
      shouldTrackMiles: shouldTrackMiles ?? this.shouldTrackMiles,
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
      'sessionType' : sessionType?.toMap(),
      'stage' : stage?.toMap(),
      'type' : type?.toMap(),
      'location' : location?.toMap(),
      'priceProfile' : priceProfile?.toMap(),
      'client' : client?.toMap(),
      'invoice' : invoice?.toMap(),
      'completedStages' : convertCompletedStagesToMap(completedStages),
      'poses' : convertPosesToMap(poses),
      'depositAmount' : depositAmount,
      'tipAmount' : tipAmount,
      'addOnCost' : addOnCost,
      'proposal' : proposal?.toMap(),
      'hasAddedMileageTrip' : hasAddedMileageTrip,
      'shouldTrackMiles' : shouldTrackMiles,
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
      hasAddedMileageTrip: map['hasAddedMileageTrip'] != null ? map['hasAddedMileageTrip'] : false,
      shouldTrackMiles: map['shouldTrackMiles'] != null ? map['shouldTrackMiles'] : false,
      addOnCost: map['addOnCost']?.toDouble(),
      depositReceivedDate: map['depositReceivedDate'] != null && map['depositReceivedDate'] != "" ? DateTime.parse(map['depositReceivedDate']) : null,
      selectedDate: map['selectedDate'] != "" && map['selectedDate'] != null ? DateTime.parse(map['selectedDate']) : null,
      selectedTime: map['selectedTime'] != "" && map['selectedTime'] != null ? DateTime.parse(map['selectedTime']) : null,
      createdDate: map['createdDate'] != "" && map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      selectedEndTime: map['selectedEndTime'] != null && map['selectedEndTime'] != "" ? DateTime.parse(map['selectedEndTime']) : null,
      paymentReceivedDate: map['paymentReceivedDate'] != null && map['paymentReceivedDate'] != "" ? DateTime.parse(map['paymentReceivedDate']) : null,
      sessionType: map['sessionType'] != null ? SessionType.fromMap(map['sessionType']) : null,
      type: map['type'] != null ? JobType.fromMap(map['type']) : null,
      stage: JobStage.fromMap(map['stage']),
      client: map['client'] != null ? Client.fromMap(map['client']) : null,
      location: map['location'] != null ? LocationDandy.fromMap(map['location']) : null,
      priceProfile: map['priceProfile'] != null ? PriceProfile.fromMap(map['priceProfile']) : null,
      invoice: map['invoice'] != null ? Invoice.fromMap(map['invoice']) : null,
      completedStages: convertMapsToJobStages(map['completedStages']),
      poses: convertMapsToPoses(map['poses']),
      depositAmount: map['depositAmount'],
      tipAmount: map['tipAmount'],
      proposal: map['proposal'] != null ? Proposal.fromMap(map['proposal']) : null,
    );
  }

  List<Map<String, dynamic>> convertCompletedStagesToMap(List<JobStage>? completedStages){
    List<Map<String, dynamic>> listOfMaps = [];
    for(JobStage jobStage in completedStages!){
      listOfMaps.add(jobStage.toMap());
    }
    return listOfMaps;
  }

  static List<JobStage> convertMapsToJobStages(List listOfMaps){
    List<JobStage> listOfJobStages = [];
    for(Map map in listOfMaps){
      listOfJobStages.add(JobStage.fromMap(map as Map<String, dynamic>));
    }
    return listOfJobStages;
  }

  List<Map<String, dynamic>> convertPosesToMap(List<Pose>? poses){
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
    for(Map map in listOfMaps){
      poses.add(Pose.fromMap(map as Map<String, dynamic>));
    }
      return poses;
  }

  bool isDepositPaid () {
    bool isDepositPaid = false;
    for(JobStage jobStage in completedStages!){
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
    for(JobStage completedStage in completedStages!){
      if(completedStage.stage == jobStage) return true;
    }
    return false;
  }

  bool isPaymentReceived() {
    for(JobStage completedStage in completedStages!){
      if(completedStage.stage == JobStage.STAGE_9_PAYMENT_RECEIVED || completedStage.stage == JobStage.STAGE_14_JOB_COMPLETE || completedStage.stage == JobStage.STAGE_COMPLETED_CHECK) return true;
    }
    if(invoice != null && invoice!.invoicePaid!) return true;
    return false;
  }

  double getJobCost() {
    double taxAmount = ((sessionType != null ? sessionType!.totalCost : 0) + (addOnCost ?? 0)) * (sessionType?.salesTaxPercent ?? 0.0)/100;
    return (sessionType != null ? sessionType!.totalCost : 0) + (addOnCost ?? 0) + taxAmount;
  }

  static bool containsStage(List<JobStage>? completedStages, String? stageConstant) {
    bool contains = false;
    for(JobStage stage in completedStages!){
      if(stage.stage == stageConstant){
        contains = true;
      }
    }
    return contains;
  }

  static bool containsStageById(List<JobStage> completedStages, int id) {
    bool contains = false;
    for(JobStage stage in completedStages){
      if(stage.id == id){
        contains = true;
      }
    }
    return contains;
  }

  int getStageIndex(String stageToMatch) {
    for(int i = 0; i < sessionType!.stages!.length; i++) {
      if(sessionType!.stages!.elementAt(i).stage == stageToMatch) {
        return i;
      }
    }
    return 0;
  }

  static JobStage getNextUncompletedStage(List<JobStage> completedStages, List<JobStage> stages, Job job) {
    int indexOfHighestCompleted = 0;
    for(JobStage completedStage in completedStages) {
      int index = job.getStageIndex(completedStage.stage!);
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

  bool isMissingMileageTrip() {
    DateTime now = DateTime.now();
    if(!hasAddedMileageTrip! && shouldTrackMiles! && selectedDate != null && location != null && now.isAfter(selectedDate!) ) {
      return true;
    } else {
      return false;
    }
  }
}