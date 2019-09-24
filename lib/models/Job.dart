class Job {
  static const String JOB_TYPE_MATERNITY = "Maternity";
  static const String JOB_TYPE_ENGAGEMENT = "Engagement";
  static const String JOB_TYPE_FAMILY_PORTRAIT = "Family Portrait";
  static const String JOB_TYPE_NEWBORN = "Newborn";
  static const String JOB_TYPE_OTHER = "Other";
  static const String JOB_TYPE_WEDDING = "Wedding";
  static const String JOB_TYPE_PET = "Pet";
  static const String JOB_TYPE_COMMERCIAL_ADVERTISING = "Commercial/Advertising";
  static const String JOB_TYPE_MODELING = "Modeling";
  static const String JOB_TYPE_HEAD_SHOTS = "Headshots";
  static const String JOB_TYPE_REAL_ESTATE_ARCHITECTURE = "Realestate/Architecture";
  static const String JOB_TYPE_BREASTFEEDING = "Breastfeeding";
  static const String JOB_TYPE_EVENT = "Event";
  static const String JOB_TYPE_NATURE = "Nature";
  static const String JOB_TYPE_ANNIVERSARY = "Anniversary";
  static const String JOB_TYPE_BIRTHDAY = "Birthday";

  static const String GENDER_FEMALE = "female";
  static const String GENDER_MALE = "male";
  static const String GENDER_NEUTRAL = "neutral";

  String clientId;
  String clientName;
  String clientGender;
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
    this.clientGender,
    this.jobTitle,
    this.lengthInHours,
    this.notes,
    this.price,
    this.professionalUserId,
    this.dateTime,
    this.type,
  });
}