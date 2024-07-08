
import 'package:dandylight/models/Progress.dart';

class PendingEmail{
  static const String TYPE_ACCOUNT_CREATED_1 = 'account_created_1';
  static const String TYPE_ACCOUNT_CREATED_2 = 'account_created_2';
  static const String TYPE_ACCOUNT_CREATED_3 = 'account_created_3';
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
  static const String TYPE_GETTING_STARTED_COMPLETE = 'getting_started_complete';
  static const String TYPE_WHERE_HAVE_YOU_GONE = 'where_have_you_gone';
  static const String TYPE_1_MONTH_SINCE_TRIAL_LIMIT = '1_month_since_trial_limit';

  int? id;
  String? documentId;
  DateTime sendDate;
  String type;
  String toAddress;
  String photographerName;
  String uid;

  PendingEmail({
    this.id,
    this.documentId,
    required this.sendDate,
    required this.type,
    required this.toAddress,
    required this.uid,
    required this.photographerName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'documentId' : documentId,
      'sendDate' : sendDate.millisecondsSinceEpoch,
      'emailType' : type,
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
      type: map['emailType'],
      toAddress: map['toAddress'],
      uid: map['uid'],
      photographerName: map['photographerName']
    );
  }

  static String? getNextUncompletedType(Progress progress) {
    if(!progress.previewClientPortal) return PendingEmail.TYPE_VIEW_CLIENT_PORTAL;
    return null;
  }
}