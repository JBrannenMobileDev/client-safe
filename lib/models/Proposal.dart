import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Profile.dart';

import 'Contract.dart';
import 'Feedback.dart';
import 'Job.dart';
import 'Questionnaire.dart';

class Proposal {
  static const String DETAILS_PAGE = 'details';
  static const String CONTRACT_PAGE = 'contract';
  static const String INVOICE_PAGE = 'invoice';
  static const String QUESTIONNAIRE_PAGE = 'questionnaire';
  static const String POSES_PAGE = 'poses';
  static const String FEEDBACK_PAGE = 'feedback';

  int? id;
  String? detailsMessage = '';
  String? shareMessage = '';
  Contract? contract;
  Questionnaire? questionnaire;
  Feedback? feedback;
  bool? contractSeenByClient = false;
  bool? invoiceSeenByClient = false;
  bool? posesSeenByClient = false;
  bool? questionnaireSeenByClient = false;
  bool? feedbackSeenByClient = false;
  bool? includePoses = false;
  bool? includeContract = false;
  bool? includeInvoice = false;

  Proposal({
      this.detailsMessage,
      this.contract,
      this.contractSeenByClient,
      this.invoiceSeenByClient,
      this.posesSeenByClient,
      this.questionnaireSeenByClient,
      this.feedbackSeenByClient,
      this.questionnaire,
      this.feedback,
      this.includePoses,
      this.id,
      this.includeInvoice,
      this.includeContract,
      this.shareMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'detailsMessage' : detailsMessage,
      'shareMessage' : shareMessage,
      'contract' : contract?.toMap(),
      'contractSeenByClient' : contractSeenByClient,
      'invoiceSeenByClient' : invoiceSeenByClient,
      'posesSeenByClient' : posesSeenByClient,
      'questionnaireSeenByClient' : questionnaireSeenByClient,
      'feedbackSeenByClient' : feedbackSeenByClient,
      'questionnaire' : questionnaire?.toMap(),
      'feedback' : feedback?.toMap(),
      'includePoses' : includePoses,
      'includeInvoice' : includeInvoice,
      'includeContract' : includeContract,
    };
  }

  static Proposal fromMap(Map<String, dynamic> map) {
    return Proposal(
      detailsMessage: map['detailsMessage'] != null ? map['detailsMessage'] : '',
      shareMessage: map['shareMessage'] != null ? map['shareMessage'] : '',
      contract: map['contract'] != null ? Contract.fromMap(map['contract']) : null,
      contractSeenByClient: map['contractSeenByClient'] != null ? map['contractSeenByClient'] : false,
      invoiceSeenByClient: map['invoiceSeenByClient'] != null ? map['invoiceSeenByClient'] : false,
      posesSeenByClient: map['posesSeenByClient'] != null ? map['posesSeenByClient'] : false,
      questionnaireSeenByClient: map['questionnaireSeenByClient'] != null ? map['questionnaireSeenByClient'] : false,
      feedbackSeenByClient: map['feedbackSeenByClient'] != null ? map['feedbackSeenByClient'] : false,
      questionnaire: map['questionnaire'] != null ? Questionnaire.fromMap(map['questionnaire']) : null,
      feedback: map['feedback'] != null ? Feedback.fromMap(map['feedback']) : null,
      includePoses: map['includePoses'] != null ? map['includePoses'] : false,
      includeInvoice: map['includeInvoice'] != null ? map['includeInvoice'] : false,
      includeContract: map['includeContract'] != null ? map['includeContract'] : false,
    );
  }
}