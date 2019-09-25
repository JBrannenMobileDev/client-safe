class Job {
  static const String JOB_TYPE_MATERNITY = 'assets/images/job_types/maternity.png';
  static const String JOB_TYPE_ENGAGEMENT = 'assets/images/job_types/engagement.png';
  static const String JOB_TYPE_FAMILY_PORTRAIT = 'assets/images/job_types/family_portrait.png';
  static const String JOB_TYPE_NEWBORN = 'assets/images/job_types/newborn.png';
  static const String JOB_TYPE_OTHER = 'assets/images/job_types/other.png';
  static const String JOB_TYPE_WEDDING = 'assets/images/job_types/wdding.png';
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

  String clientId;
  String clientName;
  String jobTitle;
  int lengthInHours;
  String notes;
  double price;
  String professionalUserId;
  DateTime dateTime;
  String type;

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
  });
}