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

  int id;
  String jobDocumentId;
  String documentId;
  String userId;
  String detailsMessage;
  String logoUrl;
  String bannerUrl;
  Job job;
  Invoice invoice;
  Contract contract;
  Profile profile;
  Questionnaire questionnaire;
  Feedback feedback;
  bool contractSeenByClient = false;
  bool invoiceSeenByClient = false;
  bool posesSeenByClient = false;
  bool questionnaireSeenByClient = false;
  bool feedbackSeenByClient = false;
  bool includePoses = false;

  Proposal({
      this.id,
      this.jobDocumentId,
      this.documentId,
      this.userId,
      this.detailsMessage,
      this.job,
      this.invoice,
      this.contract,
      this.contractSeenByClient,
      this.invoiceSeenByClient,
      this.posesSeenByClient,
      this.profile,
      this.questionnaireSeenByClient,
      this.feedbackSeenByClient,
      this.logoUrl,
      this.questionnaire,
      this.feedback,
      this.includePoses,
      this.bannerUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'jobDocumentId' : jobDocumentId,
      'userId': userId,
      'detailsMessage' : detailsMessage,
      'job' : job?.toMap(),
      'invoice' : invoice?.toMap(),
      'contract' : contract?.toMap(),
      'contractSeenByClient' : contractSeenByClient,
      'invoiceSeenByClient' : invoiceSeenByClient,
      'posesSeenByClient' : posesSeenByClient,
      'profile' : profile?.toMap(),
      'questionnaireSeenByClient' : questionnaireSeenByClient,
      'feedbackSeenByClient' : feedbackSeenByClient,
      'logoUrl' : logoUrl,
      'questionnaire' : questionnaire?.toMap(),
      'feedback' : feedback?.toMap(),
      'includePoses' : includePoses,
      'bannerUrl' : bannerUrl,
    };
  }

  static Proposal fromMap(Map<String, dynamic> map) {
    return Proposal(
      documentId: map['documentId'],
      jobDocumentId: map['jobDocumentId'],
      userId: map['userId'],
      detailsMessage: map['detailsMessage'],
      invoice: map['invoice'] != null ? Invoice.fromMap(map['invoice']) : null,
      contract: map['contract'] != null ? Contract.fromMap(map['contract']) : null,
      job: map['job'] != null ? Job.fromMap(map['job']) : null,
      profile: map['profile'] != null ? Profile.fromMap(map['profile']) : null,
      contractSeenByClient: map['contractSeenByClient'],
      invoiceSeenByClient: map['invoiceSeenByClient'],
      posesSeenByClient: map['posesSeenByClient'],
      questionnaireSeenByClient: map['questionnaireSeenByClient'],
      feedbackSeenByClient: map['feedbackSeenByClient'],
      logoUrl: map['logoUrl'],
      questionnaire: map['questionnaire'] != null ? Questionnaire.fromMap(map['questionnaire']) : null,
      feedback: map['feedback'] != null ? Feedback.fromMap(map['feedback']) : null,
      includePoses: map['includePoses'],
      bannerUrl: map['bannerUrl'],
    );
  }
}