import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';

class Job {
  static const String JOB_TYPE_MATERNITY = 'Maternity';
  static const String JOB_TYPE_ENGAGEMENT = 'Engagement';
  static const String JOB_TYPE_FAMILY_PORTRAIT = 'Family';
  static const String JOB_TYPE_NEWBORN = 'Newborn';
  static const String JOB_TYPE_OTHER = 'Other';
  static const String JOB_TYPE_WEDDING = 'Wedding';
  static const String JOB_TYPE_PET = 'Pet';
  static const String JOB_TYPE_COMMERCIAL_ADVERTISING = 'Advertising';
  static const String JOB_TYPE_MODELING = 'Modeling';
  static const String JOB_TYPE_HEAD_SHOTS = 'Headshots';
  static const String JOB_TYPE_REAL_ESTATE_ARCHITECTURE = 'Architecture';
  static const String JOB_TYPE_BREASTFEEDING = 'Breastfeeding';
  static const String JOB_TYPE_EVENT = 'Event';
  static const String JOB_TYPE_NATURE = 'Nature';
  static const String JOB_TYPE_ANNIVERSARY = 'Anniversary';
  static const String JOB_TYPE_BIRTHDAY = 'Birthday';
  static const String JOB_TYPE_BOUDOIR = 'Boudoir';

  static const String GENDER_FEMALE = "female";
  static const String GENDER_MALE = "male";
  static const String GENDER_NEUTRAL = "neutral";

  int id;
  String documentId;
  String clientDocumentId;
  String clientName;
  String jobTitle;
  PriceProfile priceProfile;
  Location location;
  String notes;
  String professionalUserId;
  DateTime selectedDate;
  DateTime selectedTime;
  DateTime createdDate;
  String type;
  JobStage stage;
  Invoice invoice;
  int depositAmount;
  int tipAmount;
  List<JobStage> completedStages;

  Job({
    this.id,
    this.documentId,
    this.clientDocumentId,
    this.clientName,
    this.jobTitle,
    this.notes,
    this.professionalUserId,
    this.selectedDate,
    this.selectedTime,
    this.type,
    this.stage,
    this.completedStages,
    this.location,
    this.priceProfile,
    this.invoice,
    this.depositAmount,
    this.createdDate,
    this.tipAmount,
  });

  Job copyWith({
    int id,
    String documentId,
    int clientId,
    String clientName,
    String jobTitle,
    PriceProfile priceProfile,
    Location location,
    String notes,
    String professionalUserId,
    DateTime selectedDate,
    DateTime selectedTime,
    String type,
    JobStage stage,
    Invoice invoice,
    int depositAmount,
    int tipAmount,
    List<JobStage> completedStages,
    DateTime createdDate,
  }){
    return Job(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      clientDocumentId: clientId ?? this.clientDocumentId,
      clientName: clientName ?? this.clientName,
      jobTitle: jobTitle ?? this.jobTitle,
      priceProfile: priceProfile ?? this.priceProfile,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      professionalUserId: professionalUserId ?? this.professionalUserId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      type: type ?? this.type,
      stage: stage ?? this.stage,
      invoice: invoice ?? this.invoice,
      depositAmount: depositAmount ?? this.depositAmount,
      tipAmount: tipAmount ?? this.tipAmount,
      completedStages: completedStages ?? this.completedStages,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'clientDocumentId': clientDocumentId,
      'clientName' : clientName,
      'jobTitle' : jobTitle,
      'notes' : notes,
      'professionalUserId' : professionalUserId,
      'selectedDate' : selectedDate?.toString() ?? "",
      'selectedTime' : selectedTime?.toString() ?? "",
      'createdDate' : createdDate?.toString() ?? "",
      'type' : type,
      'stage' : stage?.toMap() ?? null,
      'location' : location?.toMap() ?? null,
      'priceProfile' : priceProfile?.toMap() ?? null,
      'invoice' : invoice?.toMap() ?? null,
      'completedStages' : convertCompletedStagesToMap(completedStages),
      'depositAmount' : depositAmount,
      'tipAmount' : tipAmount,
    };
  }

  static Job fromMap(Map<String, dynamic> map) {
    return Job(
      documentId: map['documentId'],
      clientDocumentId: map['clientDocumentId'],
      clientName: map['clientName'],
      jobTitle: map['jobTitle'],
      notes: map['notes'],
      professionalUserId: map['professionalUserId'],
      selectedDate: map['selectedDate'] != ""? DateTime.parse(map['selectedDate']) : null,
      selectedTime: map['selectedTime'] != "" ? DateTime.parse(map['selectedTime']) : null,
      createdDate: map['createdDate'] != "" ? DateTime.parse(map['createdDate']) : null,
      type: map['type'],
      stage: JobStage.fromMap(map['stage']),
      location: map['location'] != null ? Location.fromMap(map['location']) : null,
      priceProfile: map['priceProfile'] != null ? PriceProfile.fromMap(map['priceProfile']) : null,
      invoice: map['invoice'] != null ? Invoice.fromMap(map['invoice']) : null,
      completedStages: convertMapsToJobStages(map['completedStages']),
      depositAmount: map['depositAmount'],
      tipAmount: map['tipAmount'],
    );
  }

  List<Map<String, dynamic>> convertCompletedStagesToMap(List<JobStage> completedStages){
    List<Map<String, dynamic>> listOfMaps = List();
    for(JobStage jobStage in completedStages){
      listOfMaps.add(jobStage.toMap());
    }
    return listOfMaps;
  }

  static List<JobStage> convertMapsToJobStages(List listOfMaps){
    List<JobStage> listOfJobStages = List();
    for(Map map in listOfMaps){
      listOfJobStages.add(JobStage.fromMap(map));
    }
    return listOfJobStages;
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
      if(completedStage.stage == JobStage.STAGE_9_PAYMENT_RECEIVED) return true;
    }
    return false;
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
}