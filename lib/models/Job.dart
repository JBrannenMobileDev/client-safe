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

  static const String JOB_STAGE_INQUIRY = "assets/images/job_progress/inquiry.png";
  static const String JOB_STAGE_FOLLOW_UP = "assets/images/job_progress/follow_up.png";
  static const String JOB_STAGE_SEND_PROPOSAL = "assets/images/job_progress/proposal_sent.png";
  static const String JOB_STAGE_SIGN_PROPOSAL = "assets/images/job_progress/proposal_signed.png";
  static const String JOB_STAGE_PLANNING = "assets/images/job_progress/planning.png";
  static const String JOB_STAGE_EDITING = "assets/images/job_progress/editing.png";
  static const String JOB_STAGE_SEND_GALLERY = "assets/images/job_progress/send_gallery.png";
  static const String JOB_STAGE_COLLECT_PAYMENT = "assets/images/job_progress/collect_payment.png";
  static const String JOB_STAGE_GET_FEEDBACK = "assets/images/job_progress/get_feedback.png";
  static const String JOB_STAGE_COMPLETED_CHECK = "assets/images/job_progress/check_mark.png";

  String clientId;
  String clientName;
  String jobTitle;
  int lengthInHours;
  String notes;
  double price;
  String professionalUserId;
  DateTime dateTime;
  String type;
  String stage;

  Job({
    this.clientId,
    this.clientName,
    this.jobTitle,
    this.lengthInHours,
    this.notes,
    this.price,
    this.professionalUserId,
    this.dateTime,
    this.type,
    this.stage,
  });

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
        return "";
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
    switch(stage){
      case JOB_STAGE_INQUIRY:
        return 0;
      case JOB_STAGE_FOLLOW_UP:
        return 1;
      case JOB_STAGE_SEND_PROPOSAL:
        return 2;
      case JOB_STAGE_SIGN_PROPOSAL:
        return 3;
      case JOB_STAGE_PLANNING:
        return 4;
      case JOB_STAGE_EDITING:
        return 5;
      case JOB_STAGE_SEND_GALLERY:
        return 6;
      case JOB_STAGE_COLLECT_PAYMENT:
        return 7;
      case JOB_STAGE_GET_FEEDBACK:
        return 8;
    }
    return 0;
  }
}