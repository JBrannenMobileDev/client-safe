import 'package:client_safe/models/Event.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:flutter/src/painting/image_resolution.dart';

class Job {
  static const String JOB_TYPE_MATERNITY = 'assets/images/job_types/maternity.png';
  static const String JOB_TYPE_ENGAGEMENT = 'assets/images/job_types/engagement.png';
  static const String JOB_TYPE_FAMILY_PORTRAIT = 'assets/images/job_types/family_portrait.png';
  static const String JOB_TYPE_NEWBORN = 'assets/images/job_types/newborn.png';
  static const String JOB_TYPE_OTHER = 'assets/images/job_types/other.png';
  static const String JOB_TYPE_WEDDING = 'assets/images/job_types/wedding.png';
  static const String JOB_TYPE_PET = 'assets/images/job_types/pet.png';
  static const String JOB_TYPE_COMMERCIAL_ADVERTISING = 'assets/images/job_types/commercial_advertising.png';
  static const String JOB_TYPE_MODELING = 'assets/images/job_types/modeling.png';
  static const String JOB_TYPE_HEAD_SHOTS = 'assets/images/people/gender_nuetral_white_hair.png';
  static const String JOB_TYPE_REAL_ESTATE_ARCHITECTURE = 'assets/images/job_types/real_estate_architecture.png';
  static const String JOB_TYPE_BREASTFEEDING = 'assets/images/job_types/breastfeeding.png';
  static const String JOB_TYPE_EVENT = 'assets/images/job_types/event.png';
  static const String JOB_TYPE_NATURE = 'assets/images/job_types/nature.png';
  static const String JOB_TYPE_ANNIVERSARY = 'assets/images/job_types/anniversary.png';
  static const String JOB_TYPE_BIRTHDAY = 'assets/images/job_types/birthday.png';

  static const String GENDER_FEMALE = "female";
  static const String GENDER_MALE = "male";
  static const String GENDER_NEUTRAL = "neutral";

  int id;
  int clientId;
  String clientName;
  String jobTitle;
  PriceProfile priceProfile;
  Location location;
  String notes;
  String professionalUserId;
  DateTime selectedDate;
  DateTime selectedTime;
  String type;
  JobStage stage;
  List<JobStage> completedStages;

  Job({
    this.id,
    this.clientId,
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
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'clientId': clientId,
      'clientName' : clientName,
      'jobTitle' : jobTitle,
      'notes' : notes,
      'professionalUserId' : professionalUserId,
      'selectedDate' : selectedDate.millisecondsSinceEpoch,
      'selectedTime' : selectedTime.millisecondsSinceEpoch,
      'type' : type,
      'stage' : stage.toMap(),
      'location' : location.toMap(),
      'priceProfile' : priceProfile.toMap(),
      'completedStages' : convertCompletedStagesToMap(completedStages),
    };
  }

  static Job fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      clientId: map['clientId'],
      clientName: map['clientName'],
      jobTitle: map['jobTitle'],
      notes: map['notes'],
      professionalUserId: map['professionalUserId'],
      selectedDate: DateTime.fromMillisecondsSinceEpoch(map['selectedDate']),
      selectedTime: DateTime.fromMillisecondsSinceEpoch(map['selectedTime']),
      type: map['type'],
      stage: JobStage.fromMap(map['stage']),
      location: Location.fromMap(map['location']),
      priceProfile: PriceProfile.fromMap(map['priceProfile']),
      completedStages: convertMapsToJobStages(map['completedStages']),
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

  String getJobType(){
    switch(type){
      case JOB_TYPE_ANNIVERSARY:
        return "Anniversary";
      case JOB_TYPE_BIRTHDAY:
        return "Birthday";
      case JOB_TYPE_BREASTFEEDING:
        return "Breastfeeding";
      case JOB_TYPE_COMMERCIAL_ADVERTISING:
        return "Commercial/Advertising";
      case JOB_TYPE_ENGAGEMENT:
        return "Engagement";
      case JOB_TYPE_EVENT:
        return "Event";
      case JOB_TYPE_FAMILY_PORTRAIT:
        return "Family Portrait";
      case JOB_TYPE_HEAD_SHOTS:
        return "Head Shots";
      case JOB_TYPE_MATERNITY:
        return "Maternity";
      case JOB_TYPE_MODELING:
        return "Modeling";
      case JOB_TYPE_NATURE:
        return "Nature";
      case JOB_TYPE_NEWBORN:
        return "Newborn";
      case JOB_TYPE_OTHER:
        return "Other";
      case JOB_TYPE_PET:
        return "Pet";
      case JOB_TYPE_REAL_ESTATE_ARCHITECTURE:
        return "RealEstate/Architecture";
      case JOB_TYPE_WEDDING:
        return "Wedding";
    }
    return "";
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
      case JobStage.STAGE_5_PLANNING_COMPLETE:
        return 5;
      case JobStage.STAGE_6_SESSION_COMPLETE:
        return 6;
      case JobStage.STAGE_7_EDITING_COMPLETE:
        return 7;
      case JobStage.STAGE_8_GALLERY_SENT:
        return 8;
      case JobStage.STAGE_9_PAYMENT_REQUESTED:
        return 9;
      case JobStage.STAGE_10_PAYMENT_RECEIVED:
        return 10;
      case JobStage.STAGE_11_FEEDBACK_REQUESTED:
        return 11;
      case JobStage.STAGE_12_FEEDBACK_RECEIVED:
        return 12;
    }
    return 1;
  }
}