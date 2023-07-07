import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Profile.dart';

import 'Contract.dart';
import 'Job.dart';

class Proposal {
  static const String DETAILS_PAGE = 'details';
  static const String CONTRACT_PAGE = 'contract';
  static const String INVOICE_PAGE = 'invoice';
  static const String QUESTIONNAIRE_PAGE = 'questionnaire';
  static const String POSES_PAGE = 'poses';
  static const String FEEDBACK_PAGE = 'feedback';

  int id;
  String documentId;
  String userId;
  String detailsMessage;
  String businessName;
  String clientName;
  String photographerName;
  String photographerPhone;
  String clientPhone;
  String photographerEmail;
  String clientEmail;
  Job job;
  Invoice invoice;
  Contract contract;
  Profile profile;
  bool contractSeenByClient = false;
  bool invoiceSeenByClient = false;
  bool posesSeenByClient = false;
  bool questionnaireSeenByClient = false;
  bool feedbackSeenByClient = false;
  List<dynamic> includedPages = [];

  Proposal({
      this.id,
      this.documentId,
      this.userId,
      this.detailsMessage,
      this.businessName,
      this.clientName,
      this.photographerName,
      this.photographerPhone,
      this.clientPhone,
      this.photographerEmail,
      this.clientEmail,
      this.job,
      this.invoice,
      this.contract,
      this.contractSeenByClient,
      this.invoiceSeenByClient,
      this.posesSeenByClient,
      this.includedPages,
      this.profile,
      this.questionnaireSeenByClient,
      this.feedbackSeenByClient,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'userId': userId,
      'detailsMessage' : detailsMessage,
      'businessName' : businessName,
      'clientName' : clientName,
      'photographerName' : photographerName,
      'photographerPhone' : photographerPhone,
      'clientPhone' : clientPhone,
      'photographerEmail' : photographerEmail,
      'clientEmail' : clientEmail,
      'job' : job?.toMap(),
      'invoice' : invoice?.toMap(),
      'contract' : contract?.toMap(),
      'contractSeenByClient' : contractSeenByClient,
      'invoiceSeenByClient' : invoiceSeenByClient,
      'posesSeenByClient' : posesSeenByClient,
      'includedPages' : includedPages,
      'profile' : profile?.toMap(),
      'questionnaireSeenByClient' : questionnaireSeenByClient,
      'feedbackSeenByClient' : feedbackSeenByClient,
    };
  }

  static Proposal fromMap(Map<String, dynamic> map) {
    return Proposal(
      documentId: map['documentId'],
      userId: map['userId'],
      detailsMessage: map['detailsMessage'],
      businessName: map['businessName'],
      clientName: map['clientName'],
      photographerName: map['photographerName'],
      photographerPhone: map['photographerPhone'],
      clientPhone: map['clientPhone'],
      clientEmail: map['clientEmail'],
      photographerEmail: map['photographerEmail'],
      invoice: map['invoice'] != null ? Invoice.fromMap(map['invoice']) : null,
      contract: map['contract'] != null ? Contract.fromMap(map['contract']) : null,
      job: map['job'] != null ? Job.fromMap(map['job']) : null,
      profile: map['profile'] != null ? Profile.fromMap(map['profile']) : null,
      contractSeenByClient: map['contractSeenByClient'],
      invoiceSeenByClient: map['invoiceSeenByClient'],
      posesSeenByClient: map['posesSeenByClient'],
      questionnaireSeenByClient: map['questionnaireSeenByClient'],
      feedbackSeenByClient: map['feedbackSeenByClient'],
    );
  }
}