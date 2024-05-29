import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Questionnaire.dart';

import '../../models/Profile.dart';
import '../api_clients/DandylightFunctionsClient.dart';
import 'package:meta/meta.dart';

class ClientPortalRepository {
  final DandylightFunctionsApi functions;

  ClientPortalRepository({required this.functions});

  Future<Job> fetchJob(String userId, String jobId) async {
    return await functions.fetchJob(userId, jobId);
  }

  Future<Questionnaire> fetchQuestionnaire(String userId, String questionnaireId) async {
    return await functions.fetchQuestionnaire(userId, questionnaireId);
  }

  Future<Profile> fetchProfile(String userId, String? jobId) async {
    return await functions.fetchProfile(userId, jobId);
  }

  Future<int> saveClientSignature(String userId, String jobId, String clientSignature, String? contractDocumentId) async {
    return await functions.saveClientSignature(userId, jobId, clientSignature, contractDocumentId);
  }

  Future<int> updateInvoiceAsPaid(String userId, String jobId, String invoiceId, bool isPaid, double balancePaidAmount, double unpaidAmount) async {
    return await functions.updateInvoiceAsPaid(userId, jobId, invoiceId, isPaid, balancePaidAmount, unpaidAmount);
  }

  Future<int> updateInvoiceAsDepositPaid(String userId, String jobId, String invoiceId, bool isPaid, double unpaidAmount) async {
    return await functions.updateInvoiceAsDepositPaid(userId, jobId, invoiceId, isPaid, unpaidAmount);
  }

  Future<int> updateQuestionnaire(String userId, String jobId, Questionnaire questionnaire, bool alreadyComplete) async {
    return await functions.updateQuestionnaire(userId, jobId, questionnaire, alreadyComplete);
  }

  Future<int> updateQuestionnaireDirectSend(String userId, Questionnaire questionnaire, bool alreadyComplete) async {
    return await functions.updateQuestionnaireDirectSend(userId, questionnaire, alreadyComplete);
  }
}