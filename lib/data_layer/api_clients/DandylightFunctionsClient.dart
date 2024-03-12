import 'dart:convert';

import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class DandylightFunctionsApi {
  final _baseUrl = 'https://us-central1-clientsafe-21962.cloudfunctions.net';

  final http.Client httpClient;
  DandylightFunctionsApi({
    required this.httpClient,
  }) : assert(httpClient != null);

  Future<Job> fetchJob(String userId, String jobId) async {
    final url = '$_baseUrl/getJob/?userId=$userId&jobId=$jobId';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json'
    };
    final response = await this.httpClient.get(Uri.parse(url), headers: requestHeaders);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return Job.fromMap(json);
  }

  Future<Profile> fetchProfile(String userId, String jobId) async {
    final url = '$_baseUrl/getProfile/?userId=$userId&jobId=$jobId';
    final response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return Profile.fromMap(json);
  }

  Future<int> saveClientSignature(String userId, String jobId, String clientSignature) async {
    final url = '$_baseUrl/saveClientSignature/?userId=$userId&jobId=$jobId&clientSignature=$clientSignature';
    final response = await this.httpClient.put(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    return response.statusCode;
  }

  Future<int> updateInvoiceAsPaid(String userId, String jobId, String invoiceId, bool isPaid, double balancePaidAmount, double unpaidAmount) async {
    final url = '$_baseUrl/updateInvoiceAsPaid/?userId=$userId&jobId=$jobId&invoiceId=$invoiceId&isPaid=$isPaid&balancePaidAmount=$balancePaidAmount&unpaidAmount=$unpaidAmount';
    final response = await this.httpClient.put(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    return response.statusCode;
  }

  Future<int> updateInvoiceAsDepositPaid(String userId, String jobId, String invoiceId, bool isPaid, double unpaidAmount) async {
    final url = '$_baseUrl/updateInvoiceDepositAsPaid/?userId=$userId&jobId=$jobId&invoiceId=$invoiceId&isPaid=$isPaid&unpaidAmount=$unpaidAmount';
    final response = await this.httpClient.put(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    return response.statusCode;
  }
}