
import 'package:dandylight/models/Progress.dart';
import 'package:json_annotation/json_annotation.dart';
part 'PendingEmail.g.dart';

@JsonSerializable(explicitToJson: true)
class PendingEmail{
  static const String TYPE_ACCOUNT_CREATED_1 = 'account_created_1';
  static const String TYPE_ACCOUNT_CREATED_2 = 'account_created_2';
  static const String TYPE_ACCOUNT_CREATED_3 = 'account_created_3';
  static const String TYPE_ACCOUNT_CREATED_4 = "account_created_4";
  static const String TYPE_VIEW_CLIENT_PORTAL = 'view_client_portal';
  static const String TYPE_VIEW_EXAMPLE_JOB = 'view_example_job';
  static const String TYPE_SETUP_YOU_BRAND = 'setup_your_brand';
  static const String TYPE_CREATE_PRICE_PACKAGE = 'create_price_package';
  static const String TYPE_ADD_FIRST_CLIENT = 'add_first_client';
  static const String TYPE_CREATE_FIRST_JOB = 'create_first_job';
  static const String TYPE_CREATE_CONTRACT = 'create_contract';
  static const String TYPE_ADD_CONTRACT_TO_JOB = 'add_contract_to_job';
  static const String TYPE_ADD_INVOICE_TO_JOB = 'add_invoice_to_job';
  static const String TYPE_ADD_QUESTIONNAIRE_TO_JOB = 'add_questionnaire_to_job';
  static const String TYPE_ADD_POSES_TO_JOB = 'add_poses_to_job';
  static const String TYPE_ADD_LOCATION_TO_JOB = 'add_location_to_job';
  static const String TYPE_TRIAL_LIMIT_REACHED = 'trial_limit_reached';
  static const String TYPE_EMAIL_VERIFICATION_HELP = 'email_verification_help';

  int? id;
  String? documentId;
  DateTime sendDate;
  String emailType;
  String toAddress;
  String photographerName;
  String uid;

  PendingEmail({
    this.id,
    this.documentId,
    required this.sendDate,
    required this.emailType,
    required this.toAddress,
    required this.uid,
    required this.photographerName,
  });

  factory PendingEmail.fromJson(Map<String, dynamic> json) => _$PendingEmailFromJson(json);
  Map<String, dynamic> toJson() => _$PendingEmailToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'documentId' : documentId,
      'sendDate' : sendDate.millisecondsSinceEpoch,
      'emailType' : emailType,
      'toAddress' : toAddress,
      'uid' : uid,
      'photographerName' : photographerName
    };
  }

  static PendingEmail fromMap(Map<String, dynamic> map) {
    return PendingEmail(
      id: map['id'],
      documentId: map['documentId'],
      sendDate: DateTime.fromMillisecondsSinceEpoch(map['sendDate']),
      emailType: map['emailType'],
      toAddress: map['toAddress'],
      uid: map['uid'],
      photographerName: map['photographerName']
    );
  }

  static String? getNextUncompletedType(Progress progress) {
    if(!progress.previewClientPortal) return PendingEmail.TYPE_VIEW_CLIENT_PORTAL;
    if(!progress.previewSampleJob) return PendingEmail.TYPE_VIEW_EXAMPLE_JOB;
    if(!progress.setupBrand) return PendingEmail.TYPE_SETUP_YOU_BRAND;
    if(!progress.addClient) return PendingEmail.TYPE_ADD_FIRST_CLIENT;
    //TODO Create first session type
    if(!progress.createJob) return PendingEmail.TYPE_CREATE_FIRST_JOB;
    if(!progress.createContract) return PendingEmail.TYPE_CREATE_CONTRACT;
    if(!progress.addContractToJob) return PendingEmail.TYPE_ADD_CONTRACT_TO_JOB;
    if(!progress.addInvoiceToJob) return PendingEmail.TYPE_ADD_INVOICE_TO_JOB;
    if(!progress.addQuestionnaireToJob) return PendingEmail.TYPE_ADD_QUESTIONNAIRE_TO_JOB;
    if(!progress.addPosesToJob) return PendingEmail.TYPE_ADD_POSES_TO_JOB;
    if(!progress.addLocationToJob) return PendingEmail.TYPE_ADD_LOCATION_TO_JOB;
    return null;
  }
}