import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:intl/intl.dart';

import '../models/Contract.dart';
import '../models/Job.dart';
import '../models/Profile.dart';
import 'TextFormatterUtil.dart';

class ContractUtils {

  static String populate(Contract contract, Profile profile, Job job) {
    String populatedJsonTerms = '';
    String contractJson = contract.jsonTerms!;
    quill.Document document = quill.Document.fromJson(jsonDecode(contractJson));
    document = replaceDataItems(document, profile, job, contract);
    populatedJsonTerms = jsonEncode(document.toDelta().toJson());
    return populatedJsonTerms;
  }

  static String populateForPdf(Job job, Profile profile, Contract contract) {
    String populatedJsonTerms = '';
    String contractJson = contract.jsonTerms!;
    quill.Document document = quill.Document.fromJson(jsonDecode(contractJson));
    document = replaceDataItems(document, profile, job, contract);
    populatedJsonTerms = document.toPlainText();
    return populatedJsonTerms;
  }

  static quill.Document replaceDataItems(quill.Document document, Profile profile, Job job, Contract contract) {
    replaceAll(document, Job.DETAIL_BUSINESS_NAME, profile.businessName != null ? profile.businessName! : 'Photographer');
    replaceAll(document, Job.DETAIL_PHOTOGRAPHER_NAME, (profile.firstName != null ? profile.firstName : 'Photographer')! + (profile.lastName != null ? ' ' + profile.lastName! : ''));
    replaceAll(document, Job.DETAIL_CLIENT_NAME, job.clientName != null ? job.clientName! : 'Client');
    replaceAll(document, Job.DETAIL_CLIENT_PHONE, job.client != null && job.client!.phone != null ? job.client!.phone! : 'Client phone: N/A');
    replaceAll(document, Job.DETAIL_CLIENT_EMAIL, job.client != null && job.client!.email != null ? job.client!.email! : 'Client email: N/A');
    replaceAll(document, Job.DETAIL_LOCATION_ADDRESS, job.location != null && job.location!.address != null ? job.location!.address! : 'TBD');
    replaceAll(document, Job.DETAIL_SESSION_DATE, job.selectedDate != null ? DateFormat('EEE, MMMM dd, yyyy').format(job.selectedDate!) : 'TBD');
    replaceAll(document, Job.DETAIL_RETAINER_DUE_DATE, job.invoice != null && job.invoice!.depositDueDate != null ? DateFormat('EEE, MMMM dd, yyyy').format(job.invoice!.depositDueDate!) : 'TBD');
    replaceAll(document, Job.DETAIL_TOTAL_DUE_DATE, job.invoice != null && job.invoice!.dueDate != null ? DateFormat('EEE, MMMM dd, yyyy').format(job.invoice!.dueDate!) : 'TBD');
    replaceAll(document, Job.DETAIL_RETAINER_PRICE, job.invoice != null && job.invoice!.depositAmount != null ? TextFormatterUtil.formatDecimalCurrency(job.invoice!.depositAmount!) : job.invoice == null && job.sessionType != null && job.sessionType!.deposit != null ? TextFormatterUtil.formatDecimalCurrency(job.sessionType!.deposit!) : 'TBD');
    replaceAll(document, Job.DETAIL_TOTAL, job.invoice != null && job.invoice!.total != null ? TextFormatterUtil.formatDecimalCurrency(job.invoice!.total!) : job.invoice == null && job.sessionType != null ? TextFormatterUtil.formatDecimalCurrency(job.sessionType!.getTotalPlusTax()) : 'N/A');
    replaceAll(document, Job.DETAIL_EFFECTIVE_DATE, contract.firstSharedDate != null ? DateFormat('EEE, MMMM dd, yyyy').format(contract.firstSharedDate!) : DateFormat('EEE, MMMM dd, yyyy').format(DateTime.now()));
    replaceAll(document, Job.DETAIL_START_TIME, job.selectedTime != null ? DateFormat('h:mm a').format(job.selectedTime!) : 'TBD');
    replaceAll(document, Job.DETAIL_END_TIME, job.selectedEndTime != null ? DateFormat('h:mm a').format(job.selectedEndTime!) : 'TBD');
    replaceAll(document, Job.DETAIL_PHOTOGRAPHER_EMAIL, profile.email != null && profile.email!.isNotEmpty ? profile.email! : 'Photographer email: N/A');
    replaceAll(document, Job.DETAIL_PHOTOGRAPHER_PHONE, profile.phone != null && profile.phone!.isNotEmpty ? profile.phone! : 'Photographer phone: N/A');
    replaceAll(document, Job.DETAIL_REMAINING_BALANCE,  job.invoice != null ? TextFormatterUtil.formatDecimalCurrency(job.invoice!.total! - job.invoice!.depositAmount!) : job.invoice == null ? job.sessionType != null ? TextFormatterUtil.formatDecimalCurrency(job.sessionType!.getTotalPlusTax() - job.sessionType!.deposit!) : 'N/A' : 'N/A');
    return document;
  }

  static void replaceAll(quill.Document document, String item, String replacement) {
    while((document.search(item)).length > 0) {
      int matchOffset = document.search(item).first;
      document.replace(matchOffset, item.length, replacement);
    }
  }
}