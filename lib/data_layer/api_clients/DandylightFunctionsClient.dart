import 'dart:convert';

import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:http/http.dart' as http;

import '../../models/PendingEmail.dart';
class DandylightFunctionsApi {
  final _baseUrl = 'https://us-central1-clientsafe-21962.cloudfunctions.net';

  final http.Client? httpClient;
  DandylightFunctionsApi({
    required this.httpClient,
  }) : assert(httpClient != null);

  Future<Job> fetchJob(String userId, String jobId) async {
    final url = '$_baseUrl/getJob/?userId=$userId&jobId=$jobId';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json'
    };
    final response = await httpClient!.get(Uri.parse(url), headers: requestHeaders);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return Job.fromMap(json);
  }

  Future<Questionnaire> fetchQuestionnaire(String userId, String questionnaireId) async {
    final url = '$_baseUrl/getQuestionnaire/?userId=$userId&questionnaireId=$questionnaireId';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json'
    };
    final response = await httpClient!.get(Uri.parse(url), headers: requestHeaders);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return Questionnaire.fromMap(json);
  }

  Future<Profile> fetchProfile(String userId, String? jobId) async {
    final url = '$_baseUrl/getProfile/?userId=$userId&jobId=$jobId';
    final response = await httpClient!.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return Profile.fromMap(json);
  }

  Future<int> saveClientSignature(String userId, String jobId, String clientSignature, String? contractDocumentId) async {
    contractDocumentId ??= 'null';
    final url = '$_baseUrl/saveClientSignature/?userId=$userId&jobId=$jobId&clientSignature=$clientSignature&contractId=$contractDocumentId';
    final response = await httpClient!.put(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    return response.statusCode;
  }

  Future<int> updateInvoiceAsPaid(String userId, String jobId, String invoiceId, bool isPaid, double balancePaidAmount, double unpaidAmount) async {
    final url = '$_baseUrl/updateInvoiceAsPaid/?userId=$userId&jobId=$jobId&invoiceId=$invoiceId&isPaid=$isPaid&balancePaidAmount=$balancePaidAmount&unpaidAmount=$unpaidAmount';
    final response = await httpClient!.put(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    return response.statusCode;
  }

  Future<int> updateInvoiceAsDepositPaid(String userId, String jobId, String invoiceId, bool isPaid, double unpaidAmount) async {
    final url = '$_baseUrl/updateInvoiceDepositAsPaid/?userId=$userId&jobId=$jobId&invoiceId=$invoiceId&isPaid=$isPaid&unpaidAmount=$unpaidAmount';
    final response = await httpClient!.put(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    return response.statusCode;
  }

  Future<int> updateQuestionnaire(String userId, String jobId, Questionnaire questionnaire, bool alreadyComplete) async {
    final url = '$_baseUrl/updateQuestionnaire/?userId=$userId&jobId=$jobId&alreadyComplete=$alreadyComplete';
    final response = await httpClient!.put(
        Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(questionnaire)
    );

    if (response.statusCode != 200) {
      throw Exception('error getting quotes - Status = ${response.statusCode}\n${jsonEncode(questionnaire)}');
    } else {
      print('Update questionnaire response - ${response.statusCode}\n${jsonEncode(questionnaire)}');
    }

    return response.statusCode;
  }

  Future<int> updateQuestionnaireDirectSend(String userId, Questionnaire questionnaire, bool alreadyComplete) async {
    final url = '$_baseUrl/updateQuestionnaireDirectSend/?userId=$userId&alreadyComplete=$alreadyComplete';
    final response = await httpClient!.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(questionnaire)
    );

    if (response.statusCode != 200) {
      throw Exception('error getting quotes - Status = ${response.statusCode}\n${jsonEncode(questionnaire)}');
    } else {
      print('Update questionnaire response - ${response.statusCode}\n${jsonEncode(questionnaire)}');
    }

    return response.statusCode;
  }

  Future<int> sendEmailToUserNow(PendingEmail pendingEmail) async {
    final url = '$_baseUrl/sendEmailNow';
    final response = await httpClient!.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pendingEmail)
    );

    if (response.statusCode != 200 || response.statusCode != 202) {
      throw Exception('error getting quotes - Status = ${response.statusCode}\n${jsonEncode(pendingEmail)}');
    } else {
      print('Update questionnaire response success - ${response.statusCode}\n${jsonEncode(pendingEmail)}');
    }

    return response.statusCode;
  }
}