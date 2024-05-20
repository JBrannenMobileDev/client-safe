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
  List<Contract>? contracts;
  List<Questionnaire>? questionnaires;
  Feedback? feedback;
  bool? contractSeenByClient = false;
  bool? invoiceSeenByClient = false;
  bool? posesSeenByClient = false;
  bool? questionnaireSeenByClient = false;
  bool? feedbackSeenByClient = false;
  bool? includePoses = false;
  bool? includeContract = false;
  bool? includeInvoice = false;
  bool? includeQuestionnaires = false;

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
      this.shareMessage,
      this.includeQuestionnaires,
      this.contracts,
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
      'questionnaires' : convertQuestionnairesToMap(questionnaires),
      'feedback' : feedback?.toMap(),
      'includePoses' : includePoses,
      'includeInvoice' : includeInvoice,
      'includeContract' : includeContract,
      'includeQuestionnaires' : includeQuestionnaires,
      'contracts' : convertContractsToMap(contracts),
    };
  }

  static Proposal fromMap(Map<String, dynamic> map) {
    return Proposal(
      detailsMessage: map['detailsMessage'] ?? '',
      contract: map['contract'] != null ? Contract.fromMap(map['contract']) : null,
      shareMessage: map['shareMessage'] != null ? map['shareMessage'] : '',
      contractSeenByClient: map['contractSeenByClient'] != null ? map['contractSeenByClient'] : false,
      invoiceSeenByClient: map['invoiceSeenByClient'] != null ? map['invoiceSeenByClient'] : false,
      posesSeenByClient: map['posesSeenByClient'] != null ? map['posesSeenByClient'] : false,
      questionnaireSeenByClient: map['questionnaireSeenByClient'] != null ? map['questionnaireSeenByClient'] : false,
      feedbackSeenByClient: map['feedbackSeenByClient'] != null ? map['feedbackSeenByClient'] : false,
      questionnaires: map['questionnaires'] != null ? convertMapsToQuestionnaires(map['questionnaires']) : [],
      contracts: map['contracts'] != null ? convertMapsToContracts(map['contracts']) : [],
      feedback: map['feedback'] != null ? Feedback.fromMap(map['feedback']) : null,
      includePoses: map['includePoses'] != null ? map['includePoses'] : false,
      includeInvoice: map['includeInvoice'] != null ? map['includeInvoice'] : false,
      includeContract: map['includeContract'] != null ? map['includeContract'] : false,
      includeQuestionnaires: map['includeQuestionnaires'] != null ? map['includeQuestionnaires'] : false,
    );
  }

  List<Map<String, dynamic>> convertQuestionnairesToMap(List<Questionnaire>? questionnaires){
    List<Map<String, dynamic>> listOfMaps = [];
    if(questionnaires != null) {
      for(Questionnaire questionnaire in questionnaires){
        listOfMaps.add(questionnaire.toMap());
      }
    }
    return listOfMaps;
  }

  static List<Questionnaire> convertMapsToQuestionnaires(List listOfMaps){
    List<Questionnaire> listOfQuestionnaires = [];
    for(Map map in listOfMaps){
      listOfQuestionnaires.add(Questionnaire.fromMap(map as Map<String,dynamic>));
    }
    return listOfQuestionnaires;
  }

  List<Map<String, dynamic>> convertContractsToMap(List<Contract>? contracts){
    List<Map<String, dynamic>> listOfMaps = [];
    if(contracts != null) {
      for(Contract contract in contracts){
        listOfMaps.add(contract.toMap());
      }
    }
    return listOfMaps;
  }

  static List<Contract> convertMapsToContracts(List listOfMaps){
    List<Contract> listOfContracts = [];
    for(Map map in listOfMaps){
      listOfContracts.add(Contract.fromMap(map as Map<String,dynamic>));
    }
    return listOfContracts;
  }
}