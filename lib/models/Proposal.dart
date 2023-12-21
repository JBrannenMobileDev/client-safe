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
  String detailsMessage = '';
  Contract contract;
  List<Questionnaire> questionnaires;
  Feedback feedback;
  bool contractSeenByClient = false;
  bool invoiceSeenByClient = false;
  bool posesSeenByClient = false;
  bool questionnaireSeenByClient = false;
  bool feedbackSeenByClient = false;
  bool includePoses = false;
  bool includeContract = false;
  bool includeInvoice = false;

  Proposal({
      this.detailsMessage,
      this.contract,
      this.contractSeenByClient,
      this.invoiceSeenByClient,
      this.posesSeenByClient,
      this.questionnaireSeenByClient,
      this.feedbackSeenByClient,
      this.questionnaires,
      this.feedback,
      this.includePoses,
      this.id,
      this.includeInvoice,
      this.includeContract,
  });

  Map<String, dynamic> toMap() {
    return {
      'detailsMessage' : detailsMessage,
      'contract' : contract?.toMap(),
      'contractSeenByClient' : contractSeenByClient,
      'invoiceSeenByClient' : invoiceSeenByClient,
      'posesSeenByClient' : posesSeenByClient,
      'questionnaireSeenByClient' : questionnaireSeenByClient,
      'feedbackSeenByClient' : feedbackSeenByClient,
      'questionnaires' : convertQuestionnairesToMap(questionnaires),
      'feedback' : feedback?.toMap(),
      'includePoses' : includePoses,
      'includeInvoice' : includeInvoice,
      'includeContract' : includeContract,
    };
  }

  static Proposal fromMap(Map<String, dynamic> map) {
    return Proposal(
      detailsMessage: map['detailsMessage'] ?? '',
      contract: map['contract'] != null ? Contract.fromMap(map['contract']) : null,
      contractSeenByClient: map['contractSeenByClient'] ?? false,
      invoiceSeenByClient: map['invoiceSeenByClient'] ?? false,
      posesSeenByClient: map['posesSeenByClient'] ?? false,
      questionnaireSeenByClient: map['questionnaireSeenByClient'] ?? false,
      feedbackSeenByClient: map['feedbackSeenByClient'] ?? false,
      questionnaires: map['questionnaires'] != null ? convertMapsToQuestionnaires(map['questionnaires']) : [],
      feedback: map['feedback'] != null ? Feedback.fromMap(map['feedback']) : null,
      includePoses: map['includePoses'] ?? false,
      includeInvoice: map['includeInvoice'] ?? false,
      includeContract: map['includeContract'] ?? false,
    );
  }

  List<Map<String, dynamic>> convertQuestionnairesToMap(List<Questionnaire> questionnaires){
    List<Map<String, dynamic>> listOfMaps = [];
    for(Questionnaire questionnaire in questionnaires){
      listOfMaps.add(questionnaire.toMap());
    }
    return listOfMaps;
  }

  static List<Questionnaire> convertMapsToQuestionnaires(List listOfMaps){
    List<Questionnaire> listOfQuestionnaires = [];
    for(Map map in listOfMaps){
      listOfQuestionnaires.add(Questionnaire.fromMap(map));
    }
    return listOfQuestionnaires;
  }
}